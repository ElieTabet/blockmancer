// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_stars.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorldStars {

 bool get bossBeaten; bool get noRevive;/// A run total of at least the world's `RunConfig.starThreshold`.
 bool get scoreThreshold;
/// Create a copy of WorldStars
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<WorldStars> get copyWith => _$WorldStarsCopyWithImpl<WorldStars>(this as WorldStars, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldStars&&(identical(other.bossBeaten, bossBeaten) || other.bossBeaten == bossBeaten)&&(identical(other.noRevive, noRevive) || other.noRevive == noRevive)&&(identical(other.scoreThreshold, scoreThreshold) || other.scoreThreshold == scoreThreshold));
}


@override
int get hashCode => Object.hash(runtimeType,bossBeaten,noRevive,scoreThreshold);

@override
String toString() {
  return 'WorldStars(bossBeaten: $bossBeaten, noRevive: $noRevive, scoreThreshold: $scoreThreshold)';
}


}

/// @nodoc
abstract mixin class $WorldStarsCopyWith<$Res>  {
  factory $WorldStarsCopyWith(WorldStars value, $Res Function(WorldStars) _then) = _$WorldStarsCopyWithImpl;
@useResult
$Res call({
 bool bossBeaten, bool noRevive, bool scoreThreshold
});




}
/// @nodoc
class _$WorldStarsCopyWithImpl<$Res>
    implements $WorldStarsCopyWith<$Res> {
  _$WorldStarsCopyWithImpl(this._self, this._then);

  final WorldStars _self;
  final $Res Function(WorldStars) _then;

/// Create a copy of WorldStars
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bossBeaten = null,Object? noRevive = null,Object? scoreThreshold = null,}) {
  return _then(_self.copyWith(
bossBeaten: null == bossBeaten ? _self.bossBeaten : bossBeaten // ignore: cast_nullable_to_non_nullable
as bool,noRevive: null == noRevive ? _self.noRevive : noRevive // ignore: cast_nullable_to_non_nullable
as bool,scoreThreshold: null == scoreThreshold ? _self.scoreThreshold : scoreThreshold // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorldStars].
extension WorldStarsPatterns on WorldStars {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorldStars value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorldStars() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorldStars value)  $default,){
final _that = this;
switch (_that) {
case _WorldStars():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorldStars value)?  $default,){
final _that = this;
switch (_that) {
case _WorldStars() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool bossBeaten,  bool noRevive,  bool scoreThreshold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorldStars() when $default != null:
return $default(_that.bossBeaten,_that.noRevive,_that.scoreThreshold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool bossBeaten,  bool noRevive,  bool scoreThreshold)  $default,) {final _that = this;
switch (_that) {
case _WorldStars():
return $default(_that.bossBeaten,_that.noRevive,_that.scoreThreshold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool bossBeaten,  bool noRevive,  bool scoreThreshold)?  $default,) {final _that = this;
switch (_that) {
case _WorldStars() when $default != null:
return $default(_that.bossBeaten,_that.noRevive,_that.scoreThreshold);case _:
  return null;

}
}

}

/// @nodoc


class _WorldStars implements WorldStars {
  const _WorldStars({required this.bossBeaten, required this.noRevive, required this.scoreThreshold});
  

@override final  bool bossBeaten;
@override final  bool noRevive;
/// A run total of at least the world's `RunConfig.starThreshold`.
@override final  bool scoreThreshold;

/// Create a copy of WorldStars
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldStarsCopyWith<_WorldStars> get copyWith => __$WorldStarsCopyWithImpl<_WorldStars>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorldStars&&(identical(other.bossBeaten, bossBeaten) || other.bossBeaten == bossBeaten)&&(identical(other.noRevive, noRevive) || other.noRevive == noRevive)&&(identical(other.scoreThreshold, scoreThreshold) || other.scoreThreshold == scoreThreshold));
}


@override
int get hashCode => Object.hash(runtimeType,bossBeaten,noRevive,scoreThreshold);

@override
String toString() {
  return 'WorldStars(bossBeaten: $bossBeaten, noRevive: $noRevive, scoreThreshold: $scoreThreshold)';
}


}

/// @nodoc
abstract mixin class _$WorldStarsCopyWith<$Res> implements $WorldStarsCopyWith<$Res> {
  factory _$WorldStarsCopyWith(_WorldStars value, $Res Function(_WorldStars) _then) = __$WorldStarsCopyWithImpl;
@override @useResult
$Res call({
 bool bossBeaten, bool noRevive, bool scoreThreshold
});




}
/// @nodoc
class __$WorldStarsCopyWithImpl<$Res>
    implements _$WorldStarsCopyWith<$Res> {
  __$WorldStarsCopyWithImpl(this._self, this._then);

  final _WorldStars _self;
  final $Res Function(_WorldStars) _then;

/// Create a copy of WorldStars
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bossBeaten = null,Object? noRevive = null,Object? scoreThreshold = null,}) {
  return _then(_WorldStars(
bossBeaten: null == bossBeaten ? _self.bossBeaten : bossBeaten // ignore: cast_nullable_to_non_nullable
as bool,noRevive: null == noRevive ? _self.noRevive : noRevive // ignore: cast_nullable_to_non_nullable
as bool,scoreThreshold: null == scoreThreshold ? _self.scoreThreshold : scoreThreshold // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
