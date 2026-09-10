import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/component_painter.dart';
import 'how_to_play_screen.dart';
import 'level_select_screen.dart';
import 'material_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.lg,
                    Gap.xl,
                    Gap.lg,
                    Gap.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 2),
                      // panggung navy dengan lampu menyala
                      Center(
                        child: Container(
                          width: 168,
                          height: 168,
                          decoration: BoxDecoration(
                            color: AppColors.boardBg,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: const Center(
                            child: ComponentIcon(
                              type: ComponentType.lampu,
                              size: 104,
                              stroke: AppColors.glow,
                              lit: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Gap.xl),
                      Text(
                        'Energi Listrik',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: Gap.xs),
                      Text(
                        'Belajar rangkaian listrik sambil bermain',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(flex: 3),
                      AppButton(
                        'Materi',
                        kind: ButtonKind.outline,
                        fullWidth: true,
                        leading: const Icon(
                          Icons.ondemand_video_rounded,
                          size: 22,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          _fade(const MaterialScreen()),
                        ),
                      ),
                      const SizedBox(height: Gap.sm),
                      AppButton(
                        'Mulai',
                        fullWidth: true,
                        onPressed: () => Navigator.push(
                          context,
                          _fade(const LevelSelectScreen()),
                        ),
                      ),
                      const SizedBox(height: Gap.sm),
                      AppButton(
                        'Cara Bermain',
                        kind: ButtonKind.outline,
                        fullWidth: true,
                        onPressed: () => Navigator.push(
                          context,
                          _fade(const HowToPlayScreen()),
                        ),
                      ),
                      const SizedBox(height: Gap.sm),
                      AppButton(
                        'Keluar',
                        kind: ButtonKind.ghost,
                        fullWidth: true,
                        onPressed: () => SystemNavigator.pop(),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _fade(Widget page) => PageRouteBuilder(
  transitionDuration: kMed,
  pageBuilder: (_, _, _) => page,
  transitionsBuilder: (_, anim, _, child) => FadeTransition(
    opacity: CurvedAnimation(parent: anim, curve: kEaseOut),
    child: child,
  ),
);
