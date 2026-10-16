import 'package:keychain/src/keychain_repository.dart';
import 'package:keychain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// keychain — public providers exposed by this package.

/// Binds the keychain slot to a concrete store supplied by the composition
/// layer, so nothing below composition depends on flutter_secure_storage.
List<Override> bindProviders({
  required KeychainRepository Function(Ref ref) keychainRepository,
}) => [di.keychainRepositoryProvider.overrideWith(keychainRepository)];
