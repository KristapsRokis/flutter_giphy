import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_giphy/main.dart';
import 'package:flutter_giphy/giphy_page.dart';



void main() {
  testWidgets('MyApp widget has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('title')), findsOneWidget);
  });

  testWidgets('GiphyPage widget displays search bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: GiphyPage()));

    expect(find.byKey(const Key('searchTextField')), findsOneWidget);
  });
}