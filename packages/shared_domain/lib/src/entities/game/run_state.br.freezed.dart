// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_state.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunState {

 Board get board; RunConfig get config;/// In the order they were picked.
 List<JokerId> get jokers; RunPhase get phase;/// Joker picks made so far; the next pick starts round [pickIndex].
 int get pickIndex;/// Pieces not drawn into the tray yet.
 int get piecesLeft;/// The pieces stream's generator state; only the rules read it.
 int get piecesRngState; int get revivesUsed; int get roundIndex;/// Banked from won rounds, Saver included; the round in play isn't in it.
 int get runTotal; int get score; int get seed;/// The stones stream's generator state; only the rules read it.
 int get stonesRngState; int get storedMult; int get streak;/// Shape ids; `null` is a slot already played.
 List<int?> get tray;/// The tray slots whose piece cleared a line, one bit per slot, since the
/// tray was dealt. `null` when the tray can't earn Hat Trick: dealt short,
/// in play when a revive came, or not dealt at all.
 int? get trayClearMask;
/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunStateCopyWith<RunState> get copyWith => _$RunStateCopyWithImpl<RunState>(this as RunState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunState&&(identical(other.board, board) || other.board == board)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.jokers, jokers)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.pickIndex, pickIndex) || other.pickIndex == pickIndex)&&(identical(other.piecesLeft, piecesLeft) || other.piecesLeft == piecesLeft)&&(identical(other.piecesRngState, piecesRngState) || other.piecesRngState == piecesRngState)&&(identical(other.revivesUsed, revivesUsed) || other.revivesUsed == revivesUsed)&&(identical(other.roundIndex, roundIndex) || other.roundIndex == roundIndex)&&(identical(other.runTotal, runTotal) || other.runTotal == runTotal)&&(identical(other.score, score) || other.score == score)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.stonesRngState, stonesRngState) || other.stonesRngState == stonesRngState)&&(identical(other.storedMult, storedMult) || other.storedMult == storedMult)&&(identical(other.streak, streak) || other.streak == streak)&&const DeepCollectionEquality().equals(other.tray, tray)&&(identical(other.trayClearMask, trayClearMask) || other.trayClearMask == trayClearMask));
}


@override
int get hashCode => Object.hash(runtimeType,board,config,const DeepCollectionEquality().hash(jokers),phase,pickIndex,piecesLeft,piecesRngState,revivesUsed,roundIndex,runTotal,score,seed,stonesRngState,storedMult,streak,const DeepCollectionEquality().hash(tray),trayClearMask);

@override
String toString() {
  return 'RunState(board: $board, config: $config, jokers: $jokers, phase: $phase, pickIndex: $pickIndex, piecesLeft: $piecesLeft, piecesRngState: $piecesRngState, revivesUsed: $revivesUsed, roundIndex: $roundIndex, runTotal: $runTotal, score: $score, seed: $seed, stonesRngState: $stonesRngState, storedMult: $storedMult, streak: $streak, tray: $tray, trayClearMask: $trayClearMask)';
}


}

