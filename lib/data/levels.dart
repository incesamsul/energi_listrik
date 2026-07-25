import 'package:flutter/material.dart';
import '../models/level.dart';

/// Empat level bertahap: rangkaian tertutup, saklar, konduktor, seri.
/// Posisi memakai koordinat pecahan pada persegi kawat papan.
const List<Level> kLevels = [
  Level(
    id: 1,
    title: 'Rangkaian Tertutup',
    instruction: 'Lengkapi rangkaian agar lampu menyala.',
    fixed: [
      FixedComp(ComponentType.baterai, Offset(0.5, 0.9)),
    ],
    holders: [
      Holder(ComponentType.lampu, Offset(0.5, 0.1)),
      Holder(ComponentType.kabel, Offset(0.08, 0.5)),
    ],
    tray: [ComponentType.lampu, ComponentType.kabel, ComponentType.saklar],
    concept: Concept(
      'Rangkaian Tertutup',
      'Arus listrik hanya mengalir bila jalurnya tersambung penuh membentuk '
          'lingkaran (loop). Jika ada jalur yang putus, arus berhenti dan '
          'lampu tidak menyala.',
    ),
  ),
  Level(
    id: 2,
    title: 'Saklar',
    instruction: 'Pasang saklar agar arus bisa dialirkan.',
    fixed: [
      FixedComp(ComponentType.baterai, Offset(0.5, 0.9)),
      FixedComp(ComponentType.lampu, Offset(0.5, 0.1)),
    ],
    holders: [
      Holder(ComponentType.saklar, Offset(0.92, 0.5)),
      Holder(ComponentType.kabel, Offset(0.08, 0.5)),
    ],
    tray: [ComponentType.saklar, ComponentType.kabel, ComponentType.lampu],
    concept: Concept(
      'Saklar',
      'Saklar memutus atau menyambung arus listrik. Saklar tertutup membuat '
          'arus mengalir sehingga lampu menyala. Saklar terbuka memutus arus '
          'dan lampu padam.',
    ),
  ),
  Level(
    id: 3,
    title: 'Konduktor',
    instruction: 'Pilih bahan yang bisa menghantarkan listrik.',
    fixed: [
      FixedComp(ComponentType.baterai, Offset(0.5, 0.9)),
      FixedComp(ComponentType.lampu, Offset(0.5, 0.1)),
      FixedComp(ComponentType.kabel, Offset(0.08, 0.5)),
    ],
    holders: [
      Holder(ComponentType.konduktor, Offset(0.92, 0.5)),
    ],
    tray: [ComponentType.konduktor, ComponentType.isolator],
    concept: Concept(
      'Konduktor',
      'Konduktor adalah bahan yang dapat menghantarkan arus listrik, '
          'contohnya logam seperti besi dan tembaga. Bahan isolator seperti '
          'plastik dan karet tidak menghantarkan listrik.',
    ),
  ),
  Level(
    id: 4,
    title: 'Rangkaian Seri',
    instruction: 'Susun dua lampu dalam satu jalur rangkaian.',
    fixed: [
      FixedComp(ComponentType.baterai, Offset(0.5, 0.9)),
    ],
    holders: [
      Holder(ComponentType.lampu, Offset(0.3, 0.1)),
      Holder(ComponentType.lampu, Offset(0.7, 0.1)),
      Holder(ComponentType.kabel, Offset(0.08, 0.5)),
    ],
    tray: [ComponentType.lampu, ComponentType.kabel, ComponentType.saklar],
    concept: Concept(
      'Rangkaian Seri',
      'Pada rangkaian seri, komponen disusun berurutan dalam satu jalur. '
          'Arus yang sama mengalir melewati semua komponen. Bila satu lampu '
          'putus, lampu lain ikut padam.',
    ),
  ),
];
