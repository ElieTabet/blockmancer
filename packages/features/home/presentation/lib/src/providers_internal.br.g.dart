// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The furthest playable world open to the player, where the map says "you
/// are here"; null until the progression is read.

@ProviderFor(hereWorld)
final hereWorldProvider = HereWorldProvider._();

/// The furthest playable world open to the player, where the map says "you
/// are here"; null until the progression is read.

final class HereWorldProvider
    extends $FunctionalProvider<WorldId?, WorldId?, WorldId?>
    with $Provider<WorldId?> {
  /// The furthest playable world open to the player, where the map says "you
  /// are here"; null until the progression is read.
  HereWorldProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hereWorldProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hereWorldHash();

  @$internal
  @override
  $ProviderElement<WorldId?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorldId? create(Ref ref) {
    return hereWorld(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorldId? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorldId?>(value),
    );
  }
}

String _$hereWorldHash() => r'9173234aa1f24dfcd43b16aa8c888da3f0552143';

/// The legs of the trail between the worlds the player has walked: every one
/// up to [hereWorldProvider].

@ProviderFor(trailWalked)
final trailWalkedProvider = TrailWalkedProvider._();

/// The legs of the trail between the worlds the player has walked: every one
/// up to [hereWorldProvider].

final class TrailWalkedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// The legs of the trail between the worlds the player has walked: every one
  /// up to [hereWorldProvider].
  TrailWalkedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trailWalkedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trailWalkedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return trailWalked(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$trailWalkedHash() => r'6882a960381c4e6089ef9e537a6c7b1277f8169b';

/// [world]'s node. Until the progression is read, a playable world shows as
/// locked.

@ProviderFor(worldNode)
final worldNodeProvider = WorldNodeFamily._();

/// [world]'s node. Until the progression is read, a playable world shows as
/// locked.

final class WorldNodeProvider
    extends $FunctionalProvider<WorldNodeShown, WorldNodeShown, WorldNodeShown>
    with $Provider<WorldNodeShown> {
  /// [world]'s node. Until the progression is read, a playable world shows as
  /// locked.
  WorldNodeProvider._({
    required WorldNodeFamily super.from,
    required WorldId super.argument,
  }) : super(
         retry: null,
         name: r'worldNodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$worldNodeHash();

  @override
  String toString() {
    return r'worldNodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WorldNodeShown> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorldNodeShown create(Ref ref) {
    final argument = this.argument as WorldId;
    return worldNode(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorldNodeShown value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorldNodeShown>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorldNodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$worldNodeHash() => r'b5ca64d6481acc849c6a0bf6fd3bb332d385dfcb';

/// [world]'s node. Until the progression is read, a playable world shows as
/// locked.

final class WorldNodeFamily extends $Family
    with $FunctionalFamilyOverride<WorldNodeShown, WorldId> {
  WorldNodeFamily._()
    : super(
        retry: null,
        name: r'worldNodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [world]'s node. Until the progression is read, a playable world shows as
  /// locked.

  WorldNodeProvider call(WorldId world) =>
      WorldNodeProvider._(argument: world, from: this);

  @override
  String toString() => r'worldNodeProvider';
}
