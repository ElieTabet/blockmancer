import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import 'fake_game_rules.dart';

/// Mounts the game screen on a phone of [size] logical pixels, its rules
/// scripted by the returned fake.
Future<FakeGameRules> pumpGame(
  WidgetTester tester,
  RunState start, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final rules = FakeGameRules(start: start);

  await tester.pumpWidget(
    ProviderScope(
      overrides: bindProviders(gameRules: (ref) => rules),
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.darkTheme,
          home: const GameWidget(),
        ),
      ),
    ),
  );
  await tester.pump();

  return rules;
}
