import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';
import 'component_painter.dart';

/// Kartu komponen di baki bawah. Bisa diseret ke lubang di papan.
/// Sumber tak habis: satu jenis bisa diseret berkali-kali.
class ComponentChip extends StatelessWidget {
  final ComponentType type;
  const ComponentChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final card = _card(context, dragging: false);
    return Draggable<ComponentType>(
      data: type,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Transform.translate(
        offset: const Offset(-40, -48),
        child: _card(context, dragging: true),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }

  Widget _card(BuildContext context, {required bool dragging}) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: Gap.sm, horizontal: Gap.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line, width: 1.5),
        boxShadow: dragging
            ? [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ComponentIcon(type: type, size: 44, stroke: AppColors.ink),
          const SizedBox(height: Gap.xs),
          Text(
            type.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
