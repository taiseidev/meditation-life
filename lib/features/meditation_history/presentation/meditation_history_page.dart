import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MeditationHistoryPage extends StatelessWidget {
  const MeditationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('瞑想履歴'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: DateTime.now(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
                        width: 100,
                      ),
                    ),
                    title: const Text("星の記憶"),
                    subtitle: const Text('180 minutes'),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
