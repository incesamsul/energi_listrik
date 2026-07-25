import 'package:flutter/material.dart';

/// Jenis komponen listrik yang bisa diseret ke papan rangkaian.
enum ComponentType { baterai, kabel, lampu, saklar, konduktor, isolator }

extension ComponentTypeLabel on ComponentType {
  String get label {
    switch (this) {
      case ComponentType.baterai:
        return 'Baterai';
      case ComponentType.kabel:
        return 'Kabel';
      case ComponentType.lampu:
        return 'Lampu';
      case ComponentType.saklar:
        return 'Saklar';
      case ComponentType.konduktor:
        return 'Logam';
      case ComponentType.isolator:
        return 'Plastik';
    }
  }
}

/// Komponen yang sudah terpasang tetap di papan (tidak bisa diseret).
class FixedComp {
  final ComponentType type;
  final Offset pos; // posisi pecahan 0..1 pada papan
  const FixedComp(this.type, this.pos);
}

/// Lubang kosong yang harus diisi komponen bertipe [required].
class Holder {
  final ComponentType required;
  final Offset pos; // posisi pecahan 0..1 pada papan
  const Holder(this.required, this.pos);
}

/// Materi konsep singkat yang muncul setelah level selesai.
class Concept {
  final String title;
  final String body;
  const Concept(this.title, this.body);
}

class Level {
  final int id;
  final String title;
  final String instruction;
  final List<FixedComp> fixed;
  final List<Holder> holders;
  final List<ComponentType> tray; // pilihan komponen (termasuk pengecoh)
  final Concept concept;

  const Level({
    required this.id,
    required this.title,
    required this.instruction,
    required this.fixed,
    required this.holders,
    required this.tray,
    required this.concept,
  });
}
