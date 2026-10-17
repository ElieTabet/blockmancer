// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_config.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoundSpec {

/// How the round is presented, and the round a world's boss rule holds
/// in. The run ends after the last round, whichever it is.
 bool get isBoss; int get pieces;/// Stones on the board when the round starts, in a round whose world rule
/// drops them (Rubble's boss).
 int get stones; int get target;
/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundSpecCopyWith<RoundSpec> get copyWith => _$RoundSpecCopyWithImpl<RoundSpec>(this as RoundSpec, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundSpec&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.pieces, pieces) || other.pieces == pieces)&&(identical(other.stones, stones) || other.stones == stones)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode => Object.hash(runtimeType,isBoss,pieces,stones,target);

@override
String toString() {
  return 'RoundSpec(isBoss: $isBoss, pieces: $pieces, stones: $stones, target: $target)';
}


}

/// @nodoc
abstract mixin class $RoundSpecCopyWith<$Res>  {
  factory $RoundSpecCopyWith(RoundSpec value, $Res Function(RoundSpec) _then) = _$RoundSpecCopyWithImpl;
@useResult
$Res call({
 bool isBoss, int pieces, int stones, int target
});




}
/// @nodoc
class _$RoundSpecCopyWithImpl<$Res>
    implements $RoundSpecCopyWith<$Res> {
  _$RoundSpecCopyWithImpl(this._self, this._then);

  final RoundSpec _self;
  final $Res Function(RoundSpec) _then;

/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isBoss = null,Object? pieces = null,Object? stones = null,Object? target = null,}) {
  return _then(_self.copyWith(
isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,pieces: null == pieces ? _self.pieces : pieces // ignore: cast_nullable_to_non_nullable
as int,stones: null == stones ? _self.stones : stones // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RoundSpec].
extension RoundSpecPatterns on RoundSpec {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoundSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoundSpec value)  $default,){
final _that = this;
switch (_that) {
case _RoundSpec():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoundSpec value)?  $default,){
final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isBoss,  int pieces,  int stones,  int target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that.isBoss,_that.pieces,_that.stones,_that.target);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isBoss,  int pieces,  int stones,  int target)  $default,) {final _that = this;
switch (_that) {
case _RoundSpec():
return $default(_that.isBoss,_that.pieces,_that.stones,_that.target);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isBoss,  int pieces,  int stones,  int target)?  $default,) {final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that.isBoss,_that.pieces,_that.stones,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _RoundSpec implements RoundSpec {
  const _RoundSpec({required this.isBoss, required this.pieces, required this.stones, required this.target});
  

/// How the round is presented, and the round a world's boss rule holds
/// in. The run ends after the last round, whichever it is.
@override final  bool isBoss;
@override final  int pieces;
/// Stones on the board when the round starts, in a round whose world rule
/// drops them (Rubble's boss).
@override final  int stones;
@override final  int target;

/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundSpecCopyWith<_RoundSpec> get copyWith => __$RoundSpecCopyWithImpl<_RoundSpec>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoundSpec&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.pieces, pieces) || other.pieces == pieces)&&(identical(other.stones, stones) || other.stones == stones)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode => Object.hash(runtimeType,isBoss,pieces,stones,target);

@override
String toString() {
  return 'RoundSpec(isBoss: $isBoss, pieces: $pieces, stones: $stones, target: $target)';
}


}

