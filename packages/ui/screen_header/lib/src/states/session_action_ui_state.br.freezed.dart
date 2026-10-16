// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_action_ui_state.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionActionUiState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionActionUiState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionActionUiState()';
}


}

/// @nodoc
class $SessionActionUiStateCopyWith<$Res>  {
$SessionActionUiStateCopyWith(SessionActionUiState _, $Res Function(SessionActionUiState) __);
}


/// Adds pattern-matching-related methods to [SessionActionUiState].
extension SessionActionUiStatePatterns on SessionActionUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( IdleSessionActionUiState value)?  idle,TResult Function( SigningOutSessionActionUiState value)?  signingOut,TResult Function( FailedSessionActionUiState value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case IdleSessionActionUiState() when idle != null:
return idle(_that);case SigningOutSessionActionUiState() when signingOut != null:
return signingOut(_that);case FailedSessionActionUiState() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( IdleSessionActionUiState value)  idle,required TResult Function( SigningOutSessionActionUiState value)  signingOut,required TResult Function( FailedSessionActionUiState value)  failed,}){
final _that = this;
switch (_that) {
case IdleSessionActionUiState():
return idle(_that);case SigningOutSessionActionUiState():
return signingOut(_that);case FailedSessionActionUiState():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( IdleSessionActionUiState value)?  idle,TResult? Function( SigningOutSessionActionUiState value)?  signingOut,TResult? Function( FailedSessionActionUiState value)?  failed,}){
final _that = this;
switch (_that) {
case IdleSessionActionUiState() when idle != null:
return idle(_that);case SigningOutSessionActionUiState() when signingOut != null:
return signingOut(_that);case FailedSessionActionUiState() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  signingOut,TResult Function( AuthError error)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case IdleSessionActionUiState() when idle != null:
return idle();case SigningOutSessionActionUiState() when signingOut != null:
return signingOut();case FailedSessionActionUiState() when failed != null:
return failed(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  signingOut,required TResult Function( AuthError error)  failed,}) {final _that = this;
switch (_that) {
case IdleSessionActionUiState():
return idle();case SigningOutSessionActionUiState():
return signingOut();case FailedSessionActionUiState():
return failed(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  signingOut,TResult? Function( AuthError error)?  failed,}) {final _that = this;
switch (_that) {
case IdleSessionActionUiState() when idle != null:
return idle();case SigningOutSessionActionUiState() when signingOut != null:
return signingOut();case FailedSessionActionUiState() when failed != null:
return failed(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class IdleSessionActionUiState implements SessionActionUiState {
  const IdleSessionActionUiState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdleSessionActionUiState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionActionUiState.idle()';
}


}




/// @nodoc


class SigningOutSessionActionUiState implements SessionActionUiState {
  const SigningOutSessionActionUiState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SigningOutSessionActionUiState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionActionUiState.signingOut()';
}


}




/// @nodoc


class FailedSessionActionUiState implements SessionActionUiState {
  const FailedSessionActionUiState(this.error);
  

 final  AuthError error;

/// Create a copy of SessionActionUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailedSessionActionUiStateCopyWith<FailedSessionActionUiState> get copyWith => _$FailedSessionActionUiStateCopyWithImpl<FailedSessionActionUiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailedSessionActionUiState&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'SessionActionUiState.failed(error: $error)';
}


}

/// @nodoc
abstract mixin class $FailedSessionActionUiStateCopyWith<$Res> implements $SessionActionUiStateCopyWith<$Res> {
  factory $FailedSessionActionUiStateCopyWith(FailedSessionActionUiState value, $Res Function(FailedSessionActionUiState) _then) = _$FailedSessionActionUiStateCopyWithImpl;
@useResult
$Res call({
 AuthError error
});


$AuthErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$FailedSessionActionUiStateCopyWithImpl<$Res>
    implements $FailedSessionActionUiStateCopyWith<$Res> {
  _$FailedSessionActionUiStateCopyWithImpl(this._self, this._then);

  final FailedSessionActionUiState _self;
  final $Res Function(FailedSessionActionUiState) _then;

/// Create a copy of SessionActionUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(FailedSessionActionUiState(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AuthError,
  ));
}

/// Create a copy of SessionActionUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<$Res> get error {
  
  return $AuthErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
