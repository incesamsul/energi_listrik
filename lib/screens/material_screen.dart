import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import 'level_select_screen.dart';

/// Materi pengantar yang dibaca sebelum siswa memainkan level.
///
/// Video menggunakan pemutar resmi YouTube sehingga aplikasi tidak perlu
/// menyimpan salinan video berhak cipta di dalam APK. Ganti ID video ini bila
/// nanti sudah ada video materi milik sendiri.
const _introVideoId = 'JbMRfrGVdw0';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _introVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        captionLanguage: 'id',
        interfaceLanguage: 'id',
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Materi Energi Listrik',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.lg),
          children: [
            Text(
              'Kenali energi listrik sebelum mulai bermain.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Gap.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: YoutubePlayer(
                controller: _controller,
                backgroundColor: AppColors.boardBg,
              ),
            ),
            const SizedBox(height: Gap.lg),
            _MaterialCard(
              title: 'Apa itu energi listrik?',
              body:
                  'Energi listrik adalah energi yang berasal dari aliran '
                  'muatan listrik. Energi ini dapat digunakan untuk menyalakan '
                  'lampu, kipas, televisi, dan berbagai alat lainnya.',
            ),
            const SizedBox(height: Gap.sm),
            _MaterialCard(
              title: 'Bagaimana listrik mengalir?',
              body:
                  'Arus listrik mengalir jika ada sumber listrik dan jalur '
                  'yang tertutup. Baterai menjadi sumber energi, sedangkan '
                  'kabel menghantarkan arus menuju komponen seperti lampu.',
            ),
            const SizedBox(height: Gap.sm),
            _MaterialCard(
              title: 'Ingat saat bermain',
              body:
                  'Rangkaian yang putus membuat arus berhenti dan lampu tidak '
                  'menyala. Susun komponen hingga membentuk rangkaian tertutup.',
            ),
            const SizedBox(height: Gap.xl),
            AppButton(
              'Mulai Bermain',
              fullWidth: true,
              leading: const Icon(Icons.play_arrow_rounded, size: 24),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final String title;
  final String body;

  const _MaterialCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Gap.xs),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
