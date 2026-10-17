// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_progress.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorldProgress {

 bool get bossBeaten; WorldStars get stars; bool get unlocked;
/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldProgressCopyWith<WorldProgress> get copyWith => _$WorldProgressCopyWithImpl<WorldProgress>(this as WorldProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldProgress&&(identical(other.bossBeaten, bossBeaten) || other.bossBeaten == bossBeaten)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked));
}


@override
int get hashCode => Object.hash(runtimeType,bossBeaten,stars,unlocked);

@override
String toString() {
  return 'WorldProgress(bossBeaten: $bossBeaten, stars: $stars, unlocked: $unlocked)';
}


}

/// @nodoc
abstract mixin class $WorldProgressCopyWith<$Res>  {
  factory $WorldProgressCopyWith(WorldProgress value, $Res Function(WorldProgress) _then) = _$WorldProgressCopyWithImpl;
@useResult
$Res call({
 bool bossBeaten, WorldStars stars, bool unlocked
});


$WorldStarsCopyWith<$Res> get stars;

}
/// @nodoc
class _$WorldProgressCopyWithImpl<$Res>
    implements $WorldProgressCopyWith<$Res> {
  _$WorldProgressCopyWithImpl(this._self, this._then);

  final WorldProgress _self;
  final $Res Function(WorldProgress) _then;

/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bossBeaten = null,Object? stars = null,Object? unlocked = null,}) {
  return _then(_self.copyWith(
bossBeaten: null == bossBeaten ? _self.bossBeaten : bossBeaten // ignore: cast_nullable_to_non_nullable
as bool,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as WorldStars,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<$Res> get stars {
  
  return $WorldStarsCopyWith<$Res>(_self.stars, (value) {
    return _then(_self.copyWith(stars: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorldProgress].
extension WorldProgressPatterns on WorldProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorldProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorldProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorldProgress value)  $default,){
final _that = this;
switch (_that) {
case _WorldProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorldProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WorldProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool bossBeaten,  WorldStars stars,  bool unlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorldProgress() when $default != null:
return $default(_that.bossBeaten,_that.stars,_that.unlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool bossBeaten,  WorldStars stars,  bool unlocked)  $default,) {final _that = this;
switch (_that) {
case _WorldProgress():
return $default(_that.bossBeaten,_that.stars,_that.unlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool bossBeaten,  WorldStars stars,  bool unlocked)?  $default,) {final _that = this;
switch (_that) {
case _WorldProgress() when $default != null:
return $default(_that.bossBeaten,_that.stars,_that.unlocked);case _:
  return null;

}
}

}

/// @nodoc


class _WorldProgress implements WorldProgress {
  const _WorldProgress({required this.bossBeaten, required this.stars, required this.unlocked});
  

@override final  bool bossBeaten;
@override final  WorldStars stars;
@override final  bool unlocked;

/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldProgressCopyWith<_WorldProgress> get copyWith => __$WorldProgressCopyWithImpl<_WorldProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorldProgress&&(identical(other.bossBeaten, bossBeaten) || other.bossBeaten == bossBeaten)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked));
}


@override
int get hashCode => Object.hash(runtimeType,bossBeaten,stars,unlocked);

@override
String toString() {
  return 'WorldProgress(bossBeaten: $bossBeaten, stars: $stars, unlocked: $unlocked)';
}


}

/// @nodoc
abstract mixin class _$WorldProgressCopyWith<$Res> implements $WorldProgressCopyWith<$Res> {
  factory _$WorldProgressCopyWith(_WorldProgress value, $Res Function(_WorldProgress) _then) = __$WorldProgressCopyWithImpl;
@override @useResult
$Res call({
 bool bossBeaten, WorldStars stars, bool unlocked
});


@override $WorldStarsCopyWith<$Res> get stars;

}
/// @nodoc
class __$WorldProgressCopyWithImpl<$Res>
    implements _$WorldProgressCopyWith<$Res> {
  __$WorldProgressCopyWithImpl(this._self, this._then);

  final _WorldProgress _self;
  final $Res Function(_WorldProgress) _then;

/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bossBeaten = null,Object? stars = null,Object? unlocked = null,}) {
  return _then(_WorldProgress(
bossBeaten: null == bossBeaten ? _self.bossBeaten : bossBeaten // ignore: cast_nullable_to_non_nullable
as bool,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as WorldStars,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WorldProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<$Res> get stars {
  
  return $WorldStarsCopyWith<$Res>(_self.stars, (value) {
    return _then(_self.copyWith(stars: value));
  });
}
}

// dart format on
