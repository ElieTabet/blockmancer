import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// app_update_presentation — inbound dependency-injection slots. Each throws
// until the composition layer overrides it.

/// Opens [url] outside the app, and answers whether it opened.
typedef OpenUrlFun = Future<bool> Function(String url);

@riverpod
OpenUrlFun openUrl(Ref ref) => throw UnimplementedError(
  'openUrlProvider must be overridden by the composition layer',
);
