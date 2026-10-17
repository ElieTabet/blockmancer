import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

const _pluralForms = {'few', 'many', 'one', 'other', 'two', 'zero'};

final _modifier = RegExp(r'\(.*\)$');

final _placeholder = RegExp(r'\$\{(\w+)\}|\$(\w+)');

/// Each key path of a slang source mapped to the placeholders its text uses.
/// A plural node is one entry, so French may add a form English lacks; slang's
/// `@` comment keys and `(param=…)` modifiers are not part of the path.
Map<String, Set<String>> _keysOf(String locale) {
  final json = File('lib/i18n/$locale.i18n.json').readAsStringSync();
  final keys = <String, Set<String>>{};

  void visit(String path, Object? node) {
    if (node is String) {
      keys[path] = _placeholdersIn(node);
      return;
    }

    final children = {
      for (final MapEntry(:key, :value)
          in (node! as Map<String, Object?>).entries)
        if (!key.startsWith('@')) key.replaceFirst(_modifier, ''): value,
    };

    if (children.isNotEmpty && _pluralForms.containsAll(children.keys)) {
      keys[path] = {
        for (final form in children.values) ..._placeholdersIn(form! as String),
      };
      return;
    }

    for (final MapEntry(:key, :value) in children.entries) {
      visit(path.isEmpty ? key : '$path.$key', value);
    }
  }

  visit('', jsonDecode(json));

  return keys;
}

Set<String> _placeholdersIn(String text) => {
  for (final match in _placeholder.allMatches(text))
    match.group(1) ?? match.group(2)!,
};

void main() {
  test('French has exactly the keys English has', () {
    // Given
    final english = _keysOf('en');

    // When
    final french = _keysOf('fr');

    // Then
    final englishKeys = english.keys.toSet();
    final frenchKeys = french.keys.toSet();
    expect(englishKeys.difference(frenchKeys), isEmpty, reason: 'not in fr');
    expect(frenchKeys.difference(englishKeys), isEmpty, reason: 'not in en');
  });

  test('each French string takes the same placeholders as its English one', () {
    // Given
    final english = _keysOf('en');

    // When
    final french = _keysOf('fr');

    // Then
    for (final MapEntry(:key, :value) in english.entries) {
      expect(french[key], value, reason: key);
    }
  });

  test('every locale resolves a translation of its own', () {
    for (final locale in AppLocale.values) {
      // Given / When
      final t = locale.buildSync();

      // Then
      final strings = [
        t.home.daily.title,
        t.game.round.piecesLeft(count: 2),
        t.game.jokers.patience.description,
        t.settings.reset.confirmMessage,
      ];
      expect(strings, everyElement(isNotEmpty), reason: locale.name);
    }
  });

  test('French is translated rather than falling back to English', () {
    // Given
    final english = AppLocale.en.buildSync();

    // When
    final french = AppLocale.fr.buildSync();

    // Then
    expect(french.home.daily.title, isNot(english.home.daily.title));
    expect(
      french.game.round.piecesLeft(count: 2),
      isNot(english.game.round.piecesLeft(count: 2)),
    );
    expect(
      french.game.jokers.twin.description,
      isNot(english.game.jokers.twin.description),
    );
    expect(
      french.settings.reset.confirmMessage,
      isNot(english.settings.reset.confirmMessage),
    );
  });
}
