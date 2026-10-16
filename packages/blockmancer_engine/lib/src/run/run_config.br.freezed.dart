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

 int get pieces; int get target; bool get isBoss;/// Stones on the board when the round starts.
 int get stones;
/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundSpecCopyWith<RoundSpec> get copyWith => _$RoundSpecCopyWithImpl<RoundSpec>(this as RoundSpec, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundSpec&&(identical(other.pieces, pieces) || other.pieces == pieces)&&(identical(other.target, target) || other.target == target)&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.stones, stones) || other.stones == stones));
}


@override
int get hashCode => Object.hash(runtimeType,pieces,target,isBoss,stones);

@override
String toString() {
  return 'RoundSpec(pieces: $pieces, target: $target, isBoss: $isBoss, stones: $stones)';
}


}

/// @nodoc
abstract mixin class $RoundSpecCopyWith<$Res>  {
  factory $RoundSpecCopyWith(RoundSpec value, $Res Function(RoundSpec) _then) = _$RoundSpecCopyWithImpl;
@useResult
$Res call({
 int pieces, int target, bool isBoss, int stones
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
@pragma('vm:prefer-inline') @override $Res call({Object? pieces = null,Object? target = null,Object? isBoss = null,Object? stones = null,}) {
  return _then(_self.copyWith(
pieces: null == pieces ? _self.pieces : pieces // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,stones: null == stones ? _self.stones : stones // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pieces,  int target,  bool isBoss,  int stones)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that.pieces,_that.target,_that.isBoss,_that.stones);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pieces,  int target,  bool isBoss,  int stones)  $default,) {final _that = this;
switch (_that) {
case _RoundSpec():
return $default(_that.pieces,_that.target,_that.isBoss,_that.stones);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pieces,  int target,  bool isBoss,  int stones)?  $default,) {final _that = this;
switch (_that) {
case _RoundSpec() when $default != null:
return $default(_that.pieces,_that.target,_that.isBoss,_that.stones);case _:
  return null;

}
}

}

/// @nodoc


class _RoundSpec implements RoundSpec {
  const _RoundSpec({required this.pieces, required this.target, this.isBoss = false, this.stones = 0});
  

@override final  int pieces;
@override final  int target;
@override@JsonKey() final  bool isBoss;
/// Stones on the board when the round starts.
@override@JsonKey() final  int stones;

/// Create a copy of RoundSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundSpecCopyWith<_RoundSpec> get copyWith => __$RoundSpecCopyWithImpl<_RoundSpec>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoundSpec&&(identical(other.pieces, pieces) || other.pieces == pieces)&&(identical(other.target, target) || other.target == target)&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.stones, stones) || other.stones == stones));
}


@override
int get hashCode => Object.hash(runtimeType,pieces,target,isBoss,stones);

@override
String toString() {
  return 'RoundSpec(pieces: $pieces, target: $target, isBoss: $isBoss, stones: $stones)';
}


}

/// @nodoc
abstract mixin class _$RoundSpecCopyWith<$Res> implements $RoundSpecCopyWith<$Res> {
  factory _$RoundSpecCopyWith(_RoundSpec value, $Res Function(_RoundSpec) _then) = __$RoundSpecCopyWithImpl;
@override @useResult
$Res call({
 int pieces, int target, bool isBoss, int stones
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
@override @pragma('vm:prefer-inline') $Res call({Object? pieces = null,Object? target = null,Object? isBoss = null,Object? stones = null,}) {
  return _then(_RoundSpec(
pieces: null == pieces ? _self.pieces : pieces // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,stones: null == stones ? _self.stones : stones // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RunConfig {

 int get offerCount;/// The chance that one offer is the partner of a joker already owned.
 double get partnerBias; int get revivePieces; int get reviveRows; int get revivesPerRun; List<RoundSpec> get rounds; int get traySize;
/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunConfigCopyWith<RunConfig> get copyWith => _$RunConfigCopyWithImpl<RunConfig>(this as RunConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunConfig&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.partnerBias, partnerBias) || other.partnerBias == partnerBias)&&(identical(other.revivePieces, revivePieces) || other.revivePieces == revivePieces)&&(identical(other.reviveRows, reviveRows) || other.reviveRows == reviveRows)&&(identical(other.revivesPerRun, revivesPerRun) || other.revivesPerRun == revivesPerRun)&&const DeepCollectionEquality().equals(other.rounds, rounds)&&(identical(other.traySize, traySize) || other.traySize == traySize));
}


@override
int get hashCode => Object.hash(runtimeType,offerCount,partnerBias,revivePieces,reviveRows,revivesPerRun,const DeepCollectionEquality().hash(rounds),traySize);

@override
String toString() {
  return 'RunConfig(offerCount: $offerCount, partnerBias: $partnerBias, revivePieces: $revivePieces, reviveRows: $reviveRows, revivesPerRun: $revivesPerRun, rounds: $rounds, traySize: $traySize)';
}


}

/// @nodoc
abstract mixin class $RunConfigCopyWith<$Res>  {
  factory $RunConfigCopyWith(RunConfig value, $Res Function(RunConfig) _then) = _$RunConfigCopyWithImpl;
@useResult
$Res call({
 int offerCount, double partnerBias, int revivePieces, int reviveRows, int revivesPerRun, List<RoundSpec> rounds, int traySize
});




}
/// @nodoc
class _$RunConfigCopyWithImpl<$Res>
    implements $RunConfigCopyWith<$Res> {
  _$RunConfigCopyWithImpl(this._self, this._then);

  final RunConfig _self;
  final $Res Function(RunConfig) _then;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offerCount = null,Object? partnerBias = null,Object? revivePieces = null,Object? reviveRows = null,Object? revivesPerRun = null,Object? rounds = null,Object? traySize = null,}) {
  return _then(_self.copyWith(
offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,partnerBias: null == partnerBias ? _self.partnerBias : partnerBias // ignore: cast_nullable_to_non_nullable
as double,revivePieces: null == revivePieces ? _self.revivePieces : revivePieces // ignore: cast_nullable_to_non_nullable
as int,reviveRows: null == reviveRows ? _self.reviveRows : reviveRows // ignore: cast_nullable_to_non_nullable
as int,revivesPerRun: null == revivesPerRun ? _self.revivesPerRun : revivesPerRun // ignore: cast_nullable_to_non_nullable
as int,rounds: null == rounds ? _self.rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<RoundSpec>,traySize: null == traySize ? _self.traySize : traySize // ignore: cast_nullable_to_non_nullable
as int,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int traySize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.traySize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int traySize)  $default,) {final _that = this;
switch (_that) {
case _RunConfig():
return $default(_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.traySize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int offerCount,  double partnerBias,  int revivePieces,  int reviveRows,  int revivesPerRun,  List<RoundSpec> rounds,  int traySize)?  $default,) {final _that = this;
switch (_that) {
case _RunConfig() when $default != null:
return $default(_that.offerCount,_that.partnerBias,_that.revivePieces,_that.reviveRows,_that.revivesPerRun,_that.rounds,_that.traySize);case _:
  return null;

}
}

}

/// @nodoc


class _RunConfig implements RunConfig {
  const _RunConfig({this.offerCount = 3, this.partnerBias = 0.75, this.revivePieces = 3, this.reviveRows = 2, this.revivesPerRun = 1, final  List<RoundSpec> rounds = defaultRounds, this.traySize = 3}): _rounds = rounds;
  

@override@JsonKey() final  int offerCount;
/// The chance that one offer is the partner of a joker already owned.
@override@JsonKey() final  double partnerBias;
@override@JsonKey() final  int revivePieces;
@override@JsonKey() final  int reviveRows;
@override@JsonKey() final  int revivesPerRun;
 final  List<RoundSpec> _rounds;
@override@JsonKey() List<RoundSpec> get rounds {
  if (_rounds is EqualUnmodifiableListView) return _rounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rounds);
}

@override@JsonKey() final  int traySize;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunConfigCopyWith<_RunConfig> get copyWith => __$RunConfigCopyWithImpl<_RunConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunConfig&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.partnerBias, partnerBias) || other.partnerBias == partnerBias)&&(identical(other.revivePieces, revivePieces) || other.revivePieces == revivePieces)&&(identical(other.reviveRows, reviveRows) || other.reviveRows == reviveRows)&&(identical(other.revivesPerRun, revivesPerRun) || other.revivesPerRun == revivesPerRun)&&const DeepCollectionEquality().equals(other._rounds, _rounds)&&(identical(other.traySize, traySize) || other.traySize == traySize));
}


@override
int get hashCode => Object.hash(runtimeType,offerCount,partnerBias,revivePieces,reviveRows,revivesPerRun,const DeepCollectionEquality().hash(_rounds),traySize);

@override
String toString() {
  return 'RunConfig(offerCount: $offerCount, partnerBias: $partnerBias, revivePieces: $revivePieces, reviveRows: $reviveRows, revivesPerRun: $revivesPerRun, rounds: $rounds, traySize: $traySize)';
}


}

