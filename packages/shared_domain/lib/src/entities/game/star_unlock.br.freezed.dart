// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'star_unlock.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StarUnlock {

 List<JokerId> get jokers; int get stars;
/// Create a copy of StarUnlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarUnlockCopyWith<StarUnlock> get copyWith => _$StarUnlockCopyWithImpl<StarUnlock>(this as StarUnlock, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarUnlock&&const DeepCollectionEquality().equals(other.jokers, jokers)&&(identical(other.stars, stars) || other.stars == stars));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jokers),stars);

@override
String toString() {
  return 'StarUnlock(jokers: $jokers, stars: $stars)';
}


}

/// @nodoc
abstract mixin class $StarUnlockCopyWith<$Res>  {
  factory $StarUnlockCopyWith(StarUnlock value, $Res Function(StarUnlock) _then) = _$StarUnlockCopyWithImpl;
@useResult
$Res call({
 List<JokerId> jokers, int stars
});




}
/// @nodoc
class _$StarUnlockCopyWithImpl<$Res>
    implements $StarUnlockCopyWith<$Res> {
  _$StarUnlockCopyWithImpl(this._self, this._then);

  final StarUnlock _self;
  final $Res Function(StarUnlock) _then;

/// Create a copy of StarUnlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jokers = null,Object? stars = null,}) {
  return _then(_self.copyWith(
jokers: null == jokers ? _self.jokers : jokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StarUnlock].
extension StarUnlockPatterns on StarUnlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StarUnlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StarUnlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StarUnlock value)  $default,){
final _that = this;
switch (_that) {
case _StarUnlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StarUnlock value)?  $default,){
final _that = this;
switch (_that) {
case _StarUnlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<JokerId> jokers,  int stars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarUnlock() when $default != null:
return $default(_that.jokers,_that.stars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<JokerId> jokers,  int stars)  $default,) {final _that = this;
switch (_that) {
case _StarUnlock():
return $default(_that.jokers,_that.stars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<JokerId> jokers,  int stars)?  $default,) {final _that = this;
switch (_that) {
case _StarUnlock() when $default != null:
return $default(_that.jokers,_that.stars);case _:
  return null;

}
}

}

/// @nodoc


class _StarUnlock implements StarUnlock {
  const _StarUnlock({required final  List<JokerId> jokers, required this.stars}): _jokers = jokers;
  

 final  List<JokerId> _jokers;
@override List<JokerId> get jokers {
  if (_jokers is EqualUnmodifiableListView) return _jokers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jokers);
}

@override final  int stars;

/// Create a copy of StarUnlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarUnlockCopyWith<_StarUnlock> get copyWith => __$StarUnlockCopyWithImpl<_StarUnlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarUnlock&&const DeepCollectionEquality().equals(other._jokers, _jokers)&&(identical(other.stars, stars) || other.stars == stars));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jokers),stars);

@override
String toString() {
  return 'StarUnlock(jokers: $jokers, stars: $stars)';
}


}

/// @nodoc
abstract mixin class _$StarUnlockCopyWith<$Res> implements $StarUnlockCopyWith<$Res> {
  factory _$StarUnlockCopyWith(_StarUnlock value, $Res Function(_StarUnlock) _then) = __$StarUnlockCopyWithImpl;
@override @useResult
$Res call({
 List<JokerId> jokers, int stars
});




}
/// @nodoc
class __$StarUnlockCopyWithImpl<$Res>
    implements _$StarUnlockCopyWith<$Res> {
  __$StarUnlockCopyWithImpl(this._self, this._then);

  final _StarUnlock _self;
  final $Res Function(_StarUnlock) _then;

/// Create a copy of StarUnlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jokers = null,Object? stars = null,}) {
  return _then(_StarUnlock(
jokers: null == jokers ? _self._jokers : jokers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
