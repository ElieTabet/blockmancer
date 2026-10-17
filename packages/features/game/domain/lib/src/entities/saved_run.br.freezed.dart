// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_run.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedRun {

 GameMode get mode; RunState get run;
/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedRunCopyWith<SavedRun> get copyWith => _$SavedRunCopyWithImpl<SavedRun>(this as SavedRun, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedRun&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.run, run) || other.run == run));
}


@override
int get hashCode => Object.hash(runtimeType,mode,run);

@override
String toString() {
  return 'SavedRun(mode: $mode, run: $run)';
}


}

/// @nodoc
abstract mixin class $SavedRunCopyWith<$Res>  {
  factory $SavedRunCopyWith(SavedRun value, $Res Function(SavedRun) _then) = _$SavedRunCopyWithImpl;
@useResult
$Res call({
 GameMode mode, RunState run
});


$GameModeCopyWith<$Res> get mode;$RunStateCopyWith<$Res> get run;

}
/// @nodoc
class _$SavedRunCopyWithImpl<$Res>
    implements $SavedRunCopyWith<$Res> {
  _$SavedRunCopyWithImpl(this._self, this._then);

  final SavedRun _self;
  final $Res Function(SavedRun) _then;

/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? run = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunState,
  ));
}
/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameModeCopyWith<$Res> get mode {
  
  return $GameModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res> get run {
  
  return $RunStateCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedRun].
extension SavedRunPatterns on SavedRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedRun value)  $default,){
final _that = this;
switch (_that) {
case _SavedRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedRun value)?  $default,){
final _that = this;
switch (_that) {
case _SavedRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameMode mode,  RunState run)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedRun() when $default != null:
return $default(_that.mode,_that.run);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameMode mode,  RunState run)  $default,) {final _that = this;
switch (_that) {
case _SavedRun():
return $default(_that.mode,_that.run);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameMode mode,  RunState run)?  $default,) {final _that = this;
switch (_that) {
case _SavedRun() when $default != null:
return $default(_that.mode,_that.run);case _:
  return null;

}
}

}

/// @nodoc


class _SavedRun implements SavedRun {
  const _SavedRun({required this.mode, required this.run});
  

@override final  GameMode mode;
@override final  RunState run;

/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedRunCopyWith<_SavedRun> get copyWith => __$SavedRunCopyWithImpl<_SavedRun>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedRun&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.run, run) || other.run == run));
}


@override
int get hashCode => Object.hash(runtimeType,mode,run);

@override
String toString() {
  return 'SavedRun(mode: $mode, run: $run)';
}


}

/// @nodoc
abstract mixin class _$SavedRunCopyWith<$Res> implements $SavedRunCopyWith<$Res> {
  factory _$SavedRunCopyWith(_SavedRun value, $Res Function(_SavedRun) _then) = __$SavedRunCopyWithImpl;
@override @useResult
$Res call({
 GameMode mode, RunState run
});


@override $GameModeCopyWith<$Res> get mode;@override $RunStateCopyWith<$Res> get run;

}
/// @nodoc
class __$SavedRunCopyWithImpl<$Res>
    implements _$SavedRunCopyWith<$Res> {
  __$SavedRunCopyWithImpl(this._self, this._then);

  final _SavedRun _self;
  final $Res Function(_SavedRun) _then;

/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? run = null,}) {
  return _then(_SavedRun(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunState,
  ));
}

/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameModeCopyWith<$Res> get mode {
  
  return $GameModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of SavedRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunStateCopyWith<$Res> get run {
  
  return $RunStateCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}

// dart format on
