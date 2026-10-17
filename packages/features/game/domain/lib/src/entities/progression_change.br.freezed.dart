// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progression_change.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressionChange {

/// The stars this run earned that the world had not awarded before.
 WorldStars get newStars;/// Every star the world has awarded, this run's included.
 WorldStars get stars; List<JokerId> get unlockedJokers; WorldId? get unlockedWorld;
/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionChangeCopyWith<ProgressionChange> get copyWith => _$ProgressionChangeCopyWithImpl<ProgressionChange>(this as ProgressionChange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressionChange&&(identical(other.newStars, newStars) || other.newStars == newStars)&&(identical(other.stars, stars) || other.stars == stars)&&const DeepCollectionEquality().equals(other.unlockedJokers, unlockedJokers)&&(identical(other.unlockedWorld, unlockedWorld) || other.unlockedWorld == unlockedWorld));
}


@override
int get hashCode => Object.hash(runtimeType,newStars,stars,const DeepCollectionEquality().hash(unlockedJokers),unlockedWorld);

@override
String toString() {
  return 'ProgressionChange(newStars: $newStars, stars: $stars, unlockedJokers: $unlockedJokers, unlockedWorld: $unlockedWorld)';
}


}

/// @nodoc
abstract mixin class $ProgressionChangeCopyWith<$Res>  {
  factory $ProgressionChangeCopyWith(ProgressionChange value, $Res Function(ProgressionChange) _then) = _$ProgressionChangeCopyWithImpl;
@useResult
$Res call({
 WorldStars newStars, WorldStars stars, List<JokerId> unlockedJokers, WorldId? unlockedWorld
});


$WorldStarsCopyWith<$Res> get newStars;$WorldStarsCopyWith<$Res> get stars;

}
/// @nodoc
class _$ProgressionChangeCopyWithImpl<$Res>
    implements $ProgressionChangeCopyWith<$Res> {
  _$ProgressionChangeCopyWithImpl(this._self, this._then);

  final ProgressionChange _self;
  final $Res Function(ProgressionChange) _then;

/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? newStars = null,Object? stars = null,Object? unlockedJokers = null,Object? unlockedWorld = freezed,}) {
  return _then(_self.copyWith(
newStars: null == newStars ? _self.newStars : newStars // ignore: cast_nullable_to_non_nullable
as WorldStars,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as WorldStars,unlockedJokers: null == unlockedJokers ? _self.unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,unlockedWorld: freezed == unlockedWorld ? _self.unlockedWorld : unlockedWorld // ignore: cast_nullable_to_non_nullable
as WorldId?,
  ));
}
/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<$Res> get newStars {
  
  return $WorldStarsCopyWith<$Res>(_self.newStars, (value) {
    return _then(_self.copyWith(newStars: value));
  });
}/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<$Res> get stars {
  
  return $WorldStarsCopyWith<$Res>(_self.stars, (value) {
    return _then(_self.copyWith(stars: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressionChange].
extension ProgressionChangePatterns on ProgressionChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressionChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressionChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressionChange value)  $default,){
final _that = this;
switch (_that) {
case _ProgressionChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressionChange value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressionChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WorldStars newStars,  WorldStars stars,  List<JokerId> unlockedJokers,  WorldId? unlockedWorld)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressionChange() when $default != null:
return $default(_that.newStars,_that.stars,_that.unlockedJokers,_that.unlockedWorld);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WorldStars newStars,  WorldStars stars,  List<JokerId> unlockedJokers,  WorldId? unlockedWorld)  $default,) {final _that = this;
switch (_that) {
case _ProgressionChange():
return $default(_that.newStars,_that.stars,_that.unlockedJokers,_that.unlockedWorld);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WorldStars newStars,  WorldStars stars,  List<JokerId> unlockedJokers,  WorldId? unlockedWorld)?  $default,) {final _that = this;
switch (_that) {
case _ProgressionChange() when $default != null:
return $default(_that.newStars,_that.stars,_that.unlockedJokers,_that.unlockedWorld);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressionChange extends ProgressionChange {
  const _ProgressionChange({required this.newStars, required this.stars, required final  List<JokerId> unlockedJokers, this.unlockedWorld}): _unlockedJokers = unlockedJokers,super._();
  

/// The stars this run earned that the world had not awarded before.
@override final  WorldStars newStars;
/// Every star the world has awarded, this run's included.
@override final  WorldStars stars;
 final  List<JokerId> _unlockedJokers;
@override List<JokerId> get unlockedJokers {
  if (_unlockedJokers is EqualUnmodifiableListView) return _unlockedJokers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unlockedJokers);
}

@override final  WorldId? unlockedWorld;

/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionChangeCopyWith<_ProgressionChange> get copyWith => __$ProgressionChangeCopyWithImpl<_ProgressionChange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressionChange&&(identical(other.newStars, newStars) || other.newStars == newStars)&&(identical(other.stars, stars) || other.stars == stars)&&const DeepCollectionEquality().equals(other._unlockedJokers, _unlockedJokers)&&(identical(other.unlockedWorld, unlockedWorld) || other.unlockedWorld == unlockedWorld));
}


@override
int get hashCode => Object.hash(runtimeType,newStars,stars,const DeepCollectionEquality().hash(_unlockedJokers),unlockedWorld);

@override
String toString() {
  return 'ProgressionChange(newStars: $newStars, stars: $stars, unlockedJokers: $unlockedJokers, unlockedWorld: $unlockedWorld)';
}


}

/// @nodoc
abstract mixin class _$ProgressionChangeCopyWith<$Res> implements $ProgressionChangeCopyWith<$Res> {
  factory _$ProgressionChangeCopyWith(_ProgressionChange value, $Res Function(_ProgressionChange) _then) = __$ProgressionChangeCopyWithImpl;
@override @useResult
$Res call({
 WorldStars newStars, WorldStars stars, List<JokerId> unlockedJokers, WorldId? unlockedWorld
});


@override $WorldStarsCopyWith<$Res> get newStars;@override $WorldStarsCopyWith<$Res> get stars;

}
/// @nodoc
class __$ProgressionChangeCopyWithImpl<$Res>
    implements _$ProgressionChangeCopyWith<$Res> {
  __$ProgressionChangeCopyWithImpl(this._self, this._then);

  final _ProgressionChange _self;
  final $Res Function(_ProgressionChange) _then;

/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newStars = null,Object? stars = null,Object? unlockedJokers = null,Object? unlockedWorld = freezed,}) {
  return _then(_ProgressionChange(
newStars: null == newStars ? _self.newStars : newStars // ignore: cast_nullable_to_non_nullable
as WorldStars,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as WorldStars,unlockedJokers: null == unlockedJokers ? _self._unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,unlockedWorld: freezed == unlockedWorld ? _self.unlockedWorld : unlockedWorld // ignore: cast_nullable_to_non_nullable
as WorldId?,
  ));
}

/// Create a copy of ProgressionChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldStarsCopyWith<$Res> get newStars {
  
  return $WorldStarsCopyWith<$Res>(_self.newStars, (value) {
    return _then(_self.copyWith(newStars: value));
  });
}/// Create a copy of ProgressionChange
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
