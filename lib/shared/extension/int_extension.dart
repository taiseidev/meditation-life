extension IntExtension on int {
  String formatTime() {
    final minutes = (this / 60).floor();
    final remainingSeconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}'
        ':${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
