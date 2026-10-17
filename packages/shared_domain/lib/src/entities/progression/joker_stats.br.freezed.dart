// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joker_stats.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokerStats {

/// The best run total of a finished run that owned it, boss beaten or
/// not.
 int get bestRunTotal;/// Runs won, the boss beaten, with it owned.
 int get runsWon;/// Every pick of it, the starting pick included, counted as it is made:
/// a run left before its end still counts.
 int get timesPicked;
/// Create a copy of JokerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerStatsCopyWith<JokerStats> get copyWith => _$JokerStatsCopyWithImpl<JokerStats>(this as JokerStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerStats&&(identical(other.bestRunTotal, bestRunTotal) || other.bestRunTotal == bestRunTotal)&&(identical(other.runsWon, runsWon) || other.runsWon == runsWon)&&(identical(other.timesPicked, timesPicked) || other.timesPicked == timesPicked));
}


@override
int get hashCode => Object.hash(runtimeType,bestRunTotal,runsWon,timesPicked);

@override
String toString() {
  return 'JokerStats(bestRunTotal: $bestRunTotal, runsWon: $runsWon, timesPicked: $timesPicked)';
}


}

/// @nodoc
abstract mixin class $JokerStatsCopyWith<$Res>  {
  factory $JokerStatsCopyWith(JokerStats value, $Res Function(JokerStats) _then) = _$JokerStatsCopyWithImpl;
@useResult
$Res call({
 int bestRunTotal, int runsWon, int timesPicked
});




}
/// @nodoc
class _$JokerStatsCopyWithImpl<$Res>
    implements $JokerStatsCopyWith<$Res> {
  _$JokerStatsCopyWithImpl(this._self, this._then);

  final JokerStats _self;
  final $Res Function(JokerStats) _then;

/// Create a copy of JokerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestRunTotal = null,Object? runsWon = null,Object? timesPicked = null,}) {
  return _then(_self.copyWith(
bestRunTotal: null == bestRunTotal ? _self.bestRunTotal : bestRunTotal // ignore: cast_nullable_to_non_nullable
as int,runsWon: null == runsWon ? _self.runsWon : runsWon // ignore: cast_nullable_to_non_nullable
as int,timesPicked: null == timesPicked ? _self.timesPicked : timesPicked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JokerStats].
extension JokerStatsPatterns on JokerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokerStats value)  $default,){
final _that = this;
switch (_that) {
case _JokerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokerStats value)?  $default,){
final _that = this;
switch (_that) {
case _JokerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bestRunTotal,  int runsWon,  int timesPicked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokerStats() when $default != null:
return $default(_that.bestRunTotal,_that.runsWon,_that.timesPicked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bestRunTotal,  int runsWon,  int timesPicked)  $default,) {final _that = this;
switch (_that) {
case _JokerStats():
return $default(_that.bestRunTotal,_that.runsWon,_that.timesPicked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bestRunTotal,  int runsWon,  int timesPicked)?  $default,) {final _that = this;
switch (_that) {
case _JokerStats() when $default != null:
return $default(_that.bestRunTotal,_that.runsWon,_that.timesPicked);case _:
  return null;

}
}

}

/// @nodoc


class _JokerStats implements JokerStats {
  const _JokerStats({required this.bestRunTotal, required this.runsWon, required this.timesPicked});
  

/// The best run total of a finished run that owned it, boss beaten or
/// not.
@override final  int bestRunTotal;
/// Runs won, the boss beaten, with it owned.
@override final  int runsWon;
/// Every pick of it, the starting pick included, counted as it is made:
/// a run left before its end still counts.
@override final  int timesPicked;

/// Create a copy of JokerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokerStatsCopyWith<_JokerStats> get copyWith => __$JokerStatsCopyWithImpl<_JokerStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokerStats&&(identical(other.bestRunTotal, bestRunTotal) || other.bestRunTotal == bestRunTotal)&&(identical(other.runsWon, runsWon) || other.runsWon == runsWon)&&(identical(other.timesPicked, timesPicked) || other.timesPicked == timesPicked));
}


@override
int get hashCode => Object.hash(runtimeType,bestRunTotal,runsWon,timesPicked);

@override
String toString() {
  return 'JokerStats(bestRunTotal: $bestRunTotal, runsWon: $runsWon, timesPicked: $timesPicked)';
}


}

/// @nodoc
abstract mixin class _$JokerStatsCopyWith<$Res> implements $JokerStatsCopyWith<$Res> {
  factory _$JokerStatsCopyWith(_JokerStats value, $Res Function(_JokerStats) _then) = __$JokerStatsCopyWithImpl;
@override @useResult
$Res call({
 int bestRunTotal, int runsWon, int timesPicked
});




}
/// @nodoc
class __$JokerStatsCopyWithImpl<$Res>
    implements _$JokerStatsCopyWith<$Res> {
  __$JokerStatsCopyWithImpl(this._self, this._then);

  final _JokerStats _self;
  final $Res Function(_JokerStats) _then;

/// Create a copy of JokerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestRunTotal = null,Object? runsWon = null,Object? timesPicked = null,}) {
  return _then(_JokerStats(
bestRunTotal: null == bestRunTotal ? _self.bestRunTotal : bestRunTotal // ignore: cast_nullable_to_non_nullable
as int,runsWon: null == runsWon ? _self.runsWon : runsWon // ignore: cast_nullable_to_non_nullable
as int,timesPicked: null == timesPicked ? _self.timesPicked : timesPicked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
