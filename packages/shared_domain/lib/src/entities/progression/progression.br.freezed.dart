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

/// Only the jokers ever picked.
 Map<JokerId, JokerStats> get jokerStats; bool get tutorialDone;/// Unlocked outside a run, when an older save was brought up to date, and
/// not shown yet: the map announces them on the player's next visit.
 Set<JokerId> get unannouncedJokers; Set<JokerId> get unlockedJokers; Map<WorldId, WorldProgress> get worlds;/// The worlds whose boss card has been shown, so it shows only the first
/// time the player reaches that boss.
 Set<WorldId> get bossCardsSeen;
/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionCopyWith<Progression> get copyWith => _$ProgressionCopyWithImpl<Progression>(this as Progression, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Progression&&const DeepCollectionEquality().equals(other.jokerStats, jokerStats)&&(identical(other.tutorialDone, tutorialDone) || other.tutorialDone == tutorialDone)&&const DeepCollectionEquality().equals(other.unannouncedJokers, unannouncedJokers)&&const DeepCollectionEquality().equals(other.unlockedJokers, unlockedJokers)&&const DeepCollectionEquality().equals(other.worlds, worlds)&&const DeepCollectionEquality().equals(other.bossCardsSeen, bossCardsSeen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jokerStats),tutorialDone,const DeepCollectionEquality().hash(unannouncedJokers),const DeepCollectionEquality().hash(unlockedJokers),const DeepCollectionEquality().hash(worlds),const DeepCollectionEquality().hash(bossCardsSeen));

@override
String toString() {
  return 'Progression(jokerStats: $jokerStats, tutorialDone: $tutorialDone, unannouncedJokers: $unannouncedJokers, unlockedJokers: $unlockedJokers, worlds: $worlds, bossCardsSeen: $bossCardsSeen)';
}


}

