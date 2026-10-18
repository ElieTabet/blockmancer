import 'package:app_update_domain/app_update_domain.dart';
import 'package:app_update_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.br.g.dart';

// app_update_presentation — public providers exposed by this layer.

typedef OpenStoreListingFun = Future<bool> Function();

/// Opens this build's page in its store: the update screen's button, and the
/// map's update banner.
@riverpod
OpenStoreListingFun openStoreListing(Ref ref) {
  final openUrl = ref.watch(di.openUrlProvider);
  final storeUrl = ref.watch(storeUrlProvider);

  return () => openUrl(storeUrl);
}

List<Override> bindProviders({
  required di.OpenUrlFun Function(Ref ref) openUrl,
}) => [di.openUrlProvider.overrideWith(openUrl)];
