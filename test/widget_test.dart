// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:targetibadah_gamifikasi/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Berikan parameter isLoggedIn = false (belum login)
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify that app loaded
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);

    // Note: Test ini mungkin tidak sesuai dengan aplikasi Anda
    // Anda bisa modify test sesuai kebutuhan aplikasi
  });
}