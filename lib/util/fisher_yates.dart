import 'dart:math';

/// Algoritma Fisher-Yates Shuffle (Knuth, 1997).
///
/// Mengacak urutan elemen daftar secara adil: setiap permutasi punya
/// peluang sama. Berjalan O(n), in-place. Dipakai untuk mengacak urutan
/// soal kuis dan urutan pilihan jawaban agar siswa tidak menghafal pola.
///
/// Prinsip: dari elemen terakhir ke elemen kedua, tukar elemen ke-i
/// dengan elemen acak pada rentang [0, i].
List<T> fisherYatesShuffle<T>(List<T> source, {Random? random}) {
  final rng = random ?? Random();
  final list = List<T>.of(source); // salin agar sumber tidak berubah
  for (int i = list.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1); // 0 <= j <= i
    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
  return list;
}
