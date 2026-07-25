import 'package:flutter/material.dart';

/// Palet warna. Strategi "committed": kertas hangat sebagai chrome,
/// papan rangkaian navy gelap agar cahaya lampu amber menonjol.
/// Diturunkan dari OKLCH, tanpa gradient, tanpa hitam/putih murni.
class AppColors {
  static const surface = Color(0xFFF6F3EC); // kertas krem hangat
  static const surfaceDim = Color(0xFFECE7DC); // panel
  static const line = Color(0xFFDAD5C8); // garis pembatas
  static const ink = Color(0xFF262A33); // teks utama (charcoal hangat)
  static const inkSoft = Color(0xFF5A5F6B); // teks sekunder

  static const boardBg = Color(0xFF1E2230); // panggung rangkaian (navy)
  static const boardLine = Color(0xFF3A4152); // kawat redup
  static const boardSlot = Color(0xFF272C3B); // lubang slot kosong

  static const primary = Color(0xFFEFA82E); // amber: energi / aksi
  static const primaryDark = Color(0xFFC9851A); // amber ditekan
  static const glow = Color(0xFFFFC554); // lampu menyala

  static const success = Color(0xFF2FA98C); // benar
  static const danger = Color(0xFFD65A3E); // salah
  static const locked = Color(0xFFC3C0B6); // terkunci
}

/// Jarak berirama, bukan padding seragam.
class Gap {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 36.0;
  static const xxl = 56.0;
}

class AppRadius {
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 22.0;
  static const pill = 999.0;
}

/// Kurva ease-out eksponensial. Tanpa bounce.
const Curve kEaseOut = Curves.easeOutQuart;
const Duration kFast = Duration(milliseconds: 220);
const Duration kMed = Duration(milliseconds: 420);

class AppTheme {
  static ThemeData build() {
    const heading = 'Fredoka';
    const body = 'Nunito';

    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.ink,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.danger,
      ),
      fontFamily: body,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontFamily: heading,
          fontWeight: FontWeight.w600,
          fontSize: 40,
          height: 1.05,
          letterSpacing: -0.5,
          color: AppColors.ink,
        ),
        headlineMedium: const TextStyle(
          fontFamily: heading,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          height: 1.1,
          color: AppColors.ink,
        ),
        titleLarge: const TextStyle(
          fontFamily: heading,
          fontWeight: FontWeight.w500,
          fontSize: 21,
          color: AppColors.ink,
        ),
        bodyLarge: const TextStyle(
          fontFamily: body,
          fontSize: 17,
          height: 1.5,
          color: AppColors.ink,
        ),
        bodyMedium: const TextStyle(
          fontFamily: body,
          fontSize: 15,
          height: 1.5,
          color: AppColors.inkSoft,
        ),
        labelLarge: const TextStyle(
          fontFamily: heading,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
