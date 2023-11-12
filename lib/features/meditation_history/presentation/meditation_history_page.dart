import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/int_extension.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/utils/ad_mob_util.dart';
import 'package:meditation_life/core/utils/local_time_zone_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/core/utils/vibration.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_notifier.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class MeditationHistoryPage extends HookConsumerWidget {
  MeditationHistoryPage({super.key});

  final adBanner = AdBannerService();
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

    useEffect(() {
      adBanner.create();
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.meditationHistoryTitle,
        ),
      ),
      body: switch (state) {
        AsyncData(:final value) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: adBanner.bannerAd != null
                    ? SizedBox(
                        width: adBanner.bannerAd!.size.width.toDouble(),
                        height: adBanner.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: adBanner.bannerAd!),
                      )
                    : const SizedBox.shrink(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value.month(pageMonth.value).toString(),
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        Strings.monthlyMeditationProgress,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        value.events.length.toString(),
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/${value.daysInMonth(pageMonth.value)}日',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  indent: 24,
                  endIndent: 24,
                ),
              ),
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
                      await Vibration.feedBack();
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
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return _Events(date, events);
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  indent: 24,
                  endIndent: 24,
                ),
              ),
              SliverList.builder(
                itemCount: value
                    .getMeditationHistoryForDate(
                      selectedDay.value,
                    )
                    .length,
                itemBuilder: (context, index) {
                  final item = value.getMeditationHistoryForDate(
                    selectedDay.value,
                  )[index];
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

class _Events extends StatelessWidget {
  const _Events(
    this.date,
    this.events,
  );

  final DateTime date;
  final List<dynamic> events;

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
