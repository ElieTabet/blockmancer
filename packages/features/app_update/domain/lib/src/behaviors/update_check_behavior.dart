import 'package:app_update_domain/src/entities/store_platform.dart';
import 'package:app_update_domain/src/entities/update_keys.dart';
import 'package:app_update_domain/src/entities/update_need.br.dart';
import 'package:pub_semver/pub_semver.dart';

/// The text Remote Config publishes for a key, or null when none is published.
typedef RemoteValueFun = String? Function(String key);

/// [appVersion] against [platform]'s published minimum and latest versions.
/// A version that can't be read, the app's own included, asks nothing: a typo
/// in the console must never lock players out.
UpdateNeed updateNeedOf({
  required String appVersion,
  required StorePlatform platform,
  required RemoteValueFun valueOf,
}) {
  final current = _parsed(appVersion);

  if (current == null) return const .none();

  final minimum = _parsed(valueOf(minVersionKey(platform)));

  if (minimum != null && current < minimum) return const .required();

  final latest = _parsed(valueOf(latestVersionKey(platform)));

  if (latest != null && current < latest) {
    return .optional(latest: latest.toString());
  }

  return const .none();
}

Version? _parsed(String? text) {
  if (text == null) return null;

  try {
    return Version.parse(text.trim());
  } on FormatException {
    return null;
  }
}
