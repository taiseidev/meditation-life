extension DateTimeExt on DateTime {
  /// 与えられた月の日数を返します。
  int daysInMonth() {
    // 翌月の初日を取得して、その前日（つまり現在の月の最終日）を求める
    final firstDayOfNextMonth = DateTime(year, month + 1);
    final lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }
}
