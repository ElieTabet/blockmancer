// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progression.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Progression {

 bool get tutorialDone; Set<JokerId> get unlockedJokers; Map<WorldId, WorldProgress> get worlds;
/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionCopyWith<Progression> get copyWith => _$ProgressionCopyWithImpl<Progression>(this as Progression, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Progression&&(identical(other.tutorialDone, tutorialDone) || other.tutorialDone == tutorialDone)&&const DeepCollectionEquality().equals(other.unlockedJokers, unlockedJokers)&&const DeepCollectionEquality().equals(other.worlds, worlds));
}


@override
int get hashCode => Object.hash(runtimeType,tutorialDone,const DeepCollectionEquality().hash(unlockedJokers),const DeepCollectionEquality().hash(worlds));

@override
String toString() {
  return 'Progression(tutorialDone: $tutorialDone, unlockedJokers: $unlockedJokers, worlds: $worlds)';
}


}

/// @nodoc
abstract mixin class $ProgressionCopyWith<$Res>  {
  factory $ProgressionCopyWith(Progression value, $Res Function(Progression) _then) = _$ProgressionCopyWithImpl;
@useResult
$Res call({
 bool tutorialDone, Set<JokerId> unlockedJokers, Map<WorldId, WorldProgress> worlds
});




}
/// @nodoc
class _$ProgressionCopyWithImpl<$Res>
    implements $ProgressionCopyWith<$Res> {
  _$ProgressionCopyWithImpl(this._self, this._then);

  final Progression _self;
  final $Res Function(Progression) _then;

/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tutorialDone = null,Object? unlockedJokers = null,Object? worlds = null,}) {
  return _then(_self.copyWith(
tutorialDone: null == tutorialDone ? _self.tutorialDone : tutorialDone // ignore: cast_nullable_to_non_nullable
as bool,unlockedJokers: null == unlockedJokers ? _self.unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,worlds: null == worlds ? _self.worlds : worlds // ignore: cast_nullable_to_non_nullable
as Map<WorldId, WorldProgress>,
  ));
}

}


/// Adds pattern-matching-related methods to [Progression].
extension ProgressionPatterns on Progression {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Progression value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Progression() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Progression value)  $default,){
final _that = this;
switch (_that) {
case _Progression():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Progression value)?  $default,){
final _that = this;
switch (_that) {
case _Progression() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool tutorialDone,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Progression() when $default != null:
return $default(_that.tutorialDone,_that.unlockedJokers,_that.worlds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool tutorialDone,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds)  $default,) {final _that = this;
switch (_that) {
case _Progression():
return $default(_that.tutorialDone,_that.unlockedJokers,_that.worlds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool tutorialDone,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds)?  $default,) {final _that = this;
switch (_that) {
case _Progression() when $default != null:
return $default(_that.tutorialDone,_that.unlockedJokers,_that.worlds);case _:
  return null;

}
}

}

/// @nodoc


class _Progression implements Progression {
  const _Progression({required this.tutorialDone, required final  Set<JokerId> unlockedJokers, required final  Map<WorldId, WorldProgress> worlds}): _unlockedJokers = unlockedJokers,_worlds = worlds;
  

@override final  bool tutorialDone;
 final  Set<JokerId> _unlockedJokers;
@override Set<JokerId> get unlockedJokers {
  if (_unlockedJokers is EqualUnmodifiableSetView) return _unlockedJokers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unlockedJokers);
}

 final  Map<WorldId, WorldProgress> _worlds;
@override Map<WorldId, WorldProgress> get worlds {
  if (_worlds is EqualUnmodifiableMapView) return _worlds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_worlds);
}


/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionCopyWith<_Progression> get copyWith => __$ProgressionCopyWithImpl<_Progression>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Progression&&(identical(other.tutorialDone, tutorialDone) || other.tutorialDone == tutorialDone)&&const DeepCollectionEquality().equals(other._unlockedJokers, _unlockedJokers)&&const DeepCollectionEquality().equals(other._worlds, _worlds));
}


@override
int get hashCode => Object.hash(runtimeType,tutorialDone,const DeepCollectionEquality().hash(_unlockedJokers),const DeepCollectionEquality().hash(_worlds));

@override
String toString() {
  return 'Progression(tutorialDone: $tutorialDone, unlockedJokers: $unlockedJokers, worlds: $worlds)';
}


}

/// @nodoc
abstract mixin class _$ProgressionCopyWith<$Res> implements $ProgressionCopyWith<$Res> {
  factory _$ProgressionCopyWith(_Progression value, $Res Function(_Progression) _then) = __$ProgressionCopyWithImpl;
@override @useResult
$Res call({
 bool tutorialDone, Set<JokerId> unlockedJokers, Map<WorldId, WorldProgress> worlds
});




}
/// @nodoc
class __$ProgressionCopyWithImpl<$Res>
    implements _$ProgressionCopyWith<$Res> {
  __$ProgressionCopyWithImpl(this._self, this._then);

  final _Progression _self;
  final $Res Function(_Progression) _then;

/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tutorialDone = null,Object? unlockedJokers = null,Object? worlds = null,}) {
  return _then(_Progression(
tutorialDone: null == tutorialDone ? _self.tutorialDone : tutorialDone // ignore: cast_nullable_to_non_nullable
as bool,unlockedJokers: null == unlockedJokers ? _self._unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,worlds: null == worlds ? _self._worlds : worlds // ignore: cast_nullable_to_non_nullable
as Map<WorldId, WorldProgress>,
  ));
}


}

// dart format on
