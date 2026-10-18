// Pure Dart on purpose, imports included: tool/remote_config_template.dart
// runs it with `dart run`, outside Flutter.
import 'dart:convert';

import 'package:app_update_domain/app_update_domain.dart' show updateKeys;
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:game_domain/game_domain.dart'
    show interstitialKeys, reviewKeys, runTuningKeys;
import 'package:shared_domain/shared_domain.dart';

/// Every key the app reads from Remote Config, with the default it plays
/// with: the run's numbers, the interstitial's caps, then the update
/// versions.
List<RemoteKey> remoteConfigKeys() => [
  ...runTuningKeys(const BlockmancerEngine()),
  ...interstitialKeys,
  ...reviewKeys,
  ...updateKeys,
];

/// [keys] as a Remote Config template, to publish as it is: each parameter's
/// default is the app's own, so publishing it changes nothing until a value
/// is edited.
String remoteConfigTemplate(List<RemoteKey> keys) =>
    '${const JsonEncoder.withIndent('  ').convert({
      'parameters': {
        for (final key in keys) key.name: {
            'defaultValue': {'value': key.defaultValue},
            'description': key.description,
            'valueType': switch (key.kind) {
              .number => 'NUMBER',
              .string => 'STRING',
            },
          },
      },
    })}\n';

/// [keys] as the markdown table docs/console-setup.md points to.
String remoteConfigTable(List<RemoteKey> keys) => [
  '| Key | Type | Default | Allowed | What it changes |',
  '|---|---|---|---|---|',
  for (final key in keys)
    '| `${key.name}` | ${key.kind.name} | `${key.defaultValue}` '
        '| ${key.min == null ? 'a version, `x.y.z`' : '${key.min} to ${key.max}'} '
        '| ${key.description} |',
].join('\n');
