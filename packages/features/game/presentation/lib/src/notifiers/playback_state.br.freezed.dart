// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackState {

/// The beat playing; null once the move has played out.
 Beat? get beat;/// Whether a touch skips to the end yet.
 bool get canSkip;/// Whether the playback waits on its beat until a touch lets it go on.
 bool get held;/// The run before the move, which the run total and the streak show until
/// the move's points land; null shows the run's own.
 RunState? get heldRun;/// The round score shown until the move's points land in it; null shows
/// the run's own.
 int? get heldScore;/// Counts the beats played, so the same beat twice running still starts
/// its animation again.
 int get step;
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStateCopyWith<PlaybackState> get copyWith => _$PlaybackStateCopyWithImpl<PlaybackState>(this as PlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackState&&(identical(other.beat, beat) || other.beat == beat)&&(identical(other.canSkip, canSkip) || other.canSkip == canSkip)&&(identical(other.held, held) || other.held == held)&&(identical(other.heldRun, heldRun) || other.heldRun == heldRun)&&(identical(other.heldScore, heldScore) || other.heldScore == heldScore)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,beat,canSkip,held,heldRun,heldScore,step);

@override
String toString() {
  return 'PlaybackState(beat: $beat, canSkip: $canSkip, held: $held, heldRun: $heldRun, heldScore: $heldScore, step: $step)';
}


}

/// @nodoc
abstract mixin class $PlaybackStateCopyWith<$Res>  {
  factory $PlaybackStateCopyWith(PlaybackState value, $Res Function(PlaybackState) _then) = _$PlaybackStateCopyWithImpl;
@useResult
$Res call({
 Beat? beat, bool canSkip, bool held, RunState? heldRun, int? heldScore, int step
});


$BeatCopyWith<$Res>? get beat;$RunStateCopyWith<$Res>? get heldRun;

}
/// @nodoc
class _$PlaybackStateCopyWithImpl<$Res>
    implements $PlaybackStateCopyWith<$Res> {
  _$PlaybackStateCopyWithImpl(this._self, this._then);

  final PlaybackState _self;
  final $Res Function(PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beat = freezed,Object? canSkip = null,Object? held = null,Object? heldRun = freezed,Object? heldScore = freezed,Object? step = null,}) {
  return _then(_self.copyWith(
beat: freezed == beat ? _self.beat : beat // ignore: cast_nullable_to_non_nullable
as Beat?,canSkip: null == canSkip ? _self.canSkip : canSkip // ignore: cast_nullable_to_non_nullable
as bool,held: null == held ? _self.held : held // ignore: cast_nullable_to_non_nullable
as bool,heldRun: freezed == heldRun ? _self.heldRun : heldRun // ignore: cast_nullable_to_non_nullable
as RunState?,heldScore: freezed == heldScore ? _self.heldScore : heldScore // ignore: cast_nullable_to_non_nullable
as int?,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeatCopyWith<$Res>? get beat {
    if (_self.beat == null) {
    return null;
  }

  return $BeatCopyWith<$Res>(_self.beat!, (value) {
    return _then(_self.copyWith(beat: value));
  });
}/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res>? get heldRun {
    if (_self.heldRun == null) {
    return null;
  }

  return $RunStateCopyWith<$Res>(_self.heldRun!, (value) {
    return _then(_self.copyWith(heldRun: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlaybackState].
extension PlaybackStatePatterns on PlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Beat? beat,  bool canSkip,  bool held,  RunState? heldRun,  int? heldScore,  int step)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.beat,_that.canSkip,_that.held,_that.heldRun,_that.heldScore,_that.step);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Beat? beat,  bool canSkip,  bool held,  RunState? heldRun,  int? heldScore,  int step)  $default,) {final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that.beat,_that.canSkip,_that.held,_that.heldRun,_that.heldScore,_that.step);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Beat? beat,  bool canSkip,  bool held,  RunState? heldRun,  int? heldScore,  int step)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.beat,_that.canSkip,_that.held,_that.heldRun,_that.heldScore,_that.step);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackState extends PlaybackState {
  const _PlaybackState({this.beat, this.canSkip = false, this.held = false, this.heldRun, this.heldScore, this.step = 0}): super._();
  

/// The beat playing; null once the move has played out.
@override final  Beat? beat;
/// Whether a touch skips to the end yet.
@override@JsonKey() final  bool canSkip;
/// Whether the playback waits on its beat until a touch lets it go on.
@override@JsonKey() final  bool held;
/// The run before the move, which the run total and the streak show until
/// the move's points land; null shows the run's own.
@override final  RunState? heldRun;
/// The round score shown until the move's points land in it; null shows
/// the run's own.
@override final  int? heldScore;
/// Counts the beats played, so the same beat twice running still starts
/// its animation again.
@override@JsonKey() final  int step;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStateCopyWith<_PlaybackState> get copyWith => __$PlaybackStateCopyWithImpl<_PlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackState&&(identical(other.beat, beat) || other.beat == beat)&&(identical(other.canSkip, canSkip) || other.canSkip == canSkip)&&(identical(other.held, held) || other.held == held)&&(identical(other.heldRun, heldRun) || other.heldRun == heldRun)&&(identical(other.heldScore, heldScore) || other.heldScore == heldScore)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,beat,canSkip,held,heldRun,heldScore,step);

@override
String toString() {
  return 'PlaybackState(beat: $beat, canSkip: $canSkip, held: $held, heldRun: $heldRun, heldScore: $heldScore, step: $step)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStateCopyWith<$Res> implements $PlaybackStateCopyWith<$Res> {
  factory _$PlaybackStateCopyWith(_PlaybackState value, $Res Function(_PlaybackState) _then) = __$PlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 Beat? beat, bool canSkip, bool held, RunState? heldRun, int? heldScore, int step
});


@override $BeatCopyWith<$Res>? get beat;@override $RunStateCopyWith<$Res>? get heldRun;

}
/// @nodoc
class __$PlaybackStateCopyWithImpl<$Res>
    implements _$PlaybackStateCopyWith<$Res> {
  __$PlaybackStateCopyWithImpl(this._self, this._then);

  final _PlaybackState _self;
  final $Res Function(_PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beat = freezed,Object? canSkip = null,Object? held = null,Object? heldRun = freezed,Object? heldScore = freezed,Object? step = null,}) {
  return _then(_PlaybackState(
beat: freezed == beat ? _self.beat : beat // ignore: cast_nullable_to_non_nullable
as Beat?,canSkip: null == canSkip ? _self.canSkip : canSkip // ignore: cast_nullable_to_non_nullable
as bool,held: null == held ? _self.held : held // ignore: cast_nullable_to_non_nullable
as bool,heldRun: freezed == heldRun ? _self.heldRun : heldRun // ignore: cast_nullable_to_non_nullable
as RunState?,heldScore: freezed == heldScore ? _self.heldScore : heldScore // ignore: cast_nullable_to_non_nullable
as int?,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeatCopyWith<$Res>? get beat {
    if (_self.beat == null) {
    return null;
  }

  return $BeatCopyWith<$Res>(_self.beat!, (value) {
    return _then(_self.copyWith(beat: value));
  });
}/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res>? get heldRun {
    if (_self.heldRun == null) {
    return null;
  }

  return $RunStateCopyWith<$Res>(_self.heldRun!, (value) {
    return _then(_self.copyWith(heldRun: value));
  });
}
}

// dart format on
