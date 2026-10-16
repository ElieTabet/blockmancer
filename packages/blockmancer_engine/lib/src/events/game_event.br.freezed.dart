// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_event.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent()';
}


}

/// @nodoc
class $GameEventCopyWith<$Res>  {
$GameEventCopyWith(GameEvent _, $Res Function(GameEvent) __);
}


/// Adds pattern-matching-related methods to [GameEvent].
extension GameEventPatterns on GameEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JokerFired value)?  jokerFired,TResult Function( ScoreAdded value)?  scoreAdded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JokerFired() when jokerFired != null:
return jokerFired(_that);case ScoreAdded() when scoreAdded != null:
return scoreAdded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JokerFired value)  jokerFired,required TResult Function( ScoreAdded value)  scoreAdded,}){
final _that = this;
switch (_that) {
case JokerFired():
return jokerFired(_that);case ScoreAdded():
return scoreAdded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JokerFired value)?  jokerFired,TResult? Function( ScoreAdded value)?  scoreAdded,}){
final _that = this;
switch (_that) {
case JokerFired() when jokerFired != null:
return jokerFired(_that);case ScoreAdded() when scoreAdded != null:
return scoreAdded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( JokerDelta delta,  JokerId joker)?  jokerFired,TResult Function( int chips,  int mult,  int total)?  scoreAdded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JokerFired() when jokerFired != null:
return jokerFired(_that.delta,_that.joker);case ScoreAdded() when scoreAdded != null:
return scoreAdded(_that.chips,_that.mult,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( JokerDelta delta,  JokerId joker)  jokerFired,required TResult Function( int chips,  int mult,  int total)  scoreAdded,}) {final _that = this;
switch (_that) {
case JokerFired():
return jokerFired(_that.delta,_that.joker);case ScoreAdded():
return scoreAdded(_that.chips,_that.mult,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( JokerDelta delta,  JokerId joker)?  jokerFired,TResult? Function( int chips,  int mult,  int total)?  scoreAdded,}) {final _that = this;
switch (_that) {
case JokerFired() when jokerFired != null:
return jokerFired(_that.delta,_that.joker);case ScoreAdded() when scoreAdded != null:
return scoreAdded(_that.chips,_that.mult,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class JokerFired implements GameEvent {
  const JokerFired({required this.delta, required this.joker});
  

 final  JokerDelta delta;
 final  JokerId joker;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerFiredCopyWith<JokerFired> get copyWith => _$JokerFiredCopyWithImpl<JokerFired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerFired&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.joker, joker) || other.joker == joker));
}


@override
int get hashCode => Object.hash(runtimeType,delta,joker);

@override
String toString() {
  return 'GameEvent.jokerFired(delta: $delta, joker: $joker)';
}


}

/// @nodoc
abstract mixin class $JokerFiredCopyWith<$Res> implements $GameEventCopyWith<$Res> {
  factory $JokerFiredCopyWith(JokerFired value, $Res Function(JokerFired) _then) = _$JokerFiredCopyWithImpl;
@useResult
$Res call({
 JokerDelta delta, JokerId joker
});


$JokerDeltaCopyWith<$Res> get delta;

}
/// @nodoc
class _$JokerFiredCopyWithImpl<$Res>
    implements $JokerFiredCopyWith<$Res> {
  _$JokerFiredCopyWithImpl(this._self, this._then);

  final JokerFired _self;
  final $Res Function(JokerFired) _then;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? delta = null,Object? joker = null,}) {
  return _then(JokerFired(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as JokerDelta,joker: null == joker ? _self.joker : joker // ignore: cast_nullable_to_non_nullable
as JokerId,
  ));
}

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerDeltaCopyWith<$Res> get delta {
  
  return $JokerDeltaCopyWith<$Res>(_self.delta, (value) {
    return _then(_self.copyWith(delta: value));
  });
}
}

/// @nodoc


class ScoreAdded implements GameEvent {
  const ScoreAdded({required this.chips, required this.mult, required this.total});
  

 final  int chips;
 final  int mult;
 final  int total;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreAddedCopyWith<ScoreAdded> get copyWith => _$ScoreAddedCopyWithImpl<ScoreAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreAdded&&(identical(other.chips, chips) || other.chips == chips)&&(identical(other.mult, mult) || other.mult == mult)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,chips,mult,total);

@override
String toString() {
  return 'GameEvent.scoreAdded(chips: $chips, mult: $mult, total: $total)';
}


}

/// @nodoc
abstract mixin class $ScoreAddedCopyWith<$Res> implements $GameEventCopyWith<$Res> {
  factory $ScoreAddedCopyWith(ScoreAdded value, $Res Function(ScoreAdded) _then) = _$ScoreAddedCopyWithImpl;
@useResult
$Res call({
 int chips, int mult, int total
});




}
/// @nodoc
class _$ScoreAddedCopyWithImpl<$Res>
    implements $ScoreAddedCopyWith<$Res> {
  _$ScoreAddedCopyWithImpl(this._self, this._then);

  final ScoreAdded _self;
  final $Res Function(ScoreAdded) _then;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? chips = null,Object? mult = null,Object? total = null,}) {
  return _then(ScoreAdded(
chips: null == chips ? _self.chips : chips // ignore: cast_nullable_to_non_nullable
as int,mult: null == mult ? _self.mult : mult // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
