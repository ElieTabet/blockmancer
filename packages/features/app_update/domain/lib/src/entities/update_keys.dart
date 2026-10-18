import 'package:app_update_domain/src/entities/store_platform.dart';
import 'package:shared_domain/shared_domain.dart';

/// The Remote Config key holding [platform]'s minimum version.
String minVersionKey(StorePlatform platform) => 'min_version_${platform.name}';

/// The Remote Config key holding [platform]'s latest version.
String latestVersionKey(StorePlatform platform) =>
    'latest_version_${platform.name}';

/// The four keys the update check reads, for the template and its table.
/// `0.0.0` asks nothing of any version.
final List<RemoteKey> updateKeys = [
  for (final platform in StorePlatform.values) ...[
    RemoteKey(
      defaultValue: '0.0.0',
      description:
          'Oldest ${platform.name} version that still plays; older ones show '
          'the blocking update screen (the kill switch)',
      kind: .string,
      name: minVersionKey(platform),
    ),
    RemoteKey(
      defaultValue: '0.0.0',
      description:
          'Newest ${platform.name} version; older ones see a dismissible '
          'banner on the map, once per version',
      kind: .string,
      name: latestVersionKey(platform),
    ),
  ],
];
