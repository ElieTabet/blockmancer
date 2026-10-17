// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_summary.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorldSummary {

/// The points its boss round asks for; 0 for a world that isn't
/// [playable].
 int get bossTarget; WorldId get id;/// The numbers [unlocks] play with, for describing them.
 JokerTuning get jokerTuning;/// Whether it has its rules yet; the others are "coming soon".
 bool get playable;/// The run total that earns its third star; 0 for a world that isn't
/// [playable].
 int get starThreshold;/// The jokers beating its boss unlocks.
 List<JokerId> get unlocks;
/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldSummaryCopyWith<WorldSummary> get copyWith => _$WorldSummaryCopyWithImpl<WorldSummary>(this as WorldSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldSummary&&(identical(other.bossTarget, bossTarget) || other.bossTarget == bossTarget)&&(identical(other.id, id) || other.id == id)&&(identical(other.jokerTuning, jokerTuning) || other.jokerTuning == jokerTuning)&&(identical(other.playable, playable) || other.playable == playable)&&(identical(other.starThreshold, starThreshold) || other.starThreshold == starThreshold)&&const DeepCollectionEquality().equals(other.unlocks, unlocks));
}


@override
int get hashCode => Object.hash(runtimeType,bossTarget,id,jokerTuning,playable,starThreshold,const DeepCollectionEquality().hash(unlocks));

@override
String toString() {
  return 'WorldSummary(bossTarget: $bossTarget, id: $id, jokerTuning: $jokerTuning, playable: $playable, starThreshold: $starThreshold, unlocks: $unlocks)';
}


}

/// @nodoc
abstract mixin class $WorldSummaryCopyWith<$Res>  {
  factory $WorldSummaryCopyWith(WorldSummary value, $Res Function(WorldSummary) _then) = _$WorldSummaryCopyWithImpl;
@useResult
$Res call({
 int bossTarget, WorldId id, JokerTuning jokerTuning, bool playable, int starThreshold, List<JokerId> unlocks
});


$JokerTuningCopyWith<$Res> get jokerTuning;

}
/// @nodoc
class _$WorldSummaryCopyWithImpl<$Res>
    implements $WorldSummaryCopyWith<$Res> {
  _$WorldSummaryCopyWithImpl(this._self, this._then);

  final WorldSummary _self;
  final $Res Function(WorldSummary) _then;

/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bossTarget = null,Object? id = null,Object? jokerTuning = null,Object? playable = null,Object? starThreshold = null,Object? unlocks = null,}) {
  return _then(_self.copyWith(
bossTarget: null == bossTarget ? _self.bossTarget : bossTarget // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as WorldId,jokerTuning: null == jokerTuning ? _self.jokerTuning : jokerTuning // ignore: cast_nullable_to_non_nullable
as JokerTuning,playable: null == playable ? _self.playable : playable // ignore: cast_nullable_to_non_nullable
as bool,starThreshold: null == starThreshold ? _self.starThreshold : starThreshold // ignore: cast_nullable_to_non_nullable
as int,unlocks: null == unlocks ? _self.unlocks : unlocks // ignore: cast_nullable_to_non_nullable
as List<JokerId>,
  ));
}
/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get jokerTuning {
  
  return $JokerTuningCopyWith<$Res>(_self.jokerTuning, (value) {
    return _then(_self.copyWith(jokerTuning: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorldSummary].
extension WorldSummaryPatterns on WorldSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorldSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorldSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorldSummary value)  $default,){
final _that = this;
switch (_that) {
case _WorldSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorldSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WorldSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bossTarget,  WorldId id,  JokerTuning jokerTuning,  bool playable,  int starThreshold,  List<JokerId> unlocks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorldSummary() when $default != null:
return $default(_that.bossTarget,_that.id,_that.jokerTuning,_that.playable,_that.starThreshold,_that.unlocks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bossTarget,  WorldId id,  JokerTuning jokerTuning,  bool playable,  int starThreshold,  List<JokerId> unlocks)  $default,) {final _that = this;
switch (_that) {
case _WorldSummary():
return $default(_that.bossTarget,_that.id,_that.jokerTuning,_that.playable,_that.starThreshold,_that.unlocks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bossTarget,  WorldId id,  JokerTuning jokerTuning,  bool playable,  int starThreshold,  List<JokerId> unlocks)?  $default,) {final _that = this;
switch (_that) {
case _WorldSummary() when $default != null:
return $default(_that.bossTarget,_that.id,_that.jokerTuning,_that.playable,_that.starThreshold,_that.unlocks);case _:
  return null;

}
}

}

/// @nodoc


class _WorldSummary implements WorldSummary {
  const _WorldSummary({required this.bossTarget, required this.id, required this.jokerTuning, required this.playable, required this.starThreshold, required final  List<JokerId> unlocks}): _unlocks = unlocks;
  

/// The points its boss round asks for; 0 for a world that isn't
/// [playable].
@override final  int bossTarget;
@override final  WorldId id;
/// The numbers [unlocks] play with, for describing them.
@override final  JokerTuning jokerTuning;
/// Whether it has its rules yet; the others are "coming soon".
@override final  bool playable;
/// The run total that earns its third star; 0 for a world that isn't
/// [playable].
@override final  int starThreshold;
/// The jokers beating its boss unlocks.
 final  List<JokerId> _unlocks;
/// The jokers beating its boss unlocks.
@override List<JokerId> get unlocks {
  if (_unlocks is EqualUnmodifiableListView) return _unlocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unlocks);
}


/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldSummaryCopyWith<_WorldSummary> get copyWith => __$WorldSummaryCopyWithImpl<_WorldSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorldSummary&&(identical(other.bossTarget, bossTarget) || other.bossTarget == bossTarget)&&(identical(other.id, id) || other.id == id)&&(identical(other.jokerTuning, jokerTuning) || other.jokerTuning == jokerTuning)&&(identical(other.playable, playable) || other.playable == playable)&&(identical(other.starThreshold, starThreshold) || other.starThreshold == starThreshold)&&const DeepCollectionEquality().equals(other._unlocks, _unlocks));
}


@override
int get hashCode => Object.hash(runtimeType,bossTarget,id,jokerTuning,playable,starThreshold,const DeepCollectionEquality().hash(_unlocks));

@override
String toString() {
  return 'WorldSummary(bossTarget: $bossTarget, id: $id, jokerTuning: $jokerTuning, playable: $playable, starThreshold: $starThreshold, unlocks: $unlocks)';
}


}

