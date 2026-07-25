import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:energi_listrik/screens/menu_screen.dart';
import 'package:energi_listrik/theme/app_theme.dart';

void main() {
  testWidgets('Menu utama menampilkan tombol Mulai', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.build(),
      home: const MenuScreen(),
    ));
    expect(find.text('Mulai'), findsOneWidget);
    expect(find.text('Cara Bermain'), findsOneWidget);
    expect(find.text('Energi Listrik'), findsOneWidget);
  });
}