/// @nodoc
abstract mixin class $RunStateCopyWith<$Res>  {
  factory $RunStateCopyWith(RunState value, $Res Function(RunState) _then) = _$RunStateCopyWithImpl;
@useResult
$Res call({
 Board board, RunConfig config, List<JokerId> jokers, RunPhase phase, int pickIndex, int piecesLeft, int piecesRngState, int revivesUsed, int roundIndex, int runTotal, int score, int seed, int stonesRngState, int storedMult, int streak, List<int?> tray, int? trayClearMask
});


$BoardCopyWith<$Res> get board;$RunConfigCopyWith<$Res> get config;$RunPhaseCopyWith<$Res> get phase;

}
/// @nodoc
class _$RunStateCopyWithImpl<$Res>
    implements $RunStateCopyWith<$Res> {
  _$RunStateCopyWithImpl(this._self, this._then);

  final RunState _self;
  final $Res Function(RunState) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? config = null,Object? jokers = null,Object? phase = null,Object? pickIndex = null,Object? piecesLeft = null,Object? piecesRngState = null,Object? revivesUsed = null,Object? roundIndex = null,Object? runTotal = null,Object? score = null,Object? seed = null,Object? stonesRngState = null,Object? storedMult = null,Object? streak = null,Object? tray = null,Object? trayClearMask = freezed,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as RunConfig,jokers: null == jokers ? _self.jokers : jokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as RunPhase,pickIndex: null == pickIndex ? _self.pickIndex : pickIndex // ignore: cast_nullable_to_non_nullable
as int,piecesLeft: null == piecesLeft ? _self.piecesLeft : piecesLeft // ignore: cast_nullable_to_non_nullable
as int,piecesRngState: null == piecesRngState ? _self.piecesRngState : piecesRngState // ignore: cast_nullable_to_non_nullable
as int,revivesUsed: null == revivesUsed ? _self.revivesUsed : revivesUsed // ignore: cast_nullable_to_non_nullable
as int,roundIndex: null == roundIndex ? _self.roundIndex : roundIndex // ignore: cast_nullable_to_non_nullable
as int,runTotal: null == runTotal ? _self.runTotal : runTotal // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,stonesRngState: null == stonesRngState ? _self.stonesRngState : stonesRngState // ignore: cast_nullable_to_non_nullable
as int,storedMult: null == storedMult ? _self.storedMult : storedMult // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,tray: null == tray ? _self.tray : tray // ignore: cast_nullable_to_non_nullable
as List<int?>,trayClearMask: freezed == trayClearMask ? _self.trayClearMask : trayClearMask // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res> get board {
  
  return $BoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunConfigCopyWith<$Res> get config {
  
  return $RunConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunPhaseCopyWith<$Res> get phase {
  
  return $RunPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}
}


/// Adds pattern-matching-related methods to [RunState].
extension RunStatePatterns on RunState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunState value)  $default,){
final _that = this;
switch (_that) {
case _RunState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunState value)?  $default,){
final _that = this;
switch (_that) {
case _RunState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Board board,  RunConfig config,  List<JokerId> jokers,  RunPhase phase,  int pickIndex,  int piecesLeft,  int piecesRngState,  int revivesUsed,  int roundIndex,  int runTotal,  int score,  int seed,  int stonesRngState,  int storedMult,  int streak,  List<int?> tray,  int? trayClearMask)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunState() when $default != null:
return $default(_that.board,_that.config,_that.jokers,_that.phase,_that.pickIndex,_that.piecesLeft,_that.piecesRngState,_that.revivesUsed,_that.roundIndex,_that.runTotal,_that.score,_that.seed,_that.stonesRngState,_that.storedMult,_that.streak,_that.tray,_that.trayClearMask);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Board board,  RunConfig config,  List<JokerId> jokers,  RunPhase phase,  int pickIndex,  int piecesLeft,  int piecesRngState,  int revivesUsed,  int roundIndex,  int runTotal,  int score,  int seed,  int stonesRngState,  int storedMult,  int streak,  List<int?> tray,  int? trayClearMask)  $default,) {final _that = this;
switch (_that) {
case _RunState():
return $default(_that.board,_that.config,_that.jokers,_that.phase,_that.pickIndex,_that.piecesLeft,_that.piecesRngState,_that.revivesUsed,_that.roundIndex,_that.runTotal,_that.score,_that.seed,_that.stonesRngState,_that.storedMult,_that.streak,_that.tray,_that.trayClearMask);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Board board,  RunConfig config,  List<JokerId> jokers,  RunPhase phase,  int pickIndex,  int piecesLeft,  int piecesRngState,  int revivesUsed,  int roundIndex,  int runTotal,  int score,  int seed,  int stonesRngState,  int storedMult,  int streak,  List<int?> tray,  int? trayClearMask)?  $default,) {final _that = this;
switch (_that) {
case _RunState() when $default != null:
return $default(_that.board,_that.config,_that.jokers,_that.phase,_that.pickIndex,_that.piecesLeft,_that.piecesRngState,_that.revivesUsed,_that.roundIndex,_that.runTotal,_that.score,_that.seed,_that.stonesRngState,_that.storedMult,_that.streak,_that.tray,_that.trayClearMask);case _:
  return null;

}
}

}

/// @nodoc


class _RunState extends RunState {
  const _RunState({required this.board, required this.config, required final  List<JokerId> jokers, required this.phase, required this.pickIndex, required this.piecesLeft, required this.piecesRngState, required this.revivesUsed, required this.roundIndex, required this.runTotal, required this.score, required this.seed, required this.stonesRngState, required this.storedMult, required this.streak, required final  List<int?> tray, this.trayClearMask}): _jokers = jokers,_tray = tray,super._();
  

@override final  Board board;
@override final  RunConfig config;
/// In the order they were picked.
 final  List<JokerId> _jokers;
/// In the order they were picked.
@override List<JokerId> get jokers {
  if (_jokers is EqualUnmodifiableListView) return _jokers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jokers);
}

@override final  RunPhase phase;
/// Joker picks made so far; the next pick starts round [pickIndex].
@override final  int pickIndex;
/// Pieces not drawn into the tray yet.
@override final  int piecesLeft;
/// The pieces stream's generator state; only the rules read it.
@override final  int piecesRngState;
@override final  int revivesUsed;
@override final  int roundIndex;
/// Banked from won rounds, Saver included; the round in play isn't in it.
@override final  int runTotal;
@override final  int score;
@override final  int seed;
/// The stones stream's generator state; only the rules read it.
@override final  int stonesRngState;
@override final  int storedMult;
@override final  int streak;
/// Shape ids; `null` is a slot already played.
 final  List<int?> _tray;
/// Shape ids; `null` is a slot already played.
@override List<int?> get tray {
  if (_tray is EqualUnmodifiableListView) return _tray;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tray);
}

