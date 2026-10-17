// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_ui_state.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameUiState {

/// What the last action did, for the feedback that follows it.
 List<GameEvent> get lastEvents;/// Counts actions, so the same events twice still read as a new move.
/// What the run counts for: which best it is measured against.
 GameMode get mode; int get moveCount; RunState get run;/// The guided first run: never saved, and never measured against a best.
 bool get isTutorial;/// What the finished run earned on the map; null until the run has ended
/// and it is kept, and for good in a run that earns nothing there.
 ProgressionChange? get progress;/// The finished run against its mode's best; null until the run has ended
/// and the best has been read, and for good if it couldn't be.
 RunEndRecord? get record;/// Whether the player has been shown what the run unlocked.
 bool get unlocksSeen;
/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameUiStateCopyWith<GameUiState> get copyWith => _$GameUiStateCopyWithImpl<GameUiState>(this as GameUiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameUiState&&const DeepCollectionEquality().equals(other.lastEvents, lastEvents)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.run, run) || other.run == run)&&(identical(other.isTutorial, isTutorial) || other.isTutorial == isTutorial)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.record, record) || other.record == record)&&(identical(other.unlocksSeen, unlocksSeen) || other.unlocksSeen == unlocksSeen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lastEvents),mode,moveCount,run,isTutorial,progress,record,unlocksSeen);

@override
String toString() {
  return 'GameUiState(lastEvents: $lastEvents, mode: $mode, moveCount: $moveCount, run: $run, isTutorial: $isTutorial, progress: $progress, record: $record, unlocksSeen: $unlocksSeen)';
}


}

/// @nodoc
abstract mixin class $GameUiStateCopyWith<$Res>  {
  factory $GameUiStateCopyWith(GameUiState value, $Res Function(GameUiState) _then) = _$GameUiStateCopyWithImpl;
@useResult
$Res call({
 List<GameEvent> lastEvents, GameMode mode, int moveCount, RunState run, bool isTutorial, ProgressionChange? progress, RunEndRecord? record, bool unlocksSeen
});


$GameModeCopyWith<$Res> get mode;$RunStateCopyWith<$Res> get run;$ProgressionChangeCopyWith<$Res>? get progress;$RunEndRecordCopyWith<$Res>? get record;

}
/// @nodoc
class _$GameUiStateCopyWithImpl<$Res>
    implements $GameUiStateCopyWith<$Res> {
  _$GameUiStateCopyWithImpl(this._self, this._then);

  final GameUiState _self;
  final $Res Function(GameUiState) _then;

/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastEvents = null,Object? mode = null,Object? moveCount = null,Object? run = null,Object? isTutorial = null,Object? progress = freezed,Object? record = freezed,Object? unlocksSeen = null,}) {
  return _then(_self.copyWith(
lastEvents: null == lastEvents ? _self.lastEvents : lastEvents // ignore: cast_nullable_to_non_nullable
as List<GameEvent>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunState,isTutorial: null == isTutorial ? _self.isTutorial : isTutorial // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as ProgressionChange?,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as RunEndRecord?,unlocksSeen: null == unlocksSeen ? _self.unlocksSeen : unlocksSeen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameModeCopyWith<$Res> get mode {
  
  return $GameModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res> get run {
  
  return $RunStateCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressionChangeCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressionChangeCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunEndRecordCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $RunEndRecordCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameUiState].
extension GameUiStatePatterns on GameUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameUiState value)  $default,){
final _that = this;
switch (_that) {
case _GameUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameUiState value)?  $default,){
final _that = this;
switch (_that) {
case _GameUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GameEvent> lastEvents,  GameMode mode,  int moveCount,  RunState run,  bool isTutorial,  ProgressionChange? progress,  RunEndRecord? record,  bool unlocksSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameUiState() when $default != null:
return $default(_that.lastEvents,_that.mode,_that.moveCount,_that.run,_that.isTutorial,_that.progress,_that.record,_that.unlocksSeen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GameEvent> lastEvents,  GameMode mode,  int moveCount,  RunState run,  bool isTutorial,  ProgressionChange? progress,  RunEndRecord? record,  bool unlocksSeen)  $default,) {final _that = this;
switch (_that) {
case _GameUiState():
return $default(_that.lastEvents,_that.mode,_that.moveCount,_that.run,_that.isTutorial,_that.progress,_that.record,_that.unlocksSeen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GameEvent> lastEvents,  GameMode mode,  int moveCount,  RunState run,  bool isTutorial,  ProgressionChange? progress,  RunEndRecord? record,  bool unlocksSeen)?  $default,) {final _that = this;
switch (_that) {
case _GameUiState() when $default != null:
return $default(_that.lastEvents,_that.mode,_that.moveCount,_that.run,_that.isTutorial,_that.progress,_that.record,_that.unlocksSeen);case _:
  return null;

}
}

}

/// @nodoc


class _GameUiState implements GameUiState {
  const _GameUiState({required final  List<GameEvent> lastEvents, required this.mode, required this.moveCount, required this.run, this.isTutorial = false, this.progress, this.record, this.unlocksSeen = false}): _lastEvents = lastEvents;
  

/// What the last action did, for the feedback that follows it.
 final  List<GameEvent> _lastEvents;
/// What the last action did, for the feedback that follows it.
@override List<GameEvent> get lastEvents {
  if (_lastEvents is EqualUnmodifiableListView) return _lastEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastEvents);
}

/// Counts actions, so the same events twice still read as a new move.
/// What the run counts for: which best it is measured against.
@override final  GameMode mode;
@override final  int moveCount;
@override final  RunState run;
/// The guided first run: never saved, and never measured against a best.
@override@JsonKey() final  bool isTutorial;
/// What the finished run earned on the map; null until the run has ended
/// and it is kept, and for good in a run that earns nothing there.
@override final  ProgressionChange? progress;
/// The finished run against its mode's best; null until the run has ended
/// and the best has been read, and for good if it couldn't be.
@override final  RunEndRecord? record;
/// Whether the player has been shown what the run unlocked.
@override@JsonKey() final  bool unlocksSeen;

/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameUiStateCopyWith<_GameUiState> get copyWith => __$GameUiStateCopyWithImpl<_GameUiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameUiState&&const DeepCollectionEquality().equals(other._lastEvents, _lastEvents)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.run, run) || other.run == run)&&(identical(other.isTutorial, isTutorial) || other.isTutorial == isTutorial)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.record, record) || other.record == record)&&(identical(other.unlocksSeen, unlocksSeen) || other.unlocksSeen == unlocksSeen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lastEvents),mode,moveCount,run,isTutorial,progress,record,unlocksSeen);

