// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_46/main.dart';

void main() {
  testWidgets('App shows dashboard, profile editor, and profile tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Editor'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Pertemuan 1'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
    expect(find.text('Progress Belajar'), findsOneWidget);
    expect(find.text('0/16 selesai'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'UTS');
    await tester.pumpAndSettle();

    expect(find.text('Ujian Tengah Semester (UTS)'), findsOneWidget);
    expect(find.text('Pertemuan 1'), findsNothing);

    await tester.tap(find.text('Ujian Tengah Semester (UTS)'));
    await tester.pumpAndSettle();

    expect(find.text('Ruang / Kode Kelas'), findsOneWidget);
    expect(find.text('V.925/04SIFE008'), findsOneWidget);
    expect(find.text('Sabtu, 9 April 2026'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Pertemuan 5');
    await tester.pumpAndSettle();

    expect(find.text('Pertemuan 5'), findsWidgets);
    expect(find.text('Pertemuan 1'), findsNothing);

    await tester.tap(find.byIcon(Icons.edit_document));
    await tester.pumpAndSettle();

    expect(find.text('Editor Profil'), findsOneWidget);
    expect(find.text('Editor Profil Profesional'), findsOneWidget);
    expect(find.text('Simpan Profil'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Profil'), findsWidgets);
    expect(find.text('Lihat Detail Profil'), findsOneWidget);
  });
}
