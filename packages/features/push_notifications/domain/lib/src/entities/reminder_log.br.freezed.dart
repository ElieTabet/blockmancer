// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_log.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannedReminder {

 DateTime get at; ReminderMessage get message; int get streak;
/// Create a copy of PlannedReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedReminderCopyWith<PlannedReminder> get copyWith => _$PlannedReminderCopyWithImpl<PlannedReminder>(this as PlannedReminder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedReminder&&(identical(other.at, at) || other.at == at)&&(identical(other.message, message) || other.message == message)&&(identical(other.streak, streak) || other.streak == streak));
}


@override
int get hashCode => Object.hash(runtimeType,at,message,streak);

@override
String toString() {
  return 'PlannedReminder(at: $at, message: $message, streak: $streak)';
}


}

/// @nodoc
abstract mixin class $PlannedReminderCopyWith<$Res>  {
  factory $PlannedReminderCopyWith(PlannedReminder value, $Res Function(PlannedReminder) _then) = _$PlannedReminderCopyWithImpl;
@useResult
$Res call({
 DateTime at, ReminderMessage message, int streak
});




}
/// @nodoc
class _$PlannedReminderCopyWithImpl<$Res>
    implements $PlannedReminderCopyWith<$Res> {
  _$PlannedReminderCopyWithImpl(this._self, this._then);

  final PlannedReminder _self;
  final $Res Function(PlannedReminder) _then;

/// Create a copy of PlannedReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? message = null,Object? streak = null,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ReminderMessage,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedReminder].
extension PlannedReminderPatterns on PlannedReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedReminder value)  $default,){
final _that = this;
switch (_that) {
case _PlannedReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedReminder value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  ReminderMessage message,  int streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedReminder() when $default != null:
return $default(_that.at,_that.message,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  ReminderMessage message,  int streak)  $default,) {final _that = this;
switch (_that) {
case _PlannedReminder():
return $default(_that.at,_that.message,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  ReminderMessage message,  int streak)?  $default,) {final _that = this;
switch (_that) {
case _PlannedReminder() when $default != null:
return $default(_that.at,_that.message,_that.streak);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedReminder implements PlannedReminder {
  const _PlannedReminder({required this.at, required this.message, this.streak = 0});
  

@override final  DateTime at;
@override final  ReminderMessage message;
@override@JsonKey() final  int streak;

/// Create a copy of PlannedReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedReminderCopyWith<_PlannedReminder> get copyWith => __$PlannedReminderCopyWithImpl<_PlannedReminder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedReminder&&(identical(other.at, at) || other.at == at)&&(identical(other.message, message) || other.message == message)&&(identical(other.streak, streak) || other.streak == streak));
}


@override
int get hashCode => Object.hash(runtimeType,at,message,streak);

@override
String toString() {
  return 'PlannedReminder(at: $at, message: $message, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$PlannedReminderCopyWith<$Res> implements $PlannedReminderCopyWith<$Res> {
  factory _$PlannedReminderCopyWith(_PlannedReminder value, $Res Function(_PlannedReminder) _then) = __$PlannedReminderCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, ReminderMessage message, int streak
});




}
/// @nodoc
class __$PlannedReminderCopyWithImpl<$Res>
    implements _$PlannedReminderCopyWith<$Res> {
  __$PlannedReminderCopyWithImpl(this._self, this._then);

  final _PlannedReminder _self;
  final $Res Function(_PlannedReminder) _then;

/// Create a copy of PlannedReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? message = null,Object? streak = null,}) {
  return _then(_PlannedReminder(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ReminderMessage,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReminderLog {

 List<PlannedReminder> get planned; List<ReminderMessage> get recent;
/// Create a copy of ReminderLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderLogCopyWith<ReminderLog> get copyWith => _$ReminderLogCopyWithImpl<ReminderLog>(this as ReminderLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderLog&&const DeepCollectionEquality().equals(other.planned, planned)&&const DeepCollectionEquality().equals(other.recent, recent));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(planned),const DeepCollectionEquality().hash(recent));

@override
String toString() {
  return 'ReminderLog(planned: $planned, recent: $recent)';
}


}

/// @nodoc
abstract mixin class $ReminderLogCopyWith<$Res>  {
  factory $ReminderLogCopyWith(ReminderLog value, $Res Function(ReminderLog) _then) = _$ReminderLogCopyWithImpl;
@useResult
$Res call({
 List<PlannedReminder> planned, List<ReminderMessage> recent
});




}
/// @nodoc
class _$ReminderLogCopyWithImpl<$Res>
    implements $ReminderLogCopyWith<$Res> {
  _$ReminderLogCopyWithImpl(this._self, this._then);

  final ReminderLog _self;
  final $Res Function(ReminderLog) _then;

/// Create a copy of ReminderLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planned = null,Object? recent = null,}) {
  return _then(_self.copyWith(
planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as List<PlannedReminder>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<ReminderMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderLog].
extension ReminderLogPatterns on ReminderLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderLog value)  $default,){
final _that = this;
switch (_that) {
case _ReminderLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderLog value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlannedReminder> planned,  List<ReminderMessage> recent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderLog() when $default != null:
return $default(_that.planned,_that.recent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlannedReminder> planned,  List<ReminderMessage> recent)  $default,) {final _that = this;
switch (_that) {
case _ReminderLog():
return $default(_that.planned,_that.recent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlannedReminder> planned,  List<ReminderMessage> recent)?  $default,) {final _that = this;
switch (_that) {
case _ReminderLog() when $default != null:
return $default(_that.planned,_that.recent);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderLog implements ReminderLog {
  const _ReminderLog({final  List<PlannedReminder> planned = const <PlannedReminder>[], final  List<ReminderMessage> recent = const <ReminderMessage>[]}): _planned = planned,_recent = recent;
  

 final  List<PlannedReminder> _planned;
@override@JsonKey() List<PlannedReminder> get planned {
  if (_planned is EqualUnmodifiableListView) return _planned;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_planned);
}

 final  List<ReminderMessage> _recent;
@override@JsonKey() List<ReminderMessage> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}


/// Create a copy of ReminderLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderLogCopyWith<_ReminderLog> get copyWith => __$ReminderLogCopyWithImpl<_ReminderLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderLog&&const DeepCollectionEquality().equals(other._planned, _planned)&&const DeepCollectionEquality().equals(other._recent, _recent));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_planned),const DeepCollectionEquality().hash(_recent));

@override
String toString() {
  return 'ReminderLog(planned: $planned, recent: $recent)';
}


}

/// @nodoc
abstract mixin class _$ReminderLogCopyWith<$Res> implements $ReminderLogCopyWith<$Res> {
  factory _$ReminderLogCopyWith(_ReminderLog value, $Res Function(_ReminderLog) _then) = __$ReminderLogCopyWithImpl;
@override @useResult
$Res call({
 List<PlannedReminder> planned, List<ReminderMessage> recent
});




}
/// @nodoc
class __$ReminderLogCopyWithImpl<$Res>
    implements _$ReminderLogCopyWith<$Res> {
  __$ReminderLogCopyWithImpl(this._self, this._then);

  final _ReminderLog _self;
  final $Res Function(_ReminderLog) _then;

/// Create a copy of ReminderLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planned = null,Object? recent = null,}) {
  return _then(_ReminderLog(
planned: null == planned ? _self._planned : planned // ignore: cast_nullable_to_non_nullable
as List<PlannedReminder>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<ReminderMessage>,
  ));
}


}

// dart format on
