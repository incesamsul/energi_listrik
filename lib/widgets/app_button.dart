import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonKind { primary, outline, ghost, danger, success }

/// Tombol dengan target sentuh besar dan umpan balik tekan (skala turun,
/// ease-out, tanpa bounce). Tanpa gradient.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonKind kind;
  final bool fullWidth;
  final Widget? leading;

  const AppButton(
    this.label, {
    super.key,
    this.onPressed,
    this.kind = ButtonKind.primary,
    this.fullWidth = false,
    this.leading,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    late Color bg, fg, border;
    switch (widget.kind) {
      case ButtonKind.primary:
        bg = AppColors.primary;
        fg = AppColors.ink;
        border = Colors.transparent;
        break;
      case ButtonKind.success:
        bg = AppColors.success;
        fg = Colors.white;
        border = Colors.transparent;
        break;
      case ButtonKind.danger:
        bg = AppColors.danger;
        fg = Colors.white;
        border = Colors.transparent;
        break;
      case ButtonKind.outline:
        bg = Colors.transparent;
        fg = AppColors.ink;
        border = AppColors.line;
        break;
      case ButtonKind.ghost:
        bg = Colors.transparent;
        fg = AppColors.inkSoft;
        border = Colors.transparent;
        break;
    }
    if (!enabled) {
      bg = widget.kind == ButtonKind.primary ? AppColors.locked : bg;
      fg = AppColors.inkSoft.withValues(alpha: 0.5);
    }

    final child = AnimatedScale(
      scale: _down ? 0.96 : 1.0,
      duration: kFast,
      curve: kEaseOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: border, width: 1.5),
          boxShadow: (widget.kind == ButtonKind.primary && enabled)
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.35),
                    blurRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: Gap.sm),
            ],
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: fg),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapUp: enabled ? (_) => setState(() => _down = false) : null,
      onTapCancel: enabled ? () => setState(() => _down = false) : null,
      onTap: widget.onPressed,
      child: child,
    );
  }
}
