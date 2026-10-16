// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_error.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkError {

 Object? get originalError; NetworkRequest? get request;
/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this as NetworkError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res>  {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@useResult
$Res call({
 Object? originalError, NetworkRequest? request
});


$NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalError = freezed,Object? request = freezed,}) {
  return _then(_self.copyWith(
originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}
/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// Adds pattern-matching-related methods to [NetworkError].
extension NetworkErrorPatterns on NetworkError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkTimeoutError value)?  timeout,TResult Function( NetworkConnectionError value)?  connection,TResult Function( NetworkNoInternetError value)?  noInternet,TResult Function( NetworkServerError value)?  server,TResult Function( NetworkClientError value)?  client,TResult Function( NetworkForbiddenError value)?  forbidden,TResult Function( NetworkUnauthorizedError value)?  unauthorized,TResult Function( NetworkDecodingError value)?  decoding,TResult Function( NetworkUnknownError value)?  unknown,TResult Function( NetworkCancelledError value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkTimeoutError() when timeout != null:
return timeout(_that);case NetworkConnectionError() when connection != null:
return connection(_that);case NetworkNoInternetError() when noInternet != null:
return noInternet(_that);case NetworkServerError() when server != null:
return server(_that);case NetworkClientError() when client != null:
return client(_that);case NetworkForbiddenError() when forbidden != null:
return forbidden(_that);case NetworkUnauthorizedError() when unauthorized != null:
return unauthorized(_that);case NetworkDecodingError() when decoding != null:
return decoding(_that);case NetworkUnknownError() when unknown != null:
return unknown(_that);case NetworkCancelledError() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkTimeoutError value)  timeout,required TResult Function( NetworkConnectionError value)  connection,required TResult Function( NetworkNoInternetError value)  noInternet,required TResult Function( NetworkServerError value)  server,required TResult Function( NetworkClientError value)  client,required TResult Function( NetworkForbiddenError value)  forbidden,required TResult Function( NetworkUnauthorizedError value)  unauthorized,required TResult Function( NetworkDecodingError value)  decoding,required TResult Function( NetworkUnknownError value)  unknown,required TResult Function( NetworkCancelledError value)  cancelled,}){
final _that = this;
switch (_that) {
case NetworkTimeoutError():
return timeout(_that);case NetworkConnectionError():
return connection(_that);case NetworkNoInternetError():
return noInternet(_that);case NetworkServerError():
return server(_that);case NetworkClientError():
return client(_that);case NetworkForbiddenError():
return forbidden(_that);case NetworkUnauthorizedError():
return unauthorized(_that);case NetworkDecodingError():
return decoding(_that);case NetworkUnknownError():
return unknown(_that);case NetworkCancelledError():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkTimeoutError value)?  timeout,TResult? Function( NetworkConnectionError value)?  connection,TResult? Function( NetworkNoInternetError value)?  noInternet,TResult? Function( NetworkServerError value)?  server,TResult? Function( NetworkClientError value)?  client,TResult? Function( NetworkForbiddenError value)?  forbidden,TResult? Function( NetworkUnauthorizedError value)?  unauthorized,TResult? Function( NetworkDecodingError value)?  decoding,TResult? Function( NetworkUnknownError value)?  unknown,TResult? Function( NetworkCancelledError value)?  cancelled,}){
final _that = this;
switch (_that) {
case NetworkTimeoutError() when timeout != null:
return timeout(_that);case NetworkConnectionError() when connection != null:
return connection(_that);case NetworkNoInternetError() when noInternet != null:
return noInternet(_that);case NetworkServerError() when server != null:
return server(_that);case NetworkClientError() when client != null:
return client(_that);case NetworkForbiddenError() when forbidden != null:
return forbidden(_that);case NetworkUnauthorizedError() when unauthorized != null:
return unauthorized(_that);case NetworkDecodingError() when decoding != null:
return decoding(_that);case NetworkUnknownError() when unknown != null:
return unknown(_that);case NetworkCancelledError() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Duration? timeout,  Object? originalError,  NetworkRequest? request)?  timeout,TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)?  connection,TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)?  noInternet,TResult Function( int statusCode,  dynamic data,  String? serverMessage,  Object? originalError,  NetworkRequest? request)?  server,TResult Function( int statusCode,  String? clientMessage,  dynamic data,  Object? originalError,  NetworkRequest? request)?  client,TResult Function( dynamic data,  Object? originalError,  NetworkRequest? request)?  forbidden,TResult Function( dynamic data,  Object? originalError,  NetworkRequest? request)?  unauthorized,TResult Function( Object? originalError,  NetworkRequest? request)?  decoding,TResult Function( Object? originalError,  NetworkRequest? request)?  unknown,TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkTimeoutError() when timeout != null:
return timeout(_that.timeout,_that.originalError,_that.request);case NetworkConnectionError() when connection != null:
return connection(_that.reason,_that.originalError,_that.request);case NetworkNoInternetError() when noInternet != null:
return noInternet(_that.reason,_that.originalError,_that.request);case NetworkServerError() when server != null:
return server(_that.statusCode,_that.data,_that.serverMessage,_that.originalError,_that.request);case NetworkClientError() when client != null:
return client(_that.statusCode,_that.clientMessage,_that.data,_that.originalError,_that.request);case NetworkForbiddenError() when forbidden != null:
return forbidden(_that.data,_that.originalError,_that.request);case NetworkUnauthorizedError() when unauthorized != null:
return unauthorized(_that.data,_that.originalError,_that.request);case NetworkDecodingError() when decoding != null:
return decoding(_that.originalError,_that.request);case NetworkUnknownError() when unknown != null:
return unknown(_that.originalError,_that.request);case NetworkCancelledError() when cancelled != null:
return cancelled(_that.reason,_that.originalError,_that.request);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Duration? timeout,  Object? originalError,  NetworkRequest? request)  timeout,required TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)  connection,required TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)  noInternet,required TResult Function( int statusCode,  dynamic data,  String? serverMessage,  Object? originalError,  NetworkRequest? request)  server,required TResult Function( int statusCode,  String? clientMessage,  dynamic data,  Object? originalError,  NetworkRequest? request)  client,required TResult Function( dynamic data,  Object? originalError,  NetworkRequest? request)  forbidden,required TResult Function( dynamic data,  Object? originalError,  NetworkRequest? request)  unauthorized,required TResult Function( Object? originalError,  NetworkRequest? request)  decoding,required TResult Function( Object? originalError,  NetworkRequest? request)  unknown,required TResult Function( String? reason,  Object? originalError,  NetworkRequest? request)  cancelled,}) {final _that = this;
switch (_that) {
case NetworkTimeoutError():
return timeout(_that.timeout,_that.originalError,_that.request);case NetworkConnectionError():
return connection(_that.reason,_that.originalError,_that.request);case NetworkNoInternetError():
return noInternet(_that.reason,_that.originalError,_that.request);case NetworkServerError():
return server(_that.statusCode,_that.data,_that.serverMessage,_that.originalError,_that.request);case NetworkClientError():
return client(_that.statusCode,_that.clientMessage,_that.data,_that.originalError,_that.request);case NetworkForbiddenError():
return forbidden(_that.data,_that.originalError,_that.request);case NetworkUnauthorizedError():
return unauthorized(_that.data,_that.originalError,_that.request);case NetworkDecodingError():
return decoding(_that.originalError,_that.request);case NetworkUnknownError():
return unknown(_that.originalError,_that.request);case NetworkCancelledError():
return cancelled(_that.reason,_that.originalError,_that.request);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Duration? timeout,  Object? originalError,  NetworkRequest? request)?  timeout,TResult? Function( String? reason,  Object? originalError,  NetworkRequest? request)?  connection,TResult? Function( String? reason,  Object? originalError,  NetworkRequest? request)?  noInternet,TResult? Function( int statusCode,  dynamic data,  String? serverMessage,  Object? originalError,  NetworkRequest? request)?  server,TResult? Function( int statusCode,  String? clientMessage,  dynamic data,  Object? originalError,  NetworkRequest? request)?  client,TResult? Function( dynamic data,  Object? originalError,  NetworkRequest? request)?  forbidden,TResult? Function( dynamic data,  Object? originalError,  NetworkRequest? request)?  unauthorized,TResult? Function( Object? originalError,  NetworkRequest? request)?  decoding,TResult? Function( Object? originalError,  NetworkRequest? request)?  unknown,TResult? Function( String? reason,  Object? originalError,  NetworkRequest? request)?  cancelled,}) {final _that = this;
switch (_that) {
case NetworkTimeoutError() when timeout != null:
return timeout(_that.timeout,_that.originalError,_that.request);case NetworkConnectionError() when connection != null:
return connection(_that.reason,_that.originalError,_that.request);case NetworkNoInternetError() when noInternet != null:
return noInternet(_that.reason,_that.originalError,_that.request);case NetworkServerError() when server != null:
return server(_that.statusCode,_that.data,_that.serverMessage,_that.originalError,_that.request);case NetworkClientError() when client != null:
return client(_that.statusCode,_that.clientMessage,_that.data,_that.originalError,_that.request);case NetworkForbiddenError() when forbidden != null:
return forbidden(_that.data,_that.originalError,_that.request);case NetworkUnauthorizedError() when unauthorized != null:
return unauthorized(_that.data,_that.originalError,_that.request);case NetworkDecodingError() when decoding != null:
return decoding(_that.originalError,_that.request);case NetworkUnknownError() when unknown != null:
return unknown(_that.originalError,_that.request);case NetworkCancelledError() when cancelled != null:
return cancelled(_that.reason,_that.originalError,_that.request);case _:
  return null;

}
}

}