/// The tray slots whose piece cleared a line, one bit per slot, since the
/// tray was dealt. `null` when the tray can't earn Hat Trick: dealt short,
/// in play when a revive came, or not dealt at all.
@override final  int? trayClearMask;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunStateCopyWith<_RunState> get copyWith => __$RunStateCopyWithImpl<_RunState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunState&&(identical(other.board, board) || other.board == board)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other._jokers, _jokers)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.pickIndex, pickIndex) || other.pickIndex == pickIndex)&&(identical(other.piecesLeft, piecesLeft) || other.piecesLeft == piecesLeft)&&(identical(other.piecesRngState, piecesRngState) || other.piecesRngState == piecesRngState)&&(identical(other.revivesUsed, revivesUsed) || other.revivesUsed == revivesUsed)&&(identical(other.roundIndex, roundIndex) || other.roundIndex == roundIndex)&&(identical(other.runTotal, runTotal) || other.runTotal == runTotal)&&(identical(other.score, score) || other.score == score)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.stonesRngState, stonesRngState) || other.stonesRngState == stonesRngState)&&(identical(other.storedMult, storedMult) || other.storedMult == storedMult)&&(identical(other.streak, streak) || other.streak == streak)&&const DeepCollectionEquality().equals(other._tray, _tray)&&(identical(other.trayClearMask, trayClearMask) || other.trayClearMask == trayClearMask));
}


@override
int get hashCode => Object.hash(runtimeType,board,config,const DeepCollectionEquality().hash(_jokers),phase,pickIndex,piecesLeft,piecesRngState,revivesUsed,roundIndex,runTotal,score,seed,stonesRngState,storedMult,streak,const DeepCollectionEquality().hash(_tray),trayClearMask);

@override
String toString() {
  return 'RunState(board: $board, config: $config, jokers: $jokers, phase: $phase, pickIndex: $pickIndex, piecesLeft: $piecesLeft, piecesRngState: $piecesRngState, revivesUsed: $revivesUsed, roundIndex: $roundIndex, runTotal: $runTotal, score: $score, seed: $seed, stonesRngState: $stonesRngState, storedMult: $storedMult, streak: $streak, tray: $tray, trayClearMask: $trayClearMask)';
}


}

/// @nodoc
abstract mixin class _$RunStateCopyWith<$Res> implements $RunStateCopyWith<$Res> {
  factory _$RunStateCopyWith(_RunState value, $Res Function(_RunState) _then) = __$RunStateCopyWithImpl;
@override @useResult
$Res call({
 Board board, RunConfig config, List<JokerId> jokers, RunPhase phase, int pickIndex, int piecesLeft, int piecesRngState, int revivesUsed, int roundIndex, int runTotal, int score, int seed, int stonesRngState, int storedMult, int streak, List<int?> tray, int? trayClearMask
});


@override $BoardCopyWith<$Res> get board;@override $RunConfigCopyWith<$Res> get config;@override $RunPhaseCopyWith<$Res> get phase;

}
/// @nodoc
class __$RunStateCopyWithImpl<$Res>
    implements _$RunStateCopyWith<$Res> {
  __$RunStateCopyWithImpl(this._self, this._then);

  final _RunState _self;
  final $Res Function(_RunState) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? config = null,Object? jokers = null,Object? phase = null,Object? pickIndex = null,Object? piecesLeft = null,Object? piecesRngState = null,Object? revivesUsed = null,Object? roundIndex = null,Object? runTotal = null,Object? score = null,Object? seed = null,Object? stonesRngState = null,Object? storedMult = null,Object? streak = null,Object? tray = null,Object? trayClearMask = freezed,}) {
  return _then(_RunState(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as RunConfig,jokers: null == jokers ? _self._jokers : jokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as RunPhase,pickIndex: null == pickIndex ? _self.pickIndex : pickIndex // ignore: cast_nullable_to_non_nullable
as int,piecesLeft: null == piecesLeft ? _self.piecesLeft : piecesLeft // ignore: cast_nullable_to_non_nullable
as int,piecesRngState: null == piecesRngState ? _self.piecesRngState : piecesRngState // ignore: cast_nullable_to_non_nullable
as int,revivesUsed: null == revivesUsed ? _self.revivesUsed : revivesUsed // ignore: cast_nullable_to_non_nullable
as int,roundIndex: null == roundIndex ? _self.roundIndex : roundIndex // ignore: cast_nullable_to_non_nullable
as int,runTotal: null == runTotal ? _self.runTotal : runTotal // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,stonesRngState: null == stonesRngState ? _self.stonesRngState : stonesRngState // ignore: cast_nullable_to_non_nullable
as int,storedMult: null == storedMult ? _self.storedMult : storedMult // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,tray: null == tray ? _self._tray : tray // ignore: cast_nullable_to_non_nullable
as List<int?>,trayClearMask: freezed == trayClearMask ? _self.trayClearMask : trayClearMask // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res> get board {
  
  return $BoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunConfigCopyWith<$Res> get config {
  
  return $RunConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunPhaseCopyWith<$Res> get phase {
  
  return $RunPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}
}

// dart format on
