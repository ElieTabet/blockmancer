// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mastery_thresholds.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MasteryThresholds {

 int get bronze; int get gold; int get silver;
/// Create a copy of MasteryThresholds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MasteryThresholdsCopyWith<MasteryThresholds> get copyWith => _$MasteryThresholdsCopyWithImpl<MasteryThresholds>(this as MasteryThresholds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MasteryThresholds&&(identical(other.bronze, bronze) || other.bronze == bronze)&&(identical(other.gold, gold) || other.gold == gold)&&(identical(other.silver, silver) || other.silver == silver));
}


@override
int get hashCode => Object.hash(runtimeType,bronze,gold,silver);

@override
String toString() {
  return 'MasteryThresholds(bronze: $bronze, gold: $gold, silver: $silver)';
}


}

/// @nodoc
abstract mixin class $MasteryThresholdsCopyWith<$Res>  {
  factory $MasteryThresholdsCopyWith(MasteryThresholds value, $Res Function(MasteryThresholds) _then) = _$MasteryThresholdsCopyWithImpl;
@useResult
$Res call({
 int bronze, int gold, int silver
});




}
/// @nodoc
class _$MasteryThresholdsCopyWithImpl<$Res>
    implements $MasteryThresholdsCopyWith<$Res> {
  _$MasteryThresholdsCopyWithImpl(this._self, this._then);

  final MasteryThresholds _self;
  final $Res Function(MasteryThresholds) _then;

/// Create a copy of MasteryThresholds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bronze = null,Object? gold = null,Object? silver = null,}) {
  return _then(_self.copyWith(
bronze: null == bronze ? _self.bronze : bronze // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,silver: null == silver ? _self.silver : silver // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MasteryThresholds].
extension MasteryThresholdsPatterns on MasteryThresholds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MasteryThresholds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MasteryThresholds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MasteryThresholds value)  $default,){
final _that = this;
switch (_that) {
case _MasteryThresholds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MasteryThresholds value)?  $default,){
final _that = this;
switch (_that) {
case _MasteryThresholds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bronze,  int gold,  int silver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MasteryThresholds() when $default != null:
return $default(_that.bronze,_that.gold,_that.silver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bronze,  int gold,  int silver)  $default,) {final _that = this;
switch (_that) {
case _MasteryThresholds():
return $default(_that.bronze,_that.gold,_that.silver);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bronze,  int gold,  int silver)?  $default,) {final _that = this;
switch (_that) {
case _MasteryThresholds() when $default != null:
return $default(_that.bronze,_that.gold,_that.silver);case _:
  return null;

}
}

}

/// @nodoc


class _MasteryThresholds implements MasteryThresholds {
  const _MasteryThresholds({required this.bronze, required this.gold, required this.silver});
  

@override final  int bronze;
@override final  int gold;
@override final  int silver;

/// Create a copy of MasteryThresholds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MasteryThresholdsCopyWith<_MasteryThresholds> get copyWith => __$MasteryThresholdsCopyWithImpl<_MasteryThresholds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MasteryThresholds&&(identical(other.bronze, bronze) || other.bronze == bronze)&&(identical(other.gold, gold) || other.gold == gold)&&(identical(other.silver, silver) || other.silver == silver));
}


@override
int get hashCode => Object.hash(runtimeType,bronze,gold,silver);

@override
String toString() {
  return 'MasteryThresholds(bronze: $bronze, gold: $gold, silver: $silver)';
}


}

/// @nodoc
abstract mixin class _$MasteryThresholdsCopyWith<$Res> implements $MasteryThresholdsCopyWith<$Res> {
  factory _$MasteryThresholdsCopyWith(_MasteryThresholds value, $Res Function(_MasteryThresholds) _then) = __$MasteryThresholdsCopyWithImpl;
@override @useResult
$Res call({
 int bronze, int gold, int silver
});




}
/// @nodoc
class __$MasteryThresholdsCopyWithImpl<$Res>
    implements _$MasteryThresholdsCopyWith<$Res> {
  __$MasteryThresholdsCopyWithImpl(this._self, this._then);

  final _MasteryThresholds _self;
  final $Res Function(_MasteryThresholds) _then;

/// Create a copy of MasteryThresholds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bronze = null,Object? gold = null,Object? silver = null,}) {
  return _then(_MasteryThresholds(
bronze: null == bronze ? _self.bronze : bronze // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,silver: null == silver ? _self.silver : silver // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
