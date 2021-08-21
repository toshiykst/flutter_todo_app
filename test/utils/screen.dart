import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> pumpScreen(
    {required WidgetTester tester,
    required Widget screen,
    List<Override> overrides = const []}) async {
  await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: screen,
      )));
}
