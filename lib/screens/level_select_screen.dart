import 'package:flutter/material.dart';
import '../data/levels.dart';
import '../models/level.dart';
import '../state/progress.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import 'quiz_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text('Pilih Level',
            style: Theme.of(context).textTheme.titleLarge),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: appProgress,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.lg),
              children: [
                for (final level in kLevels) ...[
                  _LevelCard(
                    level: level,
                    unlocked: appProgress.isUnlocked(level.id),
                    done: appProgress.unlockedLevel > level.id,
                  ),
                  const SizedBox(height: Gap.md),
                ],
                const SizedBox(height: Gap.sm),
                _QuizCard(unlocked: appProgress.quizUnlocked(kLevels.length)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final bool unlocked;
  final bool done;
  const _LevelCard(
      {required this.level, required this.unlocked, required this.done});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameScreen(level: level)),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(Gap.md),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.surface : AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: done ? AppColors.success : AppColors.line,
            width: done ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: unlocked ? AppColors.boardBg : AppColors.locked,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: unlocked
                  ? Text('${level.id}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.glow))
                  : const Icon(Icons.lock_rounded,
                      color: AppColors.surface, size: 26),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unlocked ? level.title : 'Terkunci',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: unlocked ? AppColors.ink : AppColors.inkSoft),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked
                        ? level.instruction
                        : 'Selesaikan level sebelumnya',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (done)
              const Padding(
                padding: EdgeInsets.only(left: Gap.sm),
                child: Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 26),
              )
            else if (unlocked)
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.inkSoft, size: 26),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final bool unlocked;
  const _QuizCard({required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(Gap.md),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.boardBg : AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: unlocked ? AppColors.boardBg : AppColors.line,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: unlocked
                    ? AppColors.primary
                    : AppColors.locked,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                unlocked ? Icons.quiz_rounded : Icons.lock_rounded,
                color: unlocked ? AppColors.ink : AppColors.surface,
                size: 26,
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kuis Energi Listrik',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: unlocked ? AppColors.surface : AppColors.inkSoft),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked
                        ? 'Uji pemahamanmu, soal diacak tiap main'
                        : 'Selesaikan semua level untuk membuka',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: unlocked
                            ? AppColors.surface.withValues(alpha: 0.7)
                            : AppColors.inkSoft),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
