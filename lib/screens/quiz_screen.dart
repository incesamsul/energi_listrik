import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/questions.dart';
import '../models/quiz.dart';
import '../state/progress.dart';
import '../theme/app_theme.dart';
import '../util/fisher_yates.dart';
import '../widgets/app_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

/// Soal beserta pilihan yang sudah diacak; menyimpan teks jawaban benar
/// agar tetap valid setelah urutan opsi berubah.
class _ShuffledQ {
  final String prompt;
  final List<String> options;
  final String correct;
  _ShuffledQ(this.prompt, this.options, this.correct);
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<_ShuffledQ> _quiz;
  int _index = 0;
  int _correctCount = 0;
  String? _picked;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    // Fisher-Yates: acak urutan soal, lalu acak pilihan tiap soal.
    final questions = fisherYatesShuffle<Question>(kQuestions);
    _quiz = questions.map((q) {
      final opts = fisherYatesShuffle<String>(q.options);
      return _ShuffledQ(q.prompt, opts, q.correctAnswer);
    }).toList();
  }

  _ShuffledQ get _q => _quiz[_index];

  void _pick(String option) {
    if (_revealed) return;
    setState(() {
      _picked = option;
      _revealed = true;
      if (option == _q.correct) _correctCount++;
    });
    HapticFeedback.selectionClick();
  }

  void _next() {
    if (_index < _quiz.length - 1) {
      setState(() {
        _index++;
        _picked = null;
        _revealed = false;
      });
    } else {
      appProgress.saveQuiz(_correctCount);
      setState(() => _index = _quiz.length); // tampilkan hasil
    }
  }

  @override
  Widget build(BuildContext context) {
    final finished = _index >= _quiz.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(finished ? 'Hasil Kuis' : 'Kuis  ·  ${_index + 1}/${_quiz.length}',
            style: Theme.of(context).textTheme.titleLarge),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        top: false,
        child: finished ? _result(context) : _question(context),
      ),
    );
  }

  Widget _question(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // progres
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: (_index + 1) / _quiz.length,
              minHeight: 8,
              backgroundColor: AppColors.surfaceDim,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: Gap.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Gap.lg),
            decoration: BoxDecoration(
              color: AppColors.boardBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              _q.prompt,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.surface, height: 1.3),
            ),
          ),
          const SizedBox(height: Gap.lg),
          for (final opt in _q.options) ...[
            _OptionTile(
              label: opt,
              state: _tileState(opt),
              onTap: () => _pick(opt),
            ),
            const SizedBox(height: Gap.sm),
          ],
          const Spacer(),
          if (_revealed)
            AppButton(
              _index < _quiz.length - 1 ? 'Lanjut' : 'Lihat Hasil',
              fullWidth: true,
              onPressed: _next,
            ),
        ],
      ),
    );
  }

  _OptState _tileState(String opt) {
    if (!_revealed) return _OptState.idle;
    if (opt == _q.correct) return _OptState.correct;
    if (opt == _picked) return _OptState.wrong;
    return _OptState.dim;
  }

  Widget _result(BuildContext context) {
    final total = _quiz.length;
    final pct = (_correctCount / total * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xl, Gap.lg, Gap.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 160,
              height: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.boardBg,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_correctCount/$total',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: AppColors.glow)),
                  Text('benar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.surface.withValues(alpha: 0.7))),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gap.lg),
          Text(
            pct >= 80
                ? 'Hebat! Kamu paham energi listrik.'
                : pct >= 50
                    ? 'Bagus! Ulangi untuk skor lebih tinggi.'
                    : 'Terus berlatih, kamu pasti bisa.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(flex: 2),
          AppButton(
            'Selesai',
            fullWidth: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

enum _OptState { idle, correct, wrong, dim }

class _OptionTile extends StatelessWidget {
  final String label;
  final _OptState state;
  final VoidCallback onTap;
  const _OptionTile(
      {required this.label, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    late Color bg, border, fg;
    switch (state) {
      case _OptState.idle:
        bg = AppColors.surface;
        border = AppColors.line;
        fg = AppColors.ink;
        break;
      case _OptState.correct:
        bg = AppColors.success.withValues(alpha: 0.14);
        border = AppColors.success;
        fg = AppColors.ink;
        break;
      case _OptState.wrong:
        bg = AppColors.danger.withValues(alpha: 0.12);
        border = AppColors.danger;
        fg = AppColors.ink;
        break;
      case _OptState.dim:
        bg = AppColors.surfaceDim;
        border = AppColors.line;
        fg = AppColors.inkSoft;
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: kFast,
        curve: kEaseOut,
        padding:
            const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.md),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: border, width: 1.8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: fg, fontWeight: FontWeight.w600)),
            ),
            if (state == _OptState.correct)
              const Icon(Icons.check_rounded, color: AppColors.success)
            else if (state == _OptState.wrong)
              const Icon(Icons.close_rounded, color: AppColors.danger),
          ],
        ),
      ),
    );
  }
}
