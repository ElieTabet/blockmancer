import 'dart:io';

import 'package:app_providers/src/remote_config_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the committed Remote Config template and key table are what the code '
      'plays with: re-run tool/remote_config_template.dart after changing a '
      'default or a key', () {
    final keys = remoteConfigKeys();

    expect(
      File('../../../docs/remote-config/template.json').readAsStringSync(),
      remoteConfigTemplate(keys),
    );
    expect(
      File('../../../docs/remote-config/keys.md').readAsStringSync(),
      contains(remoteConfigTable(keys)),
    );
  });

  test('every key is read once: no two packages claim the same name', () {
    final names = remoteConfigKeys().map((key) => key.name).toList();

    expect(names.toSet(), hasLength(names.length));
  });
}
