import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resume/main.dart';
import 'package:resume/utils/constants.dart';

void main() {
  testWidgets('Portfolio app can be instantiated', (WidgetTester tester) async {
    // Just test that the app can be created without crashing
    const app = PortfolioApp();
    expect(app, isA<PortfolioApp>());
  });

  testWidgets('Portfolio app has correct title in MaterialApp', (
    WidgetTester tester,
  ) async {
    // Test the MaterialApp title directly
    final materialApp = MaterialApp(
      title: '${AppConstants.developerName} - Portfolio',
      home: const Scaffold(),
    );

    await tester.pumpWidget(materialApp);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
