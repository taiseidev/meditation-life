import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_notifier.dart';
import 'package:table_calendar/table_calendar.dart';

class MeditationHistoryPage extends ConsumerWidget {
  const MeditationHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(meditationHistoryNotifierProvider);

    Widget buildEventsMarker(
      DateTime date,
      List events,
    ) =>
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffADD8E6),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          width: 15,
          height: 15,
          child: Text(
            "${events.length}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '瞑想履歴',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: state.when(
        data: (histories) => CustomScrollView(
          slivers: [
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
                      "${histories.month} ",
                      style: const TextStyle(
                        color: Color(0xff00a497),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "月の瞑想進捗",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                    Text(
                      "${histories.events.length} ",
                      style: const TextStyle(
                        color: Color(0xff00a497),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "/${histories.daysInMonth}日",
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
                      color: const Color(0xff00a497).withOpacity(0.1),
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
                      color: Color(0xff00a497),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color(0xff00a497).withOpacity(0.6),
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
                      color: Color(0xff00a497),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xff00a497),
                    ),
                  ),
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: DateTime.now(),
                  locale: 'ja_JP',
                  eventLoader: (date) {
                    return histories
                            .events["${date.year}/${date.month}/${date.day}"] ??
                        [];
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return buildEventsMarker(date, events);
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
              itemCount: histories
                  .getMeditationHistoryForDate(DateTime(2023, 9, 2))
                  .length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
                      width: 100,
                    ),
                  ),
                  title: const Text(
                    "星の記憶",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '時間：${formatTime(180)}',
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
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
