import 'package:flutter/widgets.dart';
import 'package:settings_presentation/settings_presentation.dart';

/// Records where Settings asked to go.
final class FakeSettingsRouting implements SettingsRouting {
  final calls = <String>[];

  @override
  void onCloseRequested(BuildContext context) => calls.add('close');

  @override
  void onReplayTutorialRequested(BuildContext context) =>
      calls.add('replay tutorial');
}
