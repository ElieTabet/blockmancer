// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_error.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthError()';
}


}

/// @nodoc
class $AuthErrorCopyWith<$Res>  {
$AuthErrorCopyWith(AuthError _, $Res Function(AuthError) __);
}


/// Adds pattern-matching-related methods to [AuthError].
extension AuthErrorPatterns on AuthError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvalidCredentialsAuthError value)?  invalidCredentials,TResult Function( DeviceConflictAuthError value)?  deviceConflict,TResult Function( NoConnectionAuthError value)?  noConnection,TResult Function( UnexpectedAuthError value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvalidCredentialsAuthError() when invalidCredentials != null:
return invalidCredentials(_that);case DeviceConflictAuthError() when deviceConflict != null:
return deviceConflict(_that);case NoConnectionAuthError() when noConnection != null:
return noConnection(_that);case UnexpectedAuthError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvalidCredentialsAuthError value)  invalidCredentials,required TResult Function( DeviceConflictAuthError value)  deviceConflict,required TResult Function( NoConnectionAuthError value)  noConnection,required TResult Function( UnexpectedAuthError value)  unexpected,}){
final _that = this;
switch (_that) {
case InvalidCredentialsAuthError():
return invalidCredentials(_that);case DeviceConflictAuthError():
return deviceConflict(_that);case NoConnectionAuthError():
return noConnection(_that);case UnexpectedAuthError():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvalidCredentialsAuthError value)?  invalidCredentials,TResult? Function( DeviceConflictAuthError value)?  deviceConflict,TResult? Function( NoConnectionAuthError value)?  noConnection,TResult? Function( UnexpectedAuthError value)?  unexpected,}){
final _that = this;
switch (_that) {
case InvalidCredentialsAuthError() when invalidCredentials != null:
return invalidCredentials(_that);case DeviceConflictAuthError() when deviceConflict != null:
return deviceConflict(_that);case NoConnectionAuthError() when noConnection != null:
return noConnection(_that);case UnexpectedAuthError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  deviceConflict,TResult Function()?  noConnection,TResult Function()?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvalidCredentialsAuthError() when invalidCredentials != null:
return invalidCredentials();case DeviceConflictAuthError() when deviceConflict != null:
return deviceConflict();case NoConnectionAuthError() when noConnection != null:
return noConnection();case UnexpectedAuthError() when unexpected != null:
return unexpected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  deviceConflict,required TResult Function()  noConnection,required TResult Function()  unexpected,}) {final _that = this;
switch (_that) {
case InvalidCredentialsAuthError():
return invalidCredentials();case DeviceConflictAuthError():
return deviceConflict();case NoConnectionAuthError():
return noConnection();case UnexpectedAuthError():
return unexpected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  deviceConflict,TResult? Function()?  noConnection,TResult? Function()?  unexpected,}) {final _that = this;
switch (_that) {
case InvalidCredentialsAuthError() when invalidCredentials != null:
return invalidCredentials();case DeviceConflictAuthError() when deviceConflict != null:
return deviceConflict();case NoConnectionAuthError() when noConnection != null:
return noConnection();case UnexpectedAuthError() when unexpected != null:
return unexpected();case _:
  return null;

}
}

}

/// @nodoc


class InvalidCredentialsAuthError implements AuthError {
  const InvalidCredentialsAuthError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCredentialsAuthError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthError.invalidCredentials()';
}


}




/// @nodoc


class DeviceConflictAuthError implements AuthError {
  const DeviceConflictAuthError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConflictAuthError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthError.deviceConflict()';
}


}




/// @nodoc


class NoConnectionAuthError implements AuthError {
  const NoConnectionAuthError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoConnectionAuthError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthError.noConnection()';
}


}




/// @nodoc


class UnexpectedAuthError implements AuthError {
  const UnexpectedAuthError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedAuthError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthError.unexpected()';
}


}




// dart format on