/// @nodoc
abstract mixin class _$WorldSummaryCopyWith<$Res> implements $WorldSummaryCopyWith<$Res> {
  factory _$WorldSummaryCopyWith(_WorldSummary value, $Res Function(_WorldSummary) _then) = __$WorldSummaryCopyWithImpl;
@override @useResult
$Res call({
 int bossTarget, WorldId id, JokerTuning jokerTuning, bool playable, int starThreshold, List<JokerId> unlocks
});


@override $JokerTuningCopyWith<$Res> get jokerTuning;

}
/// @nodoc
class __$WorldSummaryCopyWithImpl<$Res>
    implements _$WorldSummaryCopyWith<$Res> {
  __$WorldSummaryCopyWithImpl(this._self, this._then);

  final _WorldSummary _self;
  final $Res Function(_WorldSummary) _then;

/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bossTarget = null,Object? id = null,Object? jokerTuning = null,Object? playable = null,Object? starThreshold = null,Object? unlocks = null,}) {
  return _then(_WorldSummary(
bossTarget: null == bossTarget ? _self.bossTarget : bossTarget // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as WorldId,jokerTuning: null == jokerTuning ? _self.jokerTuning : jokerTuning // ignore: cast_nullable_to_non_nullable
as JokerTuning,playable: null == playable ? _self.playable : playable // ignore: cast_nullable_to_non_nullable
as bool,starThreshold: null == starThreshold ? _self.starThreshold : starThreshold // ignore: cast_nullable_to_non_nullable
as int,unlocks: null == unlocks ? _self._unlocks : unlocks // ignore: cast_nullable_to_non_nullable
as List<JokerId>,
  ));
}

/// Create a copy of WorldSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get jokerTuning {
  
  return $JokerTuningCopyWith<$Res>(_self.jokerTuning, (value) {
    return _then(_self.copyWith(jokerTuning: value));
  });
}
}

// dart format on
