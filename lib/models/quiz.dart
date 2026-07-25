/// Satu butir soal kuis. [correctIndex] menunjuk jawaban benar pada
/// daftar [options] versi asli (sebelum diacak).
class Question {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  const Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  /// Teks jawaban benar. Dipakai untuk mencocokkan setelah opsi diacak
  /// oleh Fisher-Yates, sehingga indeks lama tak lagi relevan.
  String get correctAnswer => options[correctIndex];
}
