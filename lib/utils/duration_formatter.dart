class DurationFormatter {

  // Форматирование даты
  static String formatDuration(int value) =>
      '${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).toString().padLeft(2, '0')}';

}