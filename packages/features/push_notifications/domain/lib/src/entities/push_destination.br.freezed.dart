// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_destination.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PushDestination {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushDestination);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PushDestination()';
}


}

/// @nodoc
class $PushDestinationCopyWith<$Res>  {
$PushDestinationCopyWith(PushDestination _, $Res Function(PushDestination) __);
}


/// Adds pattern-matching-related methods to [PushDestination].
extension PushDestinationPatterns on PushDestination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DailyRunPushDestination value)?  dailyRun,TResult Function( HomePushDestination value)?  home,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DailyRunPushDestination() when dailyRun != null:
return dailyRun(_that);case HomePushDestination() when home != null:
return home(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DailyRunPushDestination value)  dailyRun,required TResult Function( HomePushDestination value)  home,}){
final _that = this;
switch (_that) {
case DailyRunPushDestination():
return dailyRun(_that);case HomePushDestination():
return home(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DailyRunPushDestination value)?  dailyRun,TResult? Function( HomePushDestination value)?  home,}){
final _that = this;
switch (_that) {
case DailyRunPushDestination() when dailyRun != null:
return dailyRun(_that);case HomePushDestination() when home != null:
return home(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String messageId)?  dailyRun,TResult Function()?  home,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DailyRunPushDestination() when dailyRun != null:
return dailyRun(_that.messageId);case HomePushDestination() when home != null:
return home();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String messageId)  dailyRun,required TResult Function()  home,}) {final _that = this;
switch (_that) {
case DailyRunPushDestination():
return dailyRun(_that.messageId);case HomePushDestination():
return home();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String messageId)?  dailyRun,TResult? Function()?  home,}) {final _that = this;
switch (_that) {
case DailyRunPushDestination() when dailyRun != null:
return dailyRun(_that.messageId);case HomePushDestination() when home != null:
return home();case _:
  return null;

}
}

}

/// @nodoc


class DailyRunPushDestination implements PushDestination {
  const DailyRunPushDestination({required this.messageId});
  

 final  String messageId;

/// Create a copy of PushDestination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyRunPushDestinationCopyWith<DailyRunPushDestination> get copyWith => _$DailyRunPushDestinationCopyWithImpl<DailyRunPushDestination>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyRunPushDestination&&(identical(other.messageId, messageId) || other.messageId == messageId));
}


@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'PushDestination.dailyRun(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $DailyRunPushDestinationCopyWith<$Res> implements $PushDestinationCopyWith<$Res> {
  factory $DailyRunPushDestinationCopyWith(DailyRunPushDestination value, $Res Function(DailyRunPushDestination) _then) = _$DailyRunPushDestinationCopyWithImpl;
@useResult
$Res call({
 String messageId
});




}
/// @nodoc
class _$DailyRunPushDestinationCopyWithImpl<$Res>
    implements $DailyRunPushDestinationCopyWith<$Res> {
  _$DailyRunPushDestinationCopyWithImpl(this._self, this._then);

  final DailyRunPushDestination _self;
  final $Res Function(DailyRunPushDestination) _then;

/// Create a copy of PushDestination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(DailyRunPushDestination(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HomePushDestination implements PushDestination {
  const HomePushDestination();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomePushDestination);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PushDestination.home()';
}


}




// dart format on
