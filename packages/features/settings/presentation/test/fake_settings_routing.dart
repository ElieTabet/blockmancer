import 'package:flutter/widgets.dart';
import 'package:settings_presentation/settings_presentation.dart';

/// Records where Settings asked to go.
final class FakeSettingsRouting implements SettingsRouting {
  final calls = <String>[];

  @override
  void onBackRequested(BuildContext context) => calls.add('back');
}