@override
String toString() {
  return 'GameUiState(lastEvents: $lastEvents, mode: $mode, moveCount: $moveCount, run: $run, isTutorial: $isTutorial, progress: $progress, record: $record, unlocksSeen: $unlocksSeen)';
}


}

/// @nodoc
abstract mixin class _$GameUiStateCopyWith<$Res> implements $GameUiStateCopyWith<$Res> {
  factory _$GameUiStateCopyWith(_GameUiState value, $Res Function(_GameUiState) _then) = __$GameUiStateCopyWithImpl;
@override @useResult
$Res call({
 List<GameEvent> lastEvents, GameMode mode, int moveCount, RunState run, bool isTutorial, ProgressionChange? progress, RunEndRecord? record, bool unlocksSeen
});


@override $GameModeCopyWith<$Res> get mode;@override $RunStateCopyWith<$Res> get run;@override $ProgressionChangeCopyWith<$Res>? get progress;@override $RunEndRecordCopyWith<$Res>? get record;

}
/// @nodoc
class __$GameUiStateCopyWithImpl<$Res>
    implements _$GameUiStateCopyWith<$Res> {
  __$GameUiStateCopyWithImpl(this._self, this._then);

  final _GameUiState _self;
  final $Res Function(_GameUiState) _then;

/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastEvents = null,Object? mode = null,Object? moveCount = null,Object? run = null,Object? isTutorial = null,Object? progress = freezed,Object? record = freezed,Object? unlocksSeen = null,}) {
  return _then(_GameUiState(
lastEvents: null == lastEvents ? _self._lastEvents : lastEvents // ignore: cast_nullable_to_non_nullable
as List<GameEvent>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunState,isTutorial: null == isTutorial ? _self.isTutorial : isTutorial // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as ProgressionChange?,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as RunEndRecord?,unlocksSeen: null == unlocksSeen ? _self.unlocksSeen : unlocksSeen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameModeCopyWith<$Res> get mode {
  
  return $GameModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res> get run {
  
  return $RunStateCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressionChangeCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressionChangeCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of GameUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunEndRecordCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $RunEndRecordCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

// dart format on
