import 'package:keychain/src/keychain_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// keychain — inbound dependency-injection slot. Throws until the composition
// layer (app_providers) supplies a concrete store.

@riverpod
KeychainRepository keychainRepository(Ref ref) => throw UnimplementedError(
  'keychainRepositoryProvider must be overridden by the composition layer (app_providers)',
);
