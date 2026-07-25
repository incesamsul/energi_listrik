import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';

/// Menggambar simbol komponen listrik dengan tangan (bukan emoji, bukan
/// ikon Material). Garis bersih agar terbaca jelas oleh anak.
class ComponentIcon extends StatelessWidget {
  final ComponentType type;
  final double size;
  final Color stroke;
  final bool lit; // khusus lampu: menyala

  const ComponentIcon({
    super.key,
    required this.type,
    this.size = 48,
    this.stroke = AppColors.ink,
    this.lit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ComponentPainter(type: type, stroke: stroke, lit: lit),
      ),
    );
  }
}

class _ComponentPainter extends CustomPainter {
  final ComponentType type;
  final Color stroke;
  final bool lit;
  _ComponentPainter({required this.type, required this.stroke, required this.lit});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final p = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = stroke;

    switch (type) {
      case ComponentType.baterai:
        _battery(canvas, w, h, p, fill);
        break;
      case ComponentType.kabel:
        _wire(canvas, w, h, p, fill);
        break;
      case ComponentType.lampu:
        _bulb(canvas, w, h, p, fill);
        break;
      case ComponentType.saklar:
        _switch(canvas, w, h, p, fill);
        break;
      case ComponentType.konduktor:
        _metal(canvas, w, h, p, fill);
        break;
      case ComponentType.isolator:
        _plastic(canvas, w, h, p, fill);
        break;
    }
  }

  void _battery(Canvas c, double w, double h, Paint p, Paint fill) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.52, h * 0.4),
      Radius.circular(w * 0.05),
    );
    c.drawRRect(r, p);
    // nub terminal +
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.42, w * 0.06, h * 0.16),
        Radius.circular(w * 0.02),
      ),
      fill,
    );
    // simbol + dan -
    final plusC = Offset(w * 0.36, h * 0.5);
    c.drawLine(plusC.translate(-w * 0.05, 0), plusC.translate(w * 0.05, 0), p);
    c.drawLine(plusC.translate(0, -w * 0.05), plusC.translate(0, w * 0.05), p);
    final minusC = Offset(w * 0.56, h * 0.5);
    c.drawLine(minusC.translate(-w * 0.05, 0), minusC.translate(w * 0.05, 0), p);
  }

  void _wire(Canvas c, double w, double h, Paint p, Paint fill) {
    final path = Path()
      ..moveTo(w * 0.14, h * 0.5)
      ..lineTo(w * 0.3, h * 0.5)
      ..cubicTo(w * 0.42, h * 0.5, w * 0.4, h * 0.28, w * 0.5, h * 0.28)
      ..cubicTo(w * 0.6, h * 0.28, w * 0.58, h * 0.72, w * 0.7, h * 0.72)
      ..cubicTo(w * 0.78, h * 0.72, w * 0.76, h * 0.5, w * 0.86, h * 0.5);
    c.drawPath(path, p);
    c.drawCircle(Offset(w * 0.14, h * 0.5), w * 0.035, fill);
    c.drawCircle(Offset(w * 0.86, h * 0.5), w * 0.035, fill);
  }

  void _bulb(Canvas c, double w, double h, Paint p, Paint fill) {
    final center = Offset(w * 0.5, h * 0.42);
    final radius = w * 0.24;
    if (lit) {
      final glow = Paint()
        ..color = AppColors.glow.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      c.drawCircle(center, radius * 1.15, glow);
    }
    final bulbPaint = Paint()
      ..color = lit ? AppColors.glow : stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = p.strokeWidth
      ..strokeCap = StrokeCap.round;
    if (lit) {
      c.drawCircle(center, radius, Paint()..color = AppColors.glow.withValues(alpha: 0.35));
    }
    c.drawCircle(center, radius, bulbPaint);
    // filamen: garis zigzag kecil
    final fp = Path()
      ..moveTo(center.dx - radius * 0.4, center.dy + radius * 0.1)
      ..lineTo(center.dx - radius * 0.15, center.dy - radius * 0.25)
      ..lineTo(center.dx + radius * 0.15, center.dy + radius * 0.25)
      ..lineTo(center.dx + radius * 0.4, center.dy - radius * 0.1);
    c.drawPath(fp, bulbPaint);
    // dasar lampu
    final base = Rect.fromLTWH(w * 0.4, h * 0.66, w * 0.2, h * 0.12);
    c.drawRRect(RRect.fromRectAndRadius(base, Radius.circular(w * 0.02)), p);
    c.drawLine(Offset(w * 0.43, h * 0.82), Offset(w * 0.57, h * 0.82), p);
  }

  void _switch(Canvas c, double w, double h, Paint p, Paint fill) {
    final left = Offset(w * 0.24, h * 0.6);
    final right = Offset(w * 0.76, h * 0.6);
    c.drawCircle(left, w * 0.05, fill);
    c.drawCircle(right, w * 0.05, fill);
    // tuas terangkat (saklar terbuka)
    c.drawLine(left, Offset(w * 0.62, h * 0.34), p);
    // garis dasar menuju terminal
    c.drawLine(Offset(w * 0.1, h * 0.6), left, p);
    c.drawLine(right, Offset(w * 0.9, h * 0.6), p);
  }

  void _metal(Canvas c, double w, double h, Paint p, Paint fill) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.4, w * 0.64, h * 0.2),
      Radius.circular(w * 0.03),
    );
    c.drawRRect(r, p);
    // guratan kilau logam
    for (final dx in [0.34, 0.5, 0.66]) {
      c.drawLine(Offset(w * dx, h * 0.44), Offset(w * (dx - 0.04), h * 0.56), p);
    }
  }

  void _plastic(Canvas c, double w, double h, Paint p, Paint fill) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.4, w * 0.64, h * 0.2),
      Radius.circular(w * 0.1),
    );
    c.drawRRect(r, p);
    // titik tekstur non-logam
    for (final dx in [0.36, 0.5, 0.64]) {
      c.drawCircle(Offset(w * dx, h * 0.5), w * 0.018, fill);
    }
  }

  @override
  bool shouldRepaint(covariant _ComponentPainter old) =>
      old.type != type || old.stroke != stroke || old.lit != lit;
}
