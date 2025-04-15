import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meditation_life/core/extension/date_time_ext.dart';
import 'package:meditation_life/core/extension/int_extension.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/utils/ad_mob_util.dart';
import 'package:meditation_life/core/utils/local_time_zone_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_notifier.dart';
import 'package:meditation_life/shared/widgets/common_app_bar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

part 'meditation_history_page.g.dart';

class MeditationHistoryPage extends HookConsumerWidget {
  MeditationHistoryPage({super.key});

  final now = tz.TZDateTime.now(
    tz.getLocation(
      LocalTimeZoneUtil.localTimeZone,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(meditationHistoryNotifierProvider);

    final focusedDay = useState(now);
    final selectedDay = useState<DateTime>(now);
    final pageMonth = useState<DateTime>(now);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: const CommonAppBar(title: Strings.meditationHistoryTitle),
      body: switch (state) {
        AsyncData(:final value) => SingleChildScrollView(
            child: Column(
              children: [
                // Ad banner
                _Banner(),

                // Monthly summary card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Month title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('yyyy年M月').format(pageMonth.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppColor.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Stats
                          _MonthlyMeditationSummary(
                            monthlyMeditationCount: value.events.length,
                            days: pageMonth.value.daysInMonth(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TableCalendar(
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          defaultDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textPrimary,
                          ),
                          weekendTextStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textPrimary.withOpacity(0.7),
                          ),
                          todayDecoration: BoxDecoration(
                            color: AppColor.secondary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.secondary,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: AppColor.secondary,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          outsideTextStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.textSecondary.withOpacity(0.5),
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          leftChevronIcon: const Icon(
                            Icons.chevron_left,
                            color: AppColor.secondary,
                          ),
                          rightChevronIcon: const Icon(
                            Icons.chevron_right,
                            color: AppColor.secondary,
                          ),
                          headerPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: AppColor.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          weekendStyle: TextStyle(
                            color: AppColor.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        firstDay: DateTime.utc(2010),
                        lastDay: DateTime.utc(2030),
                        focusedDay: focusedDay.value,
                        locale: 'ja_JP',
                        eventLoader: (date) {
                          return value.events[
                                  '${date.year}/${date.month}/${date.day}'] ??
                              [];
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(selectedDay.value, day);
                        },
                        onDaySelected: (selectDay, focusDay) async {
                          selectedDay.value = selectDay;
                          focusedDay.value = tz.TZDateTime.from(
                            focusDay,
                            tz.getLocation(LocalTimeZoneUtil.localTimeZone),
                          );
                        },
                        onPageChanged: (focusDay) {
                          pageMonth.value = focusDay;
                          focusedDay.value = tz.TZDateTime.from(
                            focusDay,
                            tz.getLocation(LocalTimeZoneUtil.localTimeZone),
                          );
                          ref
                              .read(meditationHistoryNotifierProvider.notifier)
                              .fetchMeditationListPerMonth(focusDay);
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (_, __, events) {
                            if (events.isEmpty) {
                              return null;
                            }
                            return _Events(events);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Selected day title
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('M月d日').format(selectedDay.value),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'の瞑想',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // History list
                SizedBox(
                  height: 300,
                  child: ref
                          .watch(
                            meditationHistoriesOnDateProvider(
                                selectedDay.value),
                          )
                          .isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: AppColor.textSecondary.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'この日の瞑想記録はありません',
                                style: TextStyle(
                                  color:
                                      AppColor.textSecondary.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: ref
                              .watch(meditationHistoriesOnDateProvider(
                                  selectedDay.value))
                              .length,
                          itemBuilder: (context, index) {
                            final item = ref.watch(
                              meditationHistoriesOnDateProvider(
                                  selectedDay.value),
                            )[index];
                            return _ListItem(item);
                          },
                        ),
                ),
              ],
            ),
          ),
        AsyncError() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColor.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'エラーが発生しました。',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColor.error,
                      ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(meditationHistoryNotifierProvider),
                  child: const Text('再読み込み'),
                ),
              ],
            ),
          ),
        _ => const Center(
            child: CircularProgressIndicator(
              color: AppColor.secondary,
            ),
          ),
      },
    );
  }
}

class _Banner extends HookWidget {
  _Banner();

  final adBanner = AdBannerService();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      adBanner.create();
      return null;
    });

    return adBanner.bannerAd != null
        ? Container(
            width: adBanner.bannerAd!.size.width.toDouble(),
            height: adBanner.bannerAd!.size.height.toDouble(),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: AdWidget(ad: adBanner.bannerAd!),
          )
        : const SizedBox.shrink();
  }
}

class _MonthlyMeditationSummary extends StatelessWidget {
  const _MonthlyMeditationSummary({
    required this.monthlyMeditationCount,
    required this.days,
  });

  final int monthlyMeditationCount;
  final int days;

  // Calculate progress value for CircularProgressIndicator (must return a double between 0.0 and 1.0)
  double _calculateProgressValue() {
    if (days <= 0) return 0.0;
    final ratio = monthlyMeditationCount.toDouble() / days.toDouble();
    return ratio.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = days > 0
        ? (monthlyMeditationCount.toDouble() / days.toDouble()) * 100
        : 0.0;

    return Column(
      children: [
        // Progress indicator
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.secondary.withOpacity(0.1),
              ),
            ),

            // Progress text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$monthlyMeditationCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),
                ),
                Text(
                  '/$days日',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),

            // Progress circle
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: _calculateProgressValue(),
                strokeWidth: 8,
                backgroundColor: AppColor.accent.withOpacity(0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColor.secondary),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Percentage text
        Text(
          '${percentage.toStringAsFixed(1)}% 達成',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        // Motivational text
        Text(
          _getMotivationalText(percentage),
          style: TextStyle(
            fontSize: 14,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getMotivationalText(double percentage) {
    if (percentage >= 90) {
      return '素晴らしい！習慣化できています';
    } else if (percentage >= 70) {
      return '良いペースです！継続しましょう';
    } else if (percentage >= 50) {
      return 'もう少し頑張りましょう';
    } else if (percentage >= 30) {
      return '瞑想の習慣を作りましょう';
    } else {
      return '瞑想を始めましょう';
    }
  }
}

@riverpod
Meditation _currentItem(_CurrentItemRef ref) => throw UnimplementedError();

class _ListItem extends StatelessWidget {
  const _ListItem(this.item);

  final Meditation item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.thumbnailUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColor.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.duration.formatTime(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (item.date != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColor.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('HH:mm').format(item.date!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColor.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Events extends StatelessWidget {
  const _Events(this.events);

  final List<Object?> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      width: 18,
      height: 18,
      child: Text(
        events.length.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
