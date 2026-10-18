import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A release build keeps no testers' stats: whatever an earlier test build
/// counted on this phone is deleted. Nothing counts them again outside a test
/// build, so deleting at every launch deletes them once.
Future<void> discardTestStatsOutsideTestBuilds(ProviderContainer container) =>
    container.read(testToolsProvider)
    ? Future.value()
    : container.read(playStatsProvider).discard();
