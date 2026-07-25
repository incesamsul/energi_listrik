import '../models/quiz.dart';

/// Bank soal kuis pengenalan energi listrik. Urutan soal dan urutan
/// pilihan diacak saat runtime memakai Fisher-Yates.
const List<Question> kQuestions = [
  Question(
    prompt: 'Rangkaian yang jalurnya tersambung penuh membentuk loop disebut?',
    options: [
      'Rangkaian tertutup',
      'Rangkaian terbuka',
      'Rangkaian putus',
      'Rangkaian kosong',
    ],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Komponen yang memutus dan menyambung arus listrik adalah?',
    options: ['Saklar', 'Baterai', 'Lampu', 'Kabel'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Bahan yang dapat menghantarkan listrik disebut?',
    options: ['Konduktor', 'Isolator', 'Magnet', 'Cahaya'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Contoh bahan isolator yang tidak menghantarkan listrik adalah?',
    options: ['Plastik', 'Besi', 'Tembaga', 'Emas'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Sumber energi listrik pada rangkaian sederhana adalah?',
    options: ['Baterai', 'Lampu', 'Kabel', 'Saklar'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Apa yang terjadi jika rangkaian terbuka atau jalurnya putus?',
    options: [
      'Lampu padam',
      'Lampu menyala terang',
      'Baterai bertambah',
      'Kabel memanjang',
    ],
    correctIndex: 0,
  ),
];