/// @nodoc
abstract mixin class _$RunConfigCopyWith<$Res> implements $RunConfigCopyWith<$Res> {
  factory _$RunConfigCopyWith(_RunConfig value, $Res Function(_RunConfig) _then) = __$RunConfigCopyWithImpl;
@override @useResult
$Res call({
 int offerCount, double partnerBias, int revivePieces, int reviveRows, int revivesPerRun, List<RoundSpec> rounds, int traySize
});




}
/// @nodoc
class __$RunConfigCopyWithImpl<$Res>
    implements _$RunConfigCopyWith<$Res> {
  __$RunConfigCopyWithImpl(this._self, this._then);

  final _RunConfig _self;
  final $Res Function(_RunConfig) _then;

/// Create a copy of RunConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offerCount = null,Object? partnerBias = null,Object? revivePieces = null,Object? reviveRows = null,Object? revivesPerRun = null,Object? rounds = null,Object? traySize = null,}) {
  return _then(_RunConfig(
offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,partnerBias: null == partnerBias ? _self.partnerBias : partnerBias // ignore: cast_nullable_to_non_nullable
as double,revivePieces: null == revivePieces ? _self.revivePieces : revivePieces // ignore: cast_nullable_to_non_nullable
as int,reviveRows: null == reviveRows ? _self.reviveRows : reviveRows // ignore: cast_nullable_to_non_nullable
as int,revivesPerRun: null == revivesPerRun ? _self.revivesPerRun : revivesPerRun // ignore: cast_nullable_to_non_nullable
as int,rounds: null == rounds ? _self._rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<RoundSpec>,traySize: null == traySize ? _self.traySize : traySize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