/// @nodoc
abstract mixin class _$RoundSpecCopyWith<$Res> implements $RoundSpecCopyWith<$Res> {
  factory _$RoundSpecCopyWith(_RoundSpec value, $Res Function(_RoundSpec) _then) = __$RoundSpecCopyWithImpl;
@override @useResult
$Res call({
 bool isBoss, int pieces, int stones, int target
});




}
/// @nodoc
class __$RoundSpecCopyWithImpl<$Res>
    implements _$RoundSpecCopyWith<$Res> {
  __$RoundSpecCopyWithImpl(this._self, this._then);

  final _RoundSpec _self;
  final $Res Function(_RoundSpec) _then;

/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isBoss = null,Object? pieces = null,Object? stones = null,Object? target = null,}) {
  return _then(_RoundSpec(
isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,pieces: null == pieces ? _self.pieces : pieces // ignore: cast_nullable_to_non_nullable
as int,stones: null == stones ? _self.stones : stones // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RunConfig {

/// Chips a cleared cell scores, before any joker.
 int get chipsPerCell;/// The jokers offers may draw from, owned ones aside. A set in all but
/// type: offers draw in the rules' own order, so how the list is ordered
/// never changes a seeded run.
 List<JokerId> get jokerPool; JokerTuning get jokers; int get offerCount;/// The chance that one offer is the partner of a joker already owned.
 double get partnerBias; int get revivePieces; int get reviveRows; int get revivesPerRun; List<RoundSpec> get rounds;/// The run total that earns the world's third star.
 int get starThreshold; int get traySize;/// The world whose boss rule the run plays under.
 WorldId get world;
/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunConfigCopyWith<RunConfig> get copyWith => _$RunConfigCopyWithImpl<RunConfig>(this as RunConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunConfig&&(identical(other.chipsPerCell, chipsPerCell) || other.chipsPerCell == chipsPerCell)&&const DeepCollectionEquality().equals(other.jokerPool, jokerPool)&&(identical(other.jokers, jokers) || other.jokers == jokers)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.partnerBias, partnerBias) || other.partnerBias == partnerBias)&&(identical(other.revivePieces, revivePieces) || other.revivePieces == revivePieces)&&(identical(other.reviveRows, reviveRows) || other.reviveRows == reviveRows)&&(identical(other.revivesPerRun, revivesPerRun) || other.revivesPerRun == revivesPerRun)&&const DeepCollectionEquality().equals(other.rounds, rounds)&&(identical(other.starThreshold, starThreshold) || other.starThreshold == starThreshold)&&(identical(other.traySize, traySize) || other.traySize == traySize)&&(identical(other.world, world) || other.world == world));
}


@override
int get hashCode => Object.hash(runtimeType,chipsPerCell,const DeepCollectionEquality().hash(jokerPool),jokers,offerCount,partnerBias,revivePieces,reviveRows,revivesPerRun,const DeepCollectionEquality().hash(rounds),starThreshold,traySize,world);

@override
String toString() {
  return 'RunConfig(chipsPerCell: $chipsPerCell, jokerPool: $jokerPool, jokers: $jokers, offerCount: $offerCount, partnerBias: $partnerBias, revivePieces: $revivePieces, reviveRows: $reviveRows, revivesPerRun: $revivesPerRun, rounds: $rounds, starThreshold: $starThreshold, traySize: $traySize, world: $world)';
}


}

/// @nodoc
abstract mixin class $RunConfigCopyWith<$Res>  {
  factory $RunConfigCopyWith(RunConfig value, $Res Function(RunConfig) _then) = _$RunConfigCopyWithImpl;
@useResult
$Res call({
 int chipsPerCell, List<JokerId> jokerPool, JokerTuning jokers, int offerCount, double partnerBias, int revivePieces, int reviveRows, int revivesPerRun, List<RoundSpec> rounds, int starThreshold, int traySize, WorldId world
});


$JokerTuningCopyWith<$Res> get jokers;

}
/// @nodoc
class _$RunConfigCopyWithImpl<$Res>
    implements $RunConfigCopyWith<$Res> {
  _$RunConfigCopyWithImpl(this._self, this._then);

  final RunConfig _self;
  final $Res Function(RunConfig) _then;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chipsPerCell = null,Object? jokerPool = null,Object? jokers = null,Object? offerCount = null,Object? partnerBias = null,Object? revivePieces = null,Object? reviveRows = null,Object? revivesPerRun = null,Object? rounds = null,Object? starThreshold = null,Object? traySize = null,Object? world = null,}) {
  return _then(_self.copyWith(
chipsPerCell: null == chipsPerCell ? _self.chipsPerCell : chipsPerCell // ignore: cast_nullable_to_non_nullable
as int,jokerPool: null == jokerPool ? _self.jokerPool : jokerPool // ignore: cast_nullable_to_non_nullable
as List<JokerId>,jokers: null == jokers ? _self.jokers : jokers // ignore: cast_nullable_to_non_nullable
as JokerTuning,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,partnerBias: null == partnerBias ? _self.partnerBias : partnerBias // ignore: cast_nullable_to_non_nullable
as double,revivePieces: null == revivePieces ? _self.revivePieces : revivePieces // ignore: cast_nullable_to_non_nullable
as int,reviveRows: null == reviveRows ? _self.reviveRows : reviveRows // ignore: cast_nullable_to_non_nullable
as int,revivesPerRun: null == revivesPerRun ? _self.revivesPerRun : revivesPerRun // ignore: cast_nullable_to_non_nullable
as int,rounds: null == rounds ? _self.rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<RoundSpec>,starThreshold: null == starThreshold ? _self.starThreshold : starThreshold // ignore: cast_nullable_to_non_nullable
as int,traySize: null == traySize ? _self.traySize : traySize // ignore: cast_nullable_to_non_nullable
as int,world: null == world ? _self.world : world // ignore: cast_nullable_to_non_nullable
as WorldId,
  ));
}
/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get jokers {
  
  return $JokerTuningCopyWith<$Res>(_self.jokers, (value) {
    return _then(_self.copyWith(jokers: value));
  });
}
}


