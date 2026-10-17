// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_mode.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameMode {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameMode()';
}


}

/// @nodoc
class $GameModeCopyWith<$Res>  {
$GameModeCopyWith(GameMode _, $Res Function(GameMode) __);
}


/// Adds pattern-matching-related methods to [GameMode].
extension GameModePatterns on GameMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DailyMode value)?  daily,TResult Function( PracticeMode value)?  practice,TResult Function( WorldMode value)?  world,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DailyMode() when daily != null:
return daily(_that);case PracticeMode() when practice != null:
return practice(_that);case WorldMode() when world != null:
return world(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DailyMode value)  daily,required TResult Function( PracticeMode value)  practice,required TResult Function( WorldMode value)  world,}){
final _that = this;
switch (_that) {
case DailyMode():
return daily(_that);case PracticeMode():
return practice(_that);case WorldMode():
return world(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DailyMode value)?  daily,TResult? Function( PracticeMode value)?  practice,TResult? Function( WorldMode value)?  world,}){
final _that = this;
switch (_that) {
case DailyMode() when daily != null:
return daily(_that);case PracticeMode() when practice != null:
return practice(_that);case WorldMode() when world != null:
return world(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int day)?  daily,TResult Function()?  practice,TResult Function( WorldId world)?  world,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DailyMode() when daily != null:
return daily(_that.day);case PracticeMode() when practice != null:
return practice();case WorldMode() when world != null:
return world(_that.world);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int day)  daily,required TResult Function()  practice,required TResult Function( WorldId world)  world,}) {final _that = this;
switch (_that) {
case DailyMode():
return daily(_that.day);case PracticeMode():
return practice();case WorldMode():
return world(_that.world);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int day)?  daily,TResult? Function()?  practice,TResult? Function( WorldId world)?  world,}) {final _that = this;
switch (_that) {
case DailyMode() when daily != null:
return daily(_that.day);case PracticeMode() when practice != null:
return practice();case WorldMode() when world != null:
return world(_that.world);case _:
  return null;

}
}

}

/// @nodoc


class DailyMode implements GameMode {
  const DailyMode({required this.day});
  

 final  int day;

/// Create a copy of GameMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyModeCopyWith<DailyMode> get copyWith => _$DailyModeCopyWithImpl<DailyMode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMode&&(identical(other.day, day) || other.day == day));
}


@override
int get hashCode => Object.hash(runtimeType,day);

@override
String toString() {
  return 'GameMode.daily(day: $day)';
}


}

/// @nodoc
abstract mixin class $DailyModeCopyWith<$Res> implements $GameModeCopyWith<$Res> {
  factory $DailyModeCopyWith(DailyMode value, $Res Function(DailyMode) _then) = _$DailyModeCopyWithImpl;
@useResult
$Res call({
 int day
});




}
/// @nodoc
class _$DailyModeCopyWithImpl<$Res>
    implements $DailyModeCopyWith<$Res> {
  _$DailyModeCopyWithImpl(this._self, this._then);

  final DailyMode _self;
  final $Res Function(DailyMode) _then;

/// Create a copy of GameMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? day = null,}) {
  return _then(DailyMode(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PracticeMode implements GameMode {
  const PracticeMode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameMode.practice()';
}


}




/// @nodoc


class WorldMode implements GameMode {
  const WorldMode({required this.world});
  

 final  WorldId world;

/// Create a copy of GameMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldModeCopyWith<WorldMode> get copyWith => _$WorldModeCopyWithImpl<WorldMode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldMode&&(identical(other.world, world) || other.world == world));
}


@override
int get hashCode => Object.hash(runtimeType,world);

@override
String toString() {
  return 'GameMode.world(world: $world)';
}


}

/// @nodoc
abstract mixin class $WorldModeCopyWith<$Res> implements $GameModeCopyWith<$Res> {
  factory $WorldModeCopyWith(WorldMode value, $Res Function(WorldMode) _then) = _$WorldModeCopyWithImpl;
@useResult
$Res call({
 WorldId world
});




}
/// @nodoc
class _$WorldModeCopyWithImpl<$Res>
    implements $WorldModeCopyWith<$Res> {
  _$WorldModeCopyWithImpl(this._self, this._then);

  final WorldMode _self;
  final $Res Function(WorldMode) _then;

/// Create a copy of GameMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? world = null,}) {
  return _then(WorldMode(
world: null == world ? _self.world : world // ignore: cast_nullable_to_non_nullable
as WorldId,
  ));
}


}

// dart format on
