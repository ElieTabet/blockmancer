import 'dart:convert';

import 'package:game_data/src/dtos/saved_run_dto.br.dart';
import 'package:game_data/src/package_name.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timber/timber.dart';

/// The saved run as one JSON string, under one key.
final class SharedPreferencesRunStore implements RunStore {
  const SharedPreferencesRunStore();

  static const _key = 'run.saved';

  @override
  Future<void> clear() async {
    await (await SharedPreferences.getInstance()).remove(_key);
  }

  /// A save that can't be read (corrupt, or from an unknown version) is no
  /// save at all: the next run overwrites it. Storage that can't be reached
  /// throws, so a save that is merely out of reach is never taken for none.
  @override
  Future<SavedRun?> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);

    if (raw == null) return null;

    try {
      final json = migrate(jsonDecode(raw) as Map<String, dynamic>);

      return SavedRunDto.fromJson(json).toDomain();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The saved run could not be read; starting afresh',
        exception: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  @override
  Future<void> save(SavedRun run) async {
    await (await SharedPreferences.getInstance()).setString(
      _key,
      jsonEncode(SavedRunDto.fromDomain(run).toJson()),
    );
  }
}
