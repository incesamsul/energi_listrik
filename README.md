# Energi Listrik — Game Edukasi (MDLC, Android)

Game edukasi pengenalan energi listrik untuk siswa Sekolah Dasar. Implementasi
dari proposal *"Perancangan Game Edukasi Pengenalan Energi Listrik Menggunakan
Metode MDLC Berbasis Android"* (Deswin Dara).

Dibangun dengan **Flutter (Dart)**, target **Android**.

## Alur permainan

Menu Utama → Cara Bermain / Pilih Level → Gameplay drag-and-drop menyusun
rangkaian listrik → Cek → Rangkaian Berhasil → Penjelasan Konsep → level
berikutnya. Setelah semua level tuntas, **Kuis** terbuka.

### Level

| # | Judul | Konsep |
|---|-------|--------|
| 1 | Rangkaian Tertutup | Arus mengalir bila jalur tersambung penuh |
| 2 | Saklar | Memutus / menyambung arus |
| 3 | Konduktor | Logam menghantarkan listrik, isolator tidak |
| 4 | Rangkaian Seri | Komponen berurutan dalam satu jalur |

## Peta ke metode proposal

- **MDLC**: Concept (analisis PIECES, kebutuhan) → Design (storyboard, flowchart,
  UML) → Material Collecting (ikon, konsep) → Assembly (kode ini) → Testing
  (blackbox) → Distribution (APK).
- **Fisher-Yates Shuffle**: `lib/util/fisher_yates.dart`. Dipakai di
  `lib/screens/quiz_screen.dart` untuk mengacak urutan soal dan urutan pilihan
  jawaban tiap kali kuis dimainkan, agar siswa tidak menghafal pola.

## Struktur kode

```
lib/
  main.dart                 titik masuk
  theme/app_theme.dart      palet warna, tipografi, spacing, motion
  util/fisher_yates.dart    algoritma Fisher-Yates
  models/                   level.dart, quiz.dart
  data/                     levels.dart (4 level), questions.dart (bank soal)
  state/progress.dart       progres tersimpan (SharedPreferences)
  widgets/                  circuit_board, component_chip, component_painter, app_button
  screens/                  menu, how_to_play, level_select, game, concept, quiz
```

## Desain

- Warna committed (OKLCH-derived): chrome kertas hangat, papan rangkaian navy
  agar cahaya lampu amber menonjol. Tanpa gradient, tanpa emoji.
- Ikon komponen (baterai, kabel, lampu, saklar, logam, plastik) digambar
  tangan via `CustomPainter`.
- Font: Nunito (teks) + Fredoka (judul), keduanya di-bundle sebagai aset.

## Menjalankan

```bash
flutter pub get
flutter run                 # ke perangkat / emulator
flutter build apk --release # hasil: build/app/outputs/flutter-apk/app-release.apk
```

## Catatan

- Efek suara belum disertakan (storyboard menyebut umpan balik bunyi); umpan
  balik saat ini visual (glow lampu) + haptic. Bisa ditambah dengan paket
  `audioplayers` dan aset audio.
- APK release ditandatangani memakai kunci debug default Flutter (cukup untuk
  demo/sidang). Untuk rilis publik, siapkan keystore sendiri.
