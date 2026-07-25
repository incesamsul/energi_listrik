import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/component_painter.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Seret komponen', 'Tarik komponen dari baki bawah ke lubang kosong di papan rangkaian.'),
      ('Bentuk rangkaian tertutup', 'Susun jalur agar tersambung penuh dari baterai kembali ke baterai.'),
      ('Tekan Cek', 'Periksa rangkaian. Jika benar, lampu akan menyala.'),
      ('Pelajari konsep', 'Setiap level selesai memberi materi singkat, lalu buka level berikutnya.'),
    ];
    return Scaffold(
      appBar: _bar(context, 'Cara Bermain'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(Gap.lg),
              decoration: BoxDecoration(
                color: AppColors.boardBg,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  const ComponentIcon(
                      type: ComponentType.baterai, size: 52, stroke: AppColors.surface),
                  const SizedBox(width: Gap.md),
                  const ComponentIcon(
                      type: ComponentType.kabel, size: 52, stroke: AppColors.surface),
                  const SizedBox(width: Gap.md),
                  const ComponentIcon(
                      type: ComponentType.lampu,
                      size: 52,
                      stroke: AppColors.glow,
                      lit: true),
                ],
              ),
            ),
            const SizedBox(height: Gap.lg),
            for (int i = 0; i < steps.length; i++) ...[
              _step(context, i + 1, steps[i].$1, steps[i].$2),
              if (i < steps.length - 1) const SizedBox(height: Gap.md),
            ],
            const SizedBox(height: Gap.xl),
            AppButton(
              'Mengerti',
              fullWidth: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(BuildContext context, int n, String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text('$n',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 17, color: AppColors.ink)),
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

AppBar _bar(BuildContext context, String title) => AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      iconTheme: const IconThemeData(color: AppColors.ink),
    );
