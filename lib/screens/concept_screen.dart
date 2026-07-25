import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/component_painter.dart';

/// Materi konsep singkat setelah level selesai.
class ConceptScreen extends StatelessWidget {
  final Concept concept;
  final bool isLast;
  const ConceptScreen({super.key, required this.concept, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boardBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xl, Gap.lg, Gap.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: ComponentIcon(
                  type: ComponentType.lampu,
                  size: 96,
                  stroke: AppColors.glow,
                  lit: true,
                ),
              ),
              const SizedBox(height: Gap.lg),
              Text(
                'Penjelasan Konsep',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1),
              ),
              const SizedBox(height: Gap.sm),
              Text(
                concept.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.surface),
              ),
              const SizedBox(height: Gap.md),
              Text(
                concept.body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.82)),
              ),
              const Spacer(flex: 2),
              AppButton(
                isLast ? 'Selesai' : 'Lanjut',
                kind: ButtonKind.primary,
                fullWidth: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
