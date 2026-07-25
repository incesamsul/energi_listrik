import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/levels.dart';
import '../models/level.dart';
import '../state/progress.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/circuit_board.dart';
import '../widgets/component_chip.dart';
import 'concept_screen.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<ComponentType?> _placed;
  bool _lit = false;
  bool _solved = false;
  Set<int> _wrong = {};
  bool _showHint = false;
  Timer? _hintTimer;

  Level get level => widget.level;

  @override
  void initState() {
    super.initState();
    _placed = List<ComponentType?>.filled(level.holders.length, null);
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  void _onDropped(int i, ComponentType type) {
    setState(() {
      _placed[i] = type;
      _wrong.remove(i);
      _lit = false;
    });
    HapticFeedback.selectionClick();
  }

  void _onClear(int i) {
    if (_solved) return;
    setState(() {
      _placed[i] = null;
      _lit = false;
    });
  }

  void _reset() {
    setState(() {
      _placed = List<ComponentType?>.filled(level.holders.length, null);
      _wrong = {};
      _lit = false;
      _solved = false;
    });
  }

  void _hint() {
    _hintTimer?.cancel();
    setState(() => _showHint = true);
    _hintTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _showHint = false);
    });
  }

  void _check() {
    final wrong = <int>{};
    for (int i = 0; i < level.holders.length; i++) {
      if (_placed[i] != level.holders[i].required) wrong.add(i);
    }
    if (wrong.isEmpty) {
      setState(() {
        _lit = true;
        _wrong = {};
      });
      HapticFeedback.mediumImpact();
      appProgress.completeLevel(level.id, kLevels.length);
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _solved = true);
      });
    } else {
      setState(() => _wrong = wrong);
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _continue() async {
    final isLast = level.id == kLevels.length;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConceptScreen(concept: level.concept, isLast: isLast),
      ),
    );
    if (mounted) Navigator.pop(context); // kembali ke pilih level
  }

  @override
  Widget build(BuildContext context) {
    final allFilled = !_placed.contains(null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text('Level ${level.id}  ·  ${level.title}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.lg),
          child: Column(
            children: [
              Text(
                level.instruction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: Gap.md),
              Expanded(
                child: Center(
                  child: CircuitBoard(
                    level: level,
                    placed: _placed,
                    lit: _lit,
                    wrong: _wrong,
                    showHint: _showHint,
                    onDropped: _onDropped,
                    onClear: _onClear,
                  ),
                ),
              ),
              const SizedBox(height: Gap.md),
              if (_solved)
                _SuccessPanel(onContinue: _continue)
              else ...[
                _Tray(components: level.tray),
                const SizedBox(height: Gap.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton('Reset',
                          kind: ButtonKind.outline,
                          fullWidth: true,
                          onPressed: _reset),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: AppButton('Petunjuk',
                          kind: ButtonKind.outline,
                          fullWidth: true,
                          onPressed: _hint),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: AppButton('Cek',
                          kind: ButtonKind.primary,
                          fullWidth: true,
                          onPressed: allFilled ? _check : null),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Tray extends StatelessWidget {
  final List<ComponentType> components;
  const _Tray({required this.components});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Gap.md, horizontal: Gap.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Gap.sm,
        runSpacing: Gap.sm,
        children: [
          for (final t in components) ComponentChip(type: t),
        ],
      ),
    );
  }
}

class _SuccessPanel extends StatelessWidget {
  final VoidCallback onContinue;
  const _SuccessPanel({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kMed,
      curve: kEaseOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(Gap.lg),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          children: [
            Text(
              'Rangkaian Berhasil',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Lampu menyala. Kamu membentuk rangkaian yang benar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9)),
            ),
            const SizedBox(height: Gap.md),
            AppButton('Lanjut',
                kind: ButtonKind.primary, fullWidth: true, onPressed: onContinue),
          ],
        ),
      ),
    );
  }
}