/// Adds pattern-matching-related methods to [RunConfig].
extension RunConfigPatterns on RunConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunConfig value)  $default,){
final _that = this;
switch (_that) {
case _RunConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chipsPerCell,  List<JokerId> jokerPool,  JokerTuning jokers,  int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int starThreshold,  int traySize,  WorldId world)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that.chipsPerCell,_that.jokerPool,_that.jokers,_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.starThreshold,_that.traySize,_that.world);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chipsPerCell,  List<JokerId> jokerPool,  JokerTuning jokers,  int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int starThreshold,  int traySize,  WorldId world)  $default,) {final _that = this;
switch (_that) {
case _RunConfig():
return $default(_that.chipsPerCell,_that.jokerPool,_that.jokers,_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.starThreshold,_that.traySize,_that.world);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chipsPerCell,  List<JokerId> jokerPool,  JokerTuning jokers,  int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int starThreshold,  int traySize,  WorldId world)?  $default,) {final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that.chipsPerCell,_that.jokerPool,_that.jokers,_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.starThreshold,_that.traySize,_that.world);case _:
  return null;

}
}

}

/// @nodoc


class _RunConfig implements RunConfig {
  const _RunConfig({required this.chipsPerCell, required final  List<JokerId> jokerPool, required this.jokers, required this.offerCount, required this.partnerBias, required this.revivePieces, required this.reviveRows, required this.revivesPerRun, required final  List<RoundSpec> rounds, required this.starThreshold, required this.traySize, required this.world}): _jokerPool = jokerPool,_rounds = rounds;
  

/// Chips a cleared cell scores, before any joker.
@override final  int chipsPerCell;
/// The jokers offers may draw from, owned ones aside. A set in all but
/// type: offers draw in the rules' own order, so how the list is ordered
/// never changes a seeded run.
 final  List<JokerId> _jokerPool;
/// The jokers offers may draw from, owned ones aside. A set in all but
/// type: offers draw in the rules' own order, so how the list is ordered
/// never changes a seeded run.
@override List<JokerId> get jokerPool {
  if (_jokerPool is EqualUnmodifiableListView) return _jokerPool;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jokerPool);
}

@override final  JokerTuning jokers;
@override final  int offerCount;
/// The chance that one offer is the partner of a joker already owned.
@override final  double partnerBias;
@override final  int revivePieces;
@override final  int reviveRows;
@override final  int revivesPerRun;
 final  List<RoundSpec> _rounds;
@override List<RoundSpec> get rounds {
  if (_rounds is EqualUnmodifiableListView) return _rounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rounds);
}