/// @nodoc


class NetworkTimeoutError extends NetworkError {
  const NetworkTimeoutError({this.timeout, this.originalError, this.request}): super._();
  

 final  Duration? timeout;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkTimeoutErrorCopyWith<NetworkTimeoutError> get copyWith => _$NetworkTimeoutErrorCopyWithImpl<NetworkTimeoutError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkTimeoutError&&(identical(other.timeout, timeout) || other.timeout == timeout)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,timeout,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkTimeoutErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkTimeoutErrorCopyWith(NetworkTimeoutError value, $Res Function(NetworkTimeoutError) _then) = _$NetworkTimeoutErrorCopyWithImpl;
@override @useResult
$Res call({
 Duration? timeout, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkTimeoutErrorCopyWithImpl<$Res>
    implements $NetworkTimeoutErrorCopyWith<$Res> {
  _$NetworkTimeoutErrorCopyWithImpl(this._self, this._then);

  final NetworkTimeoutError _self;
  final $Res Function(NetworkTimeoutError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeout = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkTimeoutError(
timeout: freezed == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration?,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkConnectionError extends NetworkError {
  const NetworkConnectionError({this.reason, this.originalError, this.request}): super._();
  

 final  String? reason;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkConnectionErrorCopyWith<NetworkConnectionError> get copyWith => _$NetworkConnectionErrorCopyWithImpl<NetworkConnectionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkConnectionError&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,reason,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkConnectionErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkConnectionErrorCopyWith(NetworkConnectionError value, $Res Function(NetworkConnectionError) _then) = _$NetworkConnectionErrorCopyWithImpl;
@override @useResult
$Res call({
 String? reason, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkConnectionErrorCopyWithImpl<$Res>
    implements $NetworkConnectionErrorCopyWith<$Res> {
  _$NetworkConnectionErrorCopyWithImpl(this._self, this._then);

  final NetworkConnectionError _self;
  final $Res Function(NetworkConnectionError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkConnectionError(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkNoInternetError extends NetworkError {
  const NetworkNoInternetError({this.reason, this.originalError, this.request}): super._();
  

 final  String? reason;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkNoInternetErrorCopyWith<NetworkNoInternetError> get copyWith => _$NetworkNoInternetErrorCopyWithImpl<NetworkNoInternetError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkNoInternetError&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,reason,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkNoInternetErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkNoInternetErrorCopyWith(NetworkNoInternetError value, $Res Function(NetworkNoInternetError) _then) = _$NetworkNoInternetErrorCopyWithImpl;
@override @useResult
$Res call({
 String? reason, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkNoInternetErrorCopyWithImpl<$Res>
    implements $NetworkNoInternetErrorCopyWith<$Res> {
  _$NetworkNoInternetErrorCopyWithImpl(this._self, this._then);

  final NetworkNoInternetError _self;
  final $Res Function(NetworkNoInternetError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkNoInternetError(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkServerError extends NetworkError {
  const NetworkServerError({required this.statusCode, this.data, this.serverMessage, this.originalError, this.request}): super._();
  

 final  int statusCode;
 final  dynamic data;
 final  String? serverMessage;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkServerErrorCopyWith<NetworkServerError> get copyWith => _$NetworkServerErrorCopyWithImpl<NetworkServerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkServerError&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.serverMessage, serverMessage) || other.serverMessage == serverMessage)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,const DeepCollectionEquality().hash(data),serverMessage,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkServerErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkServerErrorCopyWith(NetworkServerError value, $Res Function(NetworkServerError) _then) = _$NetworkServerErrorCopyWithImpl;
@override @useResult
$Res call({
 int statusCode, dynamic data, String? serverMessage, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkServerErrorCopyWithImpl<$Res>
    implements $NetworkServerErrorCopyWith<$Res> {
  _$NetworkServerErrorCopyWithImpl(this._self, this._then);

  final NetworkServerError _self;
  final $Res Function(NetworkServerError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? data = freezed,Object? serverMessage = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkServerError(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,serverMessage: freezed == serverMessage ? _self.serverMessage : serverMessage // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkClientError extends NetworkError {
  const NetworkClientError({required this.statusCode, this.clientMessage, this.data, this.originalError, this.request}): super._();
  

 final  int statusCode;
 final  String? clientMessage;
 final  dynamic data;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkClientErrorCopyWith<NetworkClientError> get copyWith => _$NetworkClientErrorCopyWithImpl<NetworkClientError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkClientError&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.clientMessage, clientMessage) || other.clientMessage == clientMessage)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,clientMessage,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkClientErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkClientErrorCopyWith(NetworkClientError value, $Res Function(NetworkClientError) _then) = _$NetworkClientErrorCopyWithImpl;
@override @useResult
$Res call({
 int statusCode, String? clientMessage, dynamic data, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkClientErrorCopyWithImpl<$Res>
    implements $NetworkClientErrorCopyWith<$Res> {
  _$NetworkClientErrorCopyWithImpl(this._self, this._then);

  final NetworkClientError _self;
  final $Res Function(NetworkClientError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? clientMessage = freezed,Object? data = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkClientError(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,clientMessage: freezed == clientMessage ? _self.clientMessage : clientMessage // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkForbiddenError extends NetworkError {
  const NetworkForbiddenError({this.data, this.originalError, this.request}): super._();
  

 final  dynamic data;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkForbiddenErrorCopyWith<NetworkForbiddenError> get copyWith => _$NetworkForbiddenErrorCopyWithImpl<NetworkForbiddenError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkForbiddenError&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkForbiddenErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkForbiddenErrorCopyWith(NetworkForbiddenError value, $Res Function(NetworkForbiddenError) _then) = _$NetworkForbiddenErrorCopyWithImpl;
@override @useResult
$Res call({
 dynamic data, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkForbiddenErrorCopyWithImpl<$Res>
    implements $NetworkForbiddenErrorCopyWith<$Res> {
  _$NetworkForbiddenErrorCopyWithImpl(this._self, this._then);

  final NetworkForbiddenError _self;
  final $Res Function(NetworkForbiddenError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkForbiddenError(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkUnauthorizedError extends NetworkError {
  const NetworkUnauthorizedError({this.data, this.originalError, this.request}): super._();
  

 final  dynamic data;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkUnauthorizedErrorCopyWith<NetworkUnauthorizedError> get copyWith => _$NetworkUnauthorizedErrorCopyWithImpl<NetworkUnauthorizedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkUnauthorizedError&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkUnauthorizedErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkUnauthorizedErrorCopyWith(NetworkUnauthorizedError value, $Res Function(NetworkUnauthorizedError) _then) = _$NetworkUnauthorizedErrorCopyWithImpl;
@override @useResult
$Res call({
 dynamic data, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkUnauthorizedErrorCopyWithImpl<$Res>
    implements $NetworkUnauthorizedErrorCopyWith<$Res> {
  _$NetworkUnauthorizedErrorCopyWithImpl(this._self, this._then);

  final NetworkUnauthorizedError _self;
  final $Res Function(NetworkUnauthorizedError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkUnauthorizedError(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkDecodingError extends NetworkError {
  const NetworkDecodingError({this.originalError, this.request}): super._();
  

@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkDecodingErrorCopyWith<NetworkDecodingError> get copyWith => _$NetworkDecodingErrorCopyWithImpl<NetworkDecodingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkDecodingError&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkDecodingErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkDecodingErrorCopyWith(NetworkDecodingError value, $Res Function(NetworkDecodingError) _then) = _$NetworkDecodingErrorCopyWithImpl;
@override @useResult
$Res call({
 Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkDecodingErrorCopyWithImpl<$Res>
    implements $NetworkDecodingErrorCopyWith<$Res> {
  _$NetworkDecodingErrorCopyWithImpl(this._self, this._then);

  final NetworkDecodingError _self;
  final $Res Function(NetworkDecodingError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkDecodingError(
originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkUnknownError extends NetworkError {
  const NetworkUnknownError({this.originalError, this.request}): super._();
  

@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkUnknownErrorCopyWith<NetworkUnknownError> get copyWith => _$NetworkUnknownErrorCopyWithImpl<NetworkUnknownError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkUnknownError&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkUnknownErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkUnknownErrorCopyWith(NetworkUnknownError value, $Res Function(NetworkUnknownError) _then) = _$NetworkUnknownErrorCopyWithImpl;
@override @useResult
$Res call({
 Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkUnknownErrorCopyWithImpl<$Res>
    implements $NetworkUnknownErrorCopyWith<$Res> {
  _$NetworkUnknownErrorCopyWithImpl(this._self, this._then);

  final NetworkUnknownError _self;
  final $Res Function(NetworkUnknownError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkUnknownError(
originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class NetworkCancelledError extends NetworkError {
  const NetworkCancelledError({this.reason, this.originalError, this.request}): super._();
  

 final  String? reason;
@override final  Object? originalError;
@override final  NetworkRequest? request;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkCancelledErrorCopyWith<NetworkCancelledError> get copyWith => _$NetworkCancelledErrorCopyWithImpl<NetworkCancelledError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkCancelledError&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.originalError, originalError)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,reason,const DeepCollectionEquality().hash(originalError),request);



}

/// @nodoc
abstract mixin class $NetworkCancelledErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory $NetworkCancelledErrorCopyWith(NetworkCancelledError value, $Res Function(NetworkCancelledError) _then) = _$NetworkCancelledErrorCopyWithImpl;
@override @useResult
$Res call({
 String? reason, Object? originalError, NetworkRequest? request
});


@override $NetworkRequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$NetworkCancelledErrorCopyWithImpl<$Res>
    implements $NetworkCancelledErrorCopyWith<$Res> {
  _$NetworkCancelledErrorCopyWithImpl(this._self, this._then);

  final NetworkCancelledError _self;
  final $Res Function(NetworkCancelledError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? originalError = freezed,Object? request = freezed,}) {
  return _then(NetworkCancelledError(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as NetworkRequest?,
  ));
}

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $NetworkRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

// dart format on
