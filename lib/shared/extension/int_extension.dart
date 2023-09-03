extension IntExtension on int {
  String formatTime() {
    int minutes = (this / 60).floor();
    int remainingSeconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