/// The run total that earns the world's third star.
@override final  int starThreshold;
@override final  int traySize;
/// The world whose boss rule the run plays under.
@override final  WorldId world;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunConfigCopyWith<_RunConfig> get copyWith => __$RunConfigCopyWithImpl<_RunConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunConfig&&(identical(other.chipsPerCell, chipsPerCell) || other.chipsPerCell == chipsPerCell)&&const DeepCollectionEquality().equals(other._jokerPool, _jokerPool)&&(identical(other.jokers, jokers) || other.jokers == jokers)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.partnerBias, partnerBias) || other.partnerBias == partnerBias)&&(identical(other.revivePieces, revivePieces) || other.revivePieces == revivePieces)&&(identical(other.reviveRows, reviveRows) || other.reviveRows == reviveRows)&&(identical(other.revivesPerRun, revivesPerRun) || other.revivesPerRun == revivesPerRun)&&const DeepCollectionEquality().equals(other._rounds, _rounds)&&(identical(other.starThreshold, starThreshold) || other.starThreshold == starThreshold)&&(identical(other.traySize, traySize) || other.traySize == traySize)&&(identical(other.world, world) || other.world == world));
}


@override
int get hashCode => Object.hash(runtimeType,chipsPerCell,const DeepCollectionEquality().hash(_jokerPool),jokers,offerCount,partnerBias,revivePieces,reviveRows,revivesPerRun,const DeepCollectionEquality().hash(_rounds),starThreshold,traySize,world);

@override
String toString() {
  return 'RunConfig(chipsPerCell: $chipsPerCell, jokerPool: $jokerPool, jokers: $jokers, offerCount: $offerCount, partnerBias: $partnerBias, revivePieces: $revivePieces, reviveRows: $reviveRows, revivesPerRun: $revivesPerRun, rounds: $rounds, starThreshold: $starThreshold, traySize: $traySize, world: $world)';
}


}

/// @nodoc
abstract mixin class _$RunConfigCopyWith<$Res> implements $RunConfigCopyWith<$Res> {
  factory _$RunConfigCopyWith(_RunConfig value, $Res Function(_RunConfig) _then) = __$RunConfigCopyWithImpl;
@override @useResult
$Res call({
 int chipsPerCell, List<JokerId> jokerPool, JokerTuning jokers, int offerCount, double partnerBias, int revivePieces, int reviveRows, int revivesPerRun, List<RoundSpec> rounds, int starThreshold, int traySize, WorldId world
});


@override $JokerTuningCopyWith<$Res> get jokers;

}
/// @nodoc
class __$RunConfigCopyWithImpl<$Res>
    implements _$RunConfigCopyWith<$Res> {
  __$RunConfigCopyWithImpl(this._self, this._then);

  final _RunConfig _self;
  final $Res Function(_RunConfig) _then;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chipsPerCell = null,Object? jokerPool = null,Object? jokers = null,Object? offerCount = null,Object? partnerBias = null,Object? revivePieces = null,Object? reviveRows = null,Object? revivesPerRun = null,Object? rounds = null,Object? starThreshold = null,Object? traySize = null,Object? world = null,}) {
  return _then(_RunConfig(
chipsPerCell: null == chipsPerCell ? _self.chipsPerCell : chipsPerCell // ignore: cast_nullable_to_non_nullable
as int,jokerPool: null == jokerPool ? _self._jokerPool : jokerPool // ignore: cast_nullable_to_non_nullable
as List<JokerId>,jokers: null == jokers ? _self.jokers : jokers // ignore: cast_nullable_to_non_nullable
as JokerTuning,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,partnerBias: null == partnerBias ? _self.partnerBias : partnerBias // ignore: cast_nullable_to_non_nullable
as double,revivePieces: null == revivePieces ? _self.revivePieces : revivePieces // ignore: cast_nullable_to_non_nullable
as int,reviveRows: null == reviveRows ? _self.reviveRows : reviveRows // ignore: cast_nullable_to_non_nullable
as int,revivesPerRun: null == revivesPerRun ? _self.revivesPerRun : revivesPerRun // ignore: cast_nullable_to_non_nullable
as int,rounds: null == rounds ? _self._rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<RoundSpec>,starThreshold: null == starThreshold ? _self.starThreshold : starThreshold // ignore: cast_nullable_to_non_nullable
as int,traySize: null == traySize ? _self.traySize : traySize // ignore: cast_nullable_to_non_nullable
as int,world: null == world ? _self.world : world // ignore: cast_nullable_to_non_nullable
as WorldId,
  ));
}

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get jokers {
  
  return $JokerTuningCopyWith<$Res>(_self.jokers, (value) {
    return _then(_self.copyWith(jokers: value));
  });
}
}

// dart format on
