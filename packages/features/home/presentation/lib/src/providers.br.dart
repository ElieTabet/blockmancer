import 'package:home_presentation/src/providers_di.br.dart' as di;
import 'package:home_presentation/src/routing/home_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// home_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required Future<int?> Function(Ref ref) dailyBest,
  required Future<int?> Function(Ref ref) practiceBest,
}) => [
  di.dailyBestProvider.overrideWith(dailyBest),
  di.practiceBestProvider.overrideWith(practiceBest),
];

List<Override> bindRoutingProviders({
  required HomeRouting Function(Ref ref) homeRouting,
}) => [di.homeRoutingProvider.overrideWith(homeRouting)];