/// @nodoc
abstract mixin class $ProgressionCopyWith<$Res>  {
  factory $ProgressionCopyWith(Progression value, $Res Function(Progression) _then) = _$ProgressionCopyWithImpl;
@useResult
$Res call({
 Map<JokerId, JokerStats> jokerStats, bool tutorialDone, Set<JokerId> unannouncedJokers, Set<JokerId> unlockedJokers, Map<WorldId, WorldProgress> worlds, Set<WorldId> bossCardsSeen
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
@pragma('vm:prefer-inline') @override $Res call({Object? jokerStats = null,Object? tutorialDone = null,Object? unannouncedJokers = null,Object? unlockedJokers = null,Object? worlds = null,Object? bossCardsSeen = null,}) {
  return _then(_self.copyWith(
jokerStats: null == jokerStats ? _self.jokerStats : jokerStats // ignore: cast_nullable_to_non_nullable
as Map<JokerId, JokerStats>,tutorialDone: null == tutorialDone ? _self.tutorialDone : tutorialDone // ignore: cast_nullable_to_non_nullable
as bool,unannouncedJokers: null == unannouncedJokers ? _self.unannouncedJokers : unannouncedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,unlockedJokers: null == unlockedJokers ? _self.unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,worlds: null == worlds ? _self.worlds : worlds // ignore: cast_nullable_to_non_nullable
as Map<WorldId, WorldProgress>,bossCardsSeen: null == bossCardsSeen ? _self.bossCardsSeen : bossCardsSeen // ignore: cast_nullable_to_non_nullable
as Set<WorldId>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<JokerId, JokerStats> jokerStats,  bool tutorialDone,  Set<JokerId> unannouncedJokers,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds,  Set<WorldId> bossCardsSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Progression() when $default != null:
return $default(_that.jokerStats,_that.tutorialDone,_that.unannouncedJokers,_that.unlockedJokers,_that.worlds,_that.bossCardsSeen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<JokerId, JokerStats> jokerStats,  bool tutorialDone,  Set<JokerId> unannouncedJokers,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds,  Set<WorldId> bossCardsSeen)  $default,) {final _that = this;
switch (_that) {
case _Progression():
return $default(_that.jokerStats,_that.tutorialDone,_that.unannouncedJokers,_that.unlockedJokers,_that.worlds,_that.bossCardsSeen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<JokerId, JokerStats> jokerStats,  bool tutorialDone,  Set<JokerId> unannouncedJokers,  Set<JokerId> unlockedJokers,  Map<WorldId, WorldProgress> worlds,  Set<WorldId> bossCardsSeen)?  $default,) {final _that = this;
switch (_that) {
case _Progression() when $default != null:
return $default(_that.jokerStats,_that.tutorialDone,_that.unannouncedJokers,_that.unlockedJokers,_that.worlds,_that.bossCardsSeen);case _:
  return null;

}
}

}

/// @nodoc


class _Progression implements Progression {
  const _Progression({required final  Map<JokerId, JokerStats> jokerStats, required this.tutorialDone, required final  Set<JokerId> unannouncedJokers, required final  Set<JokerId> unlockedJokers, required final  Map<WorldId, WorldProgress> worlds, final  Set<WorldId> bossCardsSeen = const <WorldId>{}}): _jokerStats = jokerStats,_unannouncedJokers = unannouncedJokers,_unlockedJokers = unlockedJokers,_worlds = worlds,_bossCardsSeen = bossCardsSeen;
  

/// Only the jokers ever picked.
 final  Map<JokerId, JokerStats> _jokerStats;
/// Only the jokers ever picked.
@override Map<JokerId, JokerStats> get jokerStats {
  if (_jokerStats is EqualUnmodifiableMapView) return _jokerStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_jokerStats);
}

@override final  bool tutorialDone;
/// Unlocked outside a run, when an older save was brought up to date, and
/// not shown yet: the map announces them on the player's next visit.
 final  Set<JokerId> _unannouncedJokers;
/// Unlocked outside a run, when an older save was brought up to date, and
/// not shown yet: the map announces them on the player's next visit.
@override Set<JokerId> get unannouncedJokers {
  if (_unannouncedJokers is EqualUnmodifiableSetView) return _unannouncedJokers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unannouncedJokers);
}

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

/// The worlds whose boss card has been shown, so it shows only the first
/// time the player reaches that boss.
 final  Set<WorldId> _bossCardsSeen;
/// The worlds whose boss card has been shown, so it shows only the first
/// time the player reaches that boss.
@override@JsonKey() Set<WorldId> get bossCardsSeen {
  if (_bossCardsSeen is EqualUnmodifiableSetView) return _bossCardsSeen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_bossCardsSeen);
}


/// Create a copy of Progression
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionCopyWith<_Progression> get copyWith => __$ProgressionCopyWithImpl<_Progression>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Progression&&const DeepCollectionEquality().equals(other._jokerStats, _jokerStats)&&(identical(other.tutorialDone, tutorialDone) || other.tutorialDone == tutorialDone)&&const DeepCollectionEquality().equals(other._unannouncedJokers, _unannouncedJokers)&&const DeepCollectionEquality().equals(other._unlockedJokers, _unlockedJokers)&&const DeepCollectionEquality().equals(other._worlds, _worlds)&&const DeepCollectionEquality().equals(other._bossCardsSeen, _bossCardsSeen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jokerStats),tutorialDone,const DeepCollectionEquality().hash(_unannouncedJokers),const DeepCollectionEquality().hash(_unlockedJokers),const DeepCollectionEquality().hash(_worlds),const DeepCollectionEquality().hash(_bossCardsSeen));

@override
String toString() {
  return 'Progression(jokerStats: $jokerStats, tutorialDone: $tutorialDone, unannouncedJokers: $unannouncedJokers, unlockedJokers: $unlockedJokers, worlds: $worlds, bossCardsSeen: $bossCardsSeen)';
}


}

/// @nodoc
abstract mixin class _$ProgressionCopyWith<$Res> implements $ProgressionCopyWith<$Res> {
  factory _$ProgressionCopyWith(_Progression value, $Res Function(_Progression) _then) = __$ProgressionCopyWithImpl;
@override @useResult
$Res call({
 Map<JokerId, JokerStats> jokerStats, bool tutorialDone, Set<JokerId> unannouncedJokers, Set<JokerId> unlockedJokers, Map<WorldId, WorldProgress> worlds, Set<WorldId> bossCardsSeen
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
@override @pragma('vm:prefer-inline') $Res call({Object? jokerStats = null,Object? tutorialDone = null,Object? unannouncedJokers = null,Object? unlockedJokers = null,Object? worlds = null,Object? bossCardsSeen = null,}) {
  return _then(_Progression(
jokerStats: null == jokerStats ? _self._jokerStats : jokerStats // ignore: cast_nullable_to_non_nullable
as Map<JokerId, JokerStats>,tutorialDone: null == tutorialDone ? _self.tutorialDone : tutorialDone // ignore: cast_nullable_to_non_nullable
as bool,unannouncedJokers: null == unannouncedJokers ? _self._unannouncedJokers : unannouncedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,unlockedJokers: null == unlockedJokers ? _self._unlockedJokers : unlockedJokers // ignore: cast_nullable_to_non_nullable
as Set<JokerId>,worlds: null == worlds ? _self._worlds : worlds // ignore: cast_nullable_to_non_nullable
as Map<WorldId, WorldProgress>,bossCardsSeen: null == bossCardsSeen ? _self._bossCardsSeen : bossCardsSeen // ignore: cast_nullable_to_non_nullable
as Set<WorldId>,
  ));
}


}

// dart format on
