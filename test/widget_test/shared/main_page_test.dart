import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_page.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_page.dart';
import 'package:meditation_life/shared/main_page.dart';

void main() {
  testWidgets('MainPage Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: MainPage()));

    // Verify if FloatingActionButton is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify if AnimatedBottomNavigationBar is present.
    expect(find.byType(AnimatedBottomNavigationBar), findsOneWidget);

    // Widgetが破棄された後もAnimationController（AnimatedBottomNavigationBar内部）が破棄されていないっぽい
    // Tap the FloatingActionButton.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify if the page changes to MeditationView when the FloatingActionButton is tapped.
    expect(find.byType(MeditationPage), findsOneWidget);

    // Tap the AnimatedBottomNavigationBar.
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    // Verify if the page changes to MeditationHistoryView when the AnimatedBottomNavigationBar is tapped.
    expect(find.byType(MeditationHistoryPage), findsOneWidget);
  });
}
