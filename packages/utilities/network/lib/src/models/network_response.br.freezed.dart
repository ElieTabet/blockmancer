// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_response.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkResponse<T> {

 T? get data; Map<String, String> get headers; int? get statusCode; String? get statusMessage;
/// Create a copy of NetworkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkResponseCopyWith<T, NetworkResponse<T>> get copyWith => _$NetworkResponseCopyWithImpl<T, NetworkResponse<T>>(this as NetworkResponse<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkResponse<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(headers),statusCode,statusMessage);

@override
String toString() {
  return 'NetworkResponse<$T>(data: $data, headers: $headers, statusCode: $statusCode, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class $NetworkResponseCopyWith<T,$Res>  {
  factory $NetworkResponseCopyWith(NetworkResponse<T> value, $Res Function(NetworkResponse<T>) _then) = _$NetworkResponseCopyWithImpl;
@useResult
$Res call({
 T? data, Map<String, String> headers, int? statusCode, String? statusMessage
});




}
/// @nodoc
class _$NetworkResponseCopyWithImpl<T,$Res>
    implements $NetworkResponseCopyWith<T, $Res> {
  _$NetworkResponseCopyWithImpl(this._self, this._then);

  final NetworkResponse<T> _self;
  final $Res Function(NetworkResponse<T>) _then;

/// Create a copy of NetworkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? headers = null,Object? statusCode = freezed,Object? statusMessage = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkResponse].
extension NetworkResponsePatterns<T> on NetworkResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _NetworkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T? data,  Map<String, String> headers,  int? statusCode,  String? statusMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkResponse() when $default != null:
return $default(_that.data,_that.headers,_that.statusCode,_that.statusMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T? data,  Map<String, String> headers,  int? statusCode,  String? statusMessage)  $default,) {final _that = this;
switch (_that) {
case _NetworkResponse():
return $default(_that.data,_that.headers,_that.statusCode,_that.statusMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T? data,  Map<String, String> headers,  int? statusCode,  String? statusMessage)?  $default,) {final _that = this;
switch (_that) {
case _NetworkResponse() when $default != null:
return $default(_that.data,_that.headers,_that.statusCode,_that.statusMessage);case _:
  return null;

}
}

}

/// @nodoc


class _NetworkResponse<T> implements NetworkResponse<T> {
  const _NetworkResponse({this.data, final  Map<String, String> headers = const {}, this.statusCode, this.statusMessage}): _headers = headers;
  

@override final  T? data;
 final  Map<String, String> _headers;
@override@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override final  int? statusCode;
@override final  String? statusMessage;

/// Create a copy of NetworkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkResponseCopyWith<T, _NetworkResponse<T>> get copyWith => __$NetworkResponseCopyWithImpl<T, _NetworkResponse<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkResponse<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(_headers),statusCode,statusMessage);

@override
String toString() {
  return 'NetworkResponse<$T>(data: $data, headers: $headers, statusCode: $statusCode, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$NetworkResponseCopyWith<T,$Res> implements $NetworkResponseCopyWith<T, $Res> {
  factory _$NetworkResponseCopyWith(_NetworkResponse<T> value, $Res Function(_NetworkResponse<T>) _then) = __$NetworkResponseCopyWithImpl;
@override @useResult
$Res call({
 T? data, Map<String, String> headers, int? statusCode, String? statusMessage
});




}
/// @nodoc
class __$NetworkResponseCopyWithImpl<T,$Res>
    implements _$NetworkResponseCopyWith<T, $Res> {
  __$NetworkResponseCopyWithImpl(this._self, this._then);

  final _NetworkResponse<T> _self;
  final $Res Function(_NetworkResponse<T>) _then;

/// Create a copy of NetworkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? headers = null,Object? statusCode = freezed,Object? statusMessage = freezed,}) {
  return _then(_NetworkResponse<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
