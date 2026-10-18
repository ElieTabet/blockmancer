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

/// Whether runs may offer [joker] already; false until the progression is
/// read.

@ProviderFor(jokerOwned)
final jokerOwnedProvider = JokerOwnedFamily._();

/// Whether runs may offer [joker] already; false until the progression is
/// read.

final class JokerOwnedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether runs may offer [joker] already; false until the progression is
  /// read.
  JokerOwnedProvider._({
    required JokerOwnedFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerOwnedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerOwnedHash();

  @override
  String toString() {
    return r'jokerOwnedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerOwned(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerOwnedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerOwnedHash() => r'3cfd08d35922af83fe2e5b95c30483f7826924e6';

/// Whether runs may offer [joker] already; false until the progression is
/// read.

final class JokerOwnedFamily extends $Family
    with $FunctionalFamilyOverride<bool, JokerId> {
  JokerOwnedFamily._()
    : super(
        retry: null,
        name: r'jokerOwnedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether runs may offer [joker] already; false until the progression is
  /// read.

  JokerOwnedProvider call(JokerId joker) =>
      JokerOwnedProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerOwnedProvider';
}

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

@ProviderFor(worldSummary)
final worldSummaryProvider = WorldSummaryFamily._();

final class WorldSummaryProvider
    extends $FunctionalProvider<WorldSummary, WorldSummary, WorldSummary>
    with $Provider<WorldSummary> {
  WorldSummaryProvider._({
    required WorldSummaryFamily super.from,
    required WorldId super.argument,
  }) : super(
         retry: null,
         name: r'worldSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$worldSummaryHash();

  @override
  String toString() {
    return r'worldSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WorldSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorldSummary create(Ref ref) {
    final argument = this.argument as WorldId;
    return worldSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorldSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorldSummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorldSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$worldSummaryHash() => r'efb160ee549f47931bb78c118917823bf58dae67';

final class WorldSummaryFamily extends $Family
    with $FunctionalFamilyOverride<WorldSummary, WorldId> {
  WorldSummaryFamily._()
    : super(
        retry: null,
        name: r'worldSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorldSummaryProvider call(WorldId world) =>
      WorldSummaryProvider._(argument: world, from: this);

  @override
  String toString() => r'worldSummaryProvider';
}

/// The numbers and the tray the jokers play with, to describe them.

@ProviderFor(jokerTuning)
final jokerTuningProvider = JokerTuningProvider._();

/// The numbers and the tray the jokers play with, to describe them.

final class JokerTuningProvider
    extends
        $FunctionalProvider<
          ({int traySize, JokerTuning tuning}),
          ({int traySize, JokerTuning tuning}),
          ({int traySize, JokerTuning tuning})
        >
    with $Provider<({int traySize, JokerTuning tuning})> {
  /// The numbers and the tray the jokers play with, to describe them.
  JokerTuningProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jokerTuningProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jokerTuningHash();

  @$internal
  @override
  $ProviderElement<({int traySize, JokerTuning tuning})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int traySize, JokerTuning tuning}) create(Ref ref) {
    return jokerTuning(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int traySize, JokerTuning tuning}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({int traySize, JokerTuning tuning})>(value),
    );
  }
}

String _$jokerTuningHash() => r'bc336286f9fbdedc559ec55cdae974ba1a697212';

/// How the player's runs went with [joker]; nothing before its first pick.

@ProviderFor(jokerStats)
final jokerStatsProvider = JokerStatsFamily._();

/// How the player's runs went with [joker]; nothing before its first pick.

final class JokerStatsProvider
    extends $FunctionalProvider<JokerStats, JokerStats, JokerStats>
    with $Provider<JokerStats> {
  /// How the player's runs went with [joker]; nothing before its first pick.
  JokerStatsProvider._({
    required JokerStatsFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerStatsHash();

  @override
  String toString() {
    return r'jokerStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<JokerStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JokerStats create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerStats(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JokerStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JokerStats>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerStatsHash() => r'c5f7626bd4fc1141f9f2599923e53cfab9c85255';

/// How the player's runs went with [joker]; nothing before its first pick.

final class JokerStatsFamily extends $Family
    with $FunctionalFamilyOverride<JokerStats, JokerId> {
  JokerStatsFamily._()
    : super(
        retry: null,
        name: r'jokerStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// How the player's runs went with [joker]; nothing before its first pick.

  JokerStatsProvider call(JokerId joker) =>
      JokerStatsProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerStatsProvider';
}

/// The joker [joker] pairs with.

@ProviderFor(jokerPartner)
final jokerPartnerProvider = JokerPartnerFamily._();

/// The joker [joker] pairs with.

final class JokerPartnerProvider
    extends $FunctionalProvider<JokerId, JokerId, JokerId>
    with $Provider<JokerId> {
  /// The joker [joker] pairs with.
  JokerPartnerProvider._({
    required JokerPartnerFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerPartnerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerPartnerHash();

  @override
  String toString() {
    return r'jokerPartnerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<JokerId> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JokerId create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerPartner(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JokerId value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JokerId>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerPartnerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerPartnerHash() => r'cd65e1012a8e07e4358df43ac3b7ce455e3c11cd';

/// The joker [joker] pairs with.

final class JokerPartnerFamily extends $Family
    with $FunctionalFamilyOverride<JokerId, JokerId> {
  JokerPartnerFamily._()
    : super(
        retry: null,
        name: r'jokerPartnerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The joker [joker] pairs with.

  JokerPartnerProvider call(JokerId joker) =>
      JokerPartnerProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerPartnerProvider';
}

/// What it takes to unlock [joker].

@ProviderFor(jokerUnlock)
final jokerUnlockProvider = JokerUnlockFamily._();

/// What it takes to unlock [joker].

final class JokerUnlockProvider
    extends $FunctionalProvider<JokerUnlock, JokerUnlock, JokerUnlock>
    with $Provider<JokerUnlock> {
  /// What it takes to unlock [joker].
  JokerUnlockProvider._({
    required JokerUnlockFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerUnlockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerUnlockHash();

  @override
  String toString() {
    return r'jokerUnlockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<JokerUnlock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JokerUnlock create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerUnlock(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JokerUnlock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JokerUnlock>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerUnlockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerUnlockHash() => r'f92d6346deaa9703462ce9572ddb304964bba53c';

/// What it takes to unlock [joker].

final class JokerUnlockFamily extends $Family
    with $FunctionalFamilyOverride<JokerUnlock, JokerId> {
  JokerUnlockFamily._()
    : super(
        retry: null,
        name: r'jokerUnlockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// What it takes to unlock [joker].

  JokerUnlockProvider call(JokerId joker) =>
      JokerUnlockProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerUnlockProvider';
}

/// How many of the collection's jokers the player has unlocked, and of how
/// many.

@ProviderFor(spellbookProgress)
final spellbookProgressProvider = SpellbookProgressProvider._();

/// How many of the collection's jokers the player has unlocked, and of how
/// many.

final class SpellbookProgressProvider
    extends
        $FunctionalProvider<
          ({int total, int unlocked}),
          ({int total, int unlocked}),
          ({int total, int unlocked})
        >
    with $Provider<({int total, int unlocked})> {
  /// How many of the collection's jokers the player has unlocked, and of how
  /// many.
  SpellbookProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spellbookProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spellbookProgressHash();

  @$internal
  @override
  $ProviderElement<({int total, int unlocked})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int total, int unlocked}) create(Ref ref) {
    return spellbookProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int total, int unlocked}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int total, int unlocked})>(value),
    );
  }
}

String _$spellbookProgressHash() => r'28b7ef4fa461cf06e7f422e7f14506fe3ec2c392';
