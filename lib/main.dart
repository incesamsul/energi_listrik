import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/progress.dart';
import 'theme/app_theme.dart';
import 'screens/menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await appProgress.load();
  runApp(const EnergiListrikApp());
}

class EnergiListrikApp extends StatelessWidget {
  const EnergiListrikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energi Listrik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const MenuScreen(),
    );
  }
}
