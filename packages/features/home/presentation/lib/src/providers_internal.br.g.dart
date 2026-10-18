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

/// What [joker] does to a score, which colours its frame.

@ProviderFor(jokerKind)
final jokerKindProvider = JokerKindFamily._();

/// What [joker] does to a score, which colours its frame.

final class JokerKindProvider
    extends $FunctionalProvider<JokerKind, JokerKind, JokerKind>
    with $Provider<JokerKind> {
  /// What [joker] does to a score, which colours its frame.
  JokerKindProvider._({
    required JokerKindFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerKindProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerKindHash();

  @override
  String toString() {
    return r'jokerKindProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<JokerKind> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JokerKind create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerKind(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JokerKind value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JokerKind>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerKindProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerKindHash() => r'dea3ce53098e330d353564f75cfa289c94e49ccb';

/// What [joker] does to a score, which colours its frame.

final class JokerKindFamily extends $Family
    with $FunctionalFamilyOverride<JokerKind, JokerId> {
  JokerKindFamily._()
    : super(
        retry: null,
        name: r'jokerKindProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// What [joker] does to a score, which colours its frame.

  JokerKindProvider call(JokerId joker) =>
      JokerKindProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerKindProvider';
}

/// [joker]'s mastery tier, from the runs won with it; none until read.

@ProviderFor(jokerTier)
final jokerTierProvider = JokerTierFamily._();

/// [joker]'s mastery tier, from the runs won with it; none until read.

final class JokerTierProvider
    extends $FunctionalProvider<MasteryTier, MasteryTier, MasteryTier>
    with $Provider<MasteryTier> {
  /// [joker]'s mastery tier, from the runs won with it; none until read.
  JokerTierProvider._({
    required JokerTierFamily super.from,
    required JokerId super.argument,
  }) : super(
         retry: null,
         name: r'jokerTierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jokerTierHash();

  @override
  String toString() {
    return r'jokerTierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MasteryTier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MasteryTier create(Ref ref) {
    final argument = this.argument as JokerId;
    return jokerTier(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MasteryTier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MasteryTier>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JokerTierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jokerTierHash() => r'ee97366bfaea34fb81178b821eb4d547ee53d4c5';

/// [joker]'s mastery tier, from the runs won with it; none until read.

final class JokerTierFamily extends $Family
    with $FunctionalFamilyOverride<MasteryTier, JokerId> {
  JokerTierFamily._()
    : super(
        retry: null,
        name: r'jokerTierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [joker]'s mastery tier, from the runs won with it; none until read.

  JokerTierProvider call(JokerId joker) =>
      JokerTierProvider._(argument: joker, from: this);

  @override
  String toString() => r'jokerTierProvider';
}

/// The runs won with a joker that earn each tier.

@ProviderFor(masteryThresholds)
final masteryThresholdsProvider = MasteryThresholdsProvider._();

/// The runs won with a joker that earn each tier.

final class MasteryThresholdsProvider
    extends
        $FunctionalProvider<
          MasteryThresholds,
          MasteryThresholds,
          MasteryThresholds
        >
    with $Provider<MasteryThresholds> {
  /// The runs won with a joker that earn each tier.
  MasteryThresholdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masteryThresholdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masteryThresholdsHash();

  @$internal
  @override
  $ProviderElement<MasteryThresholds> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MasteryThresholds create(Ref ref) {
    return masteryThresholds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MasteryThresholds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MasteryThresholds>(value),
    );
  }
}

String _$masteryThresholdsHash() => r'982f9c0671c2018a857c5311a1ac3f12d9320b27';

/// Whether both of pair [index]'s jokers are gold.

@ProviderFor(pairMastered)
final pairMasteredProvider = PairMasteredFamily._();

/// Whether both of pair [index]'s jokers are gold.

final class PairMasteredProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether both of pair [index]'s jokers are gold.
  PairMasteredProvider._({
    required PairMasteredFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'pairMasteredProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pairMasteredHash();

  @override
  String toString() {
    return r'pairMasteredProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as int;
    return pairMastered(ref, argument);
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
    return other is PairMasteredProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pairMasteredHash() => r'116c8e3596e05db805a310d0f15fff2fec8b6ff9';

/// Whether both of pair [index]'s jokers are gold.

final class PairMasteredFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  PairMasteredFamily._()
    : super(
        retry: null,
        name: r'pairMasteredProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether both of pair [index]'s jokers are gold.

  PairMasteredProvider call(int index) =>
      PairMasteredProvider._(argument: index, from: this);

  @override
  String toString() => r'pairMasteredProvider';
}

/// How much of the collection the player holds: the jokers unlocked, the
/// pairs mastered, and of how many.

@ProviderFor(spellbookProgress)
final spellbookProgressProvider = SpellbookProgressProvider._();

/// How much of the collection the player holds: the jokers unlocked, the
/// pairs mastered, and of how many.

final class SpellbookProgressProvider
    extends
        $FunctionalProvider<
          ({int collected, int jokers, int mastered, int pairs}),
          ({int collected, int jokers, int mastered, int pairs}),
          ({int collected, int jokers, int mastered, int pairs})
        >
    with $Provider<({int collected, int jokers, int mastered, int pairs})> {
  /// How much of the collection the player holds: the jokers unlocked, the
  /// pairs mastered, and of how many.
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
  $ProviderElement<({int collected, int jokers, int mastered, int pairs})>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ({int collected, int jokers, int mastered, int pairs}) create(Ref ref) {
    return spellbookProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({int collected, int jokers, int mastered, int pairs}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({int collected, int jokers, int mastered, int pairs})
          >(value),
    );
  }
}

String _$spellbookProgressHash() => r'02f70a40987448fadd8ba50b82fd8adc8dd644c6';

/// The jokers whose art is bundled (`assets/jokers/<id>.png`); the others
/// show their drawn glyph. Read once from the asset manifest.

@ProviderFor(jokerArt)
final jokerArtProvider = JokerArtProvider._();

/// The jokers whose art is bundled (`assets/jokers/<id>.png`); the others
/// show their drawn glyph. Read once from the asset manifest.

final class JokerArtProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<JokerId>>,
          Set<JokerId>,
          FutureOr<Set<JokerId>>
        >
    with $FutureModifier<Set<JokerId>>, $FutureProvider<Set<JokerId>> {
  /// The jokers whose art is bundled (`assets/jokers/<id>.png`); the others
  /// show their drawn glyph. Read once from the asset manifest.
  JokerArtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jokerArtProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jokerArtHash();

  @$internal
  @override
  $FutureProviderElement<Set<JokerId>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<JokerId>> create(Ref ref) {
    return jokerArt(ref);
  }
}

String _$jokerArtHash() => r'd8691d337aaf5c0297d2deb81b31d3676b00c390';

/// The jokers unlocked since the Spellbook was last opened, as this visit
/// found them: their NEW badges stay up until it is left, though the visit
/// counts them as seen at once.

@ProviderFor(SpellbookNew)
final spellbookNewProvider = SpellbookNewProvider._();

/// The jokers unlocked since the Spellbook was last opened, as this visit
/// found them: their NEW badges stay up until it is left, though the visit
/// counts them as seen at once.
final class SpellbookNewProvider
    extends $AsyncNotifierProvider<SpellbookNew, Set<JokerId>> {
  /// The jokers unlocked since the Spellbook was last opened, as this visit
  /// found them: their NEW badges stay up until it is left, though the visit
  /// counts them as seen at once.
  SpellbookNewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spellbookNewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spellbookNewHash();

  @$internal
  @override
  SpellbookNew create() => SpellbookNew();
}

String _$spellbookNewHash() => r'c702f457014654febf507f807c3de370694bb8b6';

/// The jokers unlocked since the Spellbook was last opened, as this visit
/// found them: their NEW badges stay up until it is left, though the visit
/// counts them as seen at once.

abstract class _$SpellbookNew extends $AsyncNotifier<Set<JokerId>> {
  FutureOr<Set<JokerId>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<JokerId>>, Set<JokerId>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<JokerId>>, Set<JokerId>>,
              AsyncValue<Set<JokerId>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
