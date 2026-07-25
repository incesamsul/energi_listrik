import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';
import 'component_painter.dart';

/// Papan simulasi rangkaian: panggung navy dengan kawat loop. Komponen
/// tetap tergambar; lubang kosong menerima komponen yang diseret.
class CircuitBoard extends StatelessWidget {
  final Level level;
  final List<ComponentType?> placed; // sejajar dengan level.holders
  final bool lit; // rangkaian benar -> menyala
  final Set<int> wrong; // indeks holder yang salah saat CEK
  final bool showHint;
  final void Function(int index, ComponentType type) onDropped;
  final void Function(int index) onClear;

  const CircuitBoard({
    super.key,
    required this.level,
    required this.placed,
    required this.lit,
    required this.wrong,
    required this.showHint,
    required this.onDropped,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth, h = c.maxHeight;
          final slot = w * 0.16; // ukuran token komponen
          Offset at(Offset frac) => Offset(frac.dx * w, frac.dy * h);

          final children = <Widget>[];

          // kawat loop di belakang
          children.add(Positioned.fill(
            child: CustomPaint(painter: _LoopPainter(lit: lit)),
          ));

          // komponen tetap
          for (final f in level.fixed) {
            final pos = at(f.pos);
            children.add(_token(
              left: pos.dx - slot / 2,
              top: pos.dy - slot / 2,
              size: slot,
              child: ComponentIcon(
                type: f.type,
                size: slot * 0.72,
                stroke: (f.type == ComponentType.lampu && lit)
                    ? AppColors.glow
                    : AppColors.surface,
                lit: f.type == ComponentType.lampu && lit,
              ),
              border: AppColors.boardLine,
              bg: AppColors.boardSlot,
            ));
          }

          // lubang / holder
          for (int i = 0; i < level.holders.length; i++) {
            final holder = level.holders[i];
            final pos = at(holder.pos);
            final filledType = placed[i];
            final isWrong = wrong.contains(i);
            final isCorrect =
                filledType != null && filledType == holder.required;
            children.add(Positioned(
              left: pos.dx - slot / 2,
              top: pos.dy - slot / 2,
              width: slot,
              height: slot,
              child: DragTarget<ComponentType>(
                onWillAcceptWithDetails: (_) => true,
                onAcceptWithDetails: (d) => onDropped(i, d.data),
                builder: (context, cand, rej) {
                  final hovering = cand.isNotEmpty;
                  final lampLit =
                      filledType == ComponentType.lampu && lit;
                  return GestureDetector(
                    onTap: filledType != null ? () => onClear(i) : null,
                    child: AnimatedContainer(
                      duration: kFast,
                      curve: kEaseOut,
                      decoration: BoxDecoration(
                        color: filledType == null
                            ? AppColors.boardSlot
                            : AppColors.boardSlot.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isWrong
                              ? AppColors.danger
                              : hovering
                                  ? AppColors.primary
                                  : (showHint && !isCorrect)
                                      ? AppColors.primary.withValues(alpha: 0.8)
                                      : filledType != null
                                          ? AppColors.success.withValues(
                                              alpha: lit ? 1 : 0.0)
                                          : AppColors.boardLine,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: (showHint && !isCorrect)
                            ? Opacity(
                                opacity: 0.55,
                                child: ComponentIcon(
                                  type: holder.required,
                                  size: slot * 0.6,
                                  stroke: AppColors.primary,
                                ),
                              )
                            : filledType != null
                                ? ComponentIcon(
                                    type: filledType,
                                    size: slot * 0.66,
                                    stroke: lampLit
                                        ? AppColors.glow
                                        : AppColors.surface,
                                    lit: lampLit,
                                  )
                                : _emptyMark(slot),
                      ),
                    ),
                  );
                },
              ),
            ));
          }

          return Container(
            decoration: BoxDecoration(
              color: AppColors.boardBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: children),
          );
        },
      ),
    );
  }

  Widget _emptyMark(double slot) => Container(
        width: slot * 0.34,
        height: slot * 0.34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.boardLine, width: 2),
        ),
      );

  Widget _token({
    required double left,
    required double top,
    required double size,
    required Widget child,
    required Color border,
    required Color bg,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: border, width: 2),
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Kawat berbentuk loop persegi membulat. Menyala amber saat rangkaian benar.
class _LoopPainter extends CustomPainter {
  final bool lit;
  _LoopPainter({required this.lit});

  @override
  void paint(Canvas canvas, Size size) {
    final inset = size.width * 0.16;
    final rect = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.width * 0.12),
    );
    if (lit) {
      final glow = Paint()
        ..color = AppColors.glow.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.03
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawRRect(rrect, glow);
    }
    final wire = Paint()
      ..color = lit ? AppColors.primary : AppColors.boardLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.016
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(rrect, wire);
  }

  @override
  bool shouldRepaint(covariant _LoopPainter old) => old.lit != lit;
}
