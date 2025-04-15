import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/date_time_ext.dart';
import 'package:meditation_life/core/extension/int_extension.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/utils/ad_mob_util.dart';
import 'package:meditation_life/core/utils/local_time_zone_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_notifier.dart';
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

  final _divider = const SliverToBoxAdapter(
    child: Divider(
      indent: 24,
      endIndent: 24,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(meditationHistoryNotifierProvider);

    final focusedDay = useState(now);
    final selectedDay = useState<DateTime>(now);
    final pageMonth = useState<DateTime>(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.meditationHistoryTitle),
      ),
      body: switch (state) {
        AsyncData(:final value) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Banner(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _MonthlyMeditationSummary(
                    month: pageMonth.value.month.toString(),
                    monthlyMeditationCount: value.events.length.toString(),
                    days: pageMonth.value.daysInMonth(),
                  ),
                ),
              ),
              _divider,
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: TableCalendar(
                    calendarStyle: CalendarStyle(
                      defaultDecoration: BoxDecoration(
                        color: AppColor.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      weekendTextStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: AppColor.secondary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColor.secondary.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      // 2 weeksボタンを非表示
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: AppColor.secondary,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: AppColor.secondary,
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
              _divider,
              SliverList.builder(
                itemCount: ref
                    .watch(meditationHistoriesOnDateProvider(selectedDay.value))
                    .length,
                itemBuilder: (context, index) {
                  final item = ref.watch(
                    meditationHistoriesOnDateProvider(selectedDay.value),
                  )[index];
                  return _ListItem(item);
                },
              ),
            ],
          ),
        AsyncError() => const Center(
            child: Text('エラーが発生しました。'),
          ),
        _ => const Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          ),
      },
    );
  }
}

// TODO(taisei): リファクタ
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
        ? SizedBox(
            width: adBanner.bannerAd!.size.width.toDouble(),
            height: adBanner.bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: adBanner.bannerAd!),
          )
        : const SizedBox.shrink();
  }
}

class _MonthlyMeditationSummary extends StatelessWidget {
  _MonthlyMeditationSummary({
    required this.month,
    required this.monthlyMeditationCount,
    required this.days,
  });

  final String month;
  final String monthlyMeditationCount;
  final int days;

  static const boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  final bold24TextStyle = boldTextStyle.copyWith(
    color: AppColor.secondary,
    fontSize: 24,
  );

  final bold12TextStyle = boldTextStyle.copyWith(
    fontSize: 12,
  );

  String get totalDaysInMonth => '/$days日';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          month,
          style: bold24TextStyle,
        ),
        Text(
          Strings.monthlyMeditationProgress,
          style: bold12TextStyle,
        ),
        const SizedBox(width: 40),
        Text(
          monthlyMeditationCount,
          style: bold24TextStyle,
        ),
        Text(
          totalDaysInMonth,
          style: bold12TextStyle,
        ),
      ],
    );
  }
}

@riverpod
Meditation _currentItem(_CurrentItemRef ref) => throw UnimplementedError();

class _ListItem extends StatelessWidget {
  const _ListItem(this.item);

  final Meditation item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: item.thumbnailUrl,
          width: 100,
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '時間：${item.duration.formatTime()}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
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
        color: AppColor.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      width: 15,
      height: 15,
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
