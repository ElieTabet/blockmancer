// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_request.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkRequest {

 String get method; String get url; dynamic get data; Map<String, dynamic> get extra; Map<String, String> get headers; Map<String, dynamic>? get queryParameters;
/// Create a copy of NetworkRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkRequestCopyWith<NetworkRequest> get copyWith => _$NetworkRequestCopyWithImpl<NetworkRequest>(this as NetworkRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkRequest&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.extra, extra)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.queryParameters, queryParameters));
}


@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(extra),const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(queryParameters));

@override
String toString() {
  return 'NetworkRequest(method: $method, url: $url, data: $data, extra: $extra, headers: $headers, queryParameters: $queryParameters)';
}


}

/// @nodoc
abstract mixin class $NetworkRequestCopyWith<$Res>  {
  factory $NetworkRequestCopyWith(NetworkRequest value, $Res Function(NetworkRequest) _then) = _$NetworkRequestCopyWithImpl;
@useResult
$Res call({
 String method, String url, dynamic data, Map<String, dynamic> extra, Map<String, String> headers, Map<String, dynamic>? queryParameters
});




}
/// @nodoc
class _$NetworkRequestCopyWithImpl<$Res>
    implements $NetworkRequestCopyWith<$Res> {
  _$NetworkRequestCopyWithImpl(this._self, this._then);

  final NetworkRequest _self;
  final $Res Function(NetworkRequest) _then;

/// Create a copy of NetworkRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? url = null,Object? data = freezed,Object? extra = null,Object? headers = null,Object? queryParameters = freezed,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,queryParameters: freezed == queryParameters ? _self.queryParameters : queryParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkRequest].
extension NetworkRequestPatterns on NetworkRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkRequest value)  $default,){
final _that = this;
switch (_that) {
case _NetworkRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkRequest value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String method,  String url,  dynamic data,  Map<String, dynamic> extra,  Map<String, String> headers,  Map<String, dynamic>? queryParameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkRequest() when $default != null:
return $default(_that.method,_that.url,_that.data,_that.extra,_that.headers,_that.queryParameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String method,  String url,  dynamic data,  Map<String, dynamic> extra,  Map<String, String> headers,  Map<String, dynamic>? queryParameters)  $default,) {final _that = this;
switch (_that) {
case _NetworkRequest():
return $default(_that.method,_that.url,_that.data,_that.extra,_that.headers,_that.queryParameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String method,  String url,  dynamic data,  Map<String, dynamic> extra,  Map<String, String> headers,  Map<String, dynamic>? queryParameters)?  $default,) {final _that = this;
switch (_that) {
case _NetworkRequest() when $default != null:
return $default(_that.method,_that.url,_that.data,_that.extra,_that.headers,_that.queryParameters);case _:
  return null;

}
}

}

/// @nodoc


class _NetworkRequest extends NetworkRequest {
  const _NetworkRequest({required this.method, required this.url, this.data, final  Map<String, dynamic> extra = const {}, final  Map<String, String> headers = const {}, final  Map<String, dynamic>? queryParameters}): _extra = extra,_headers = headers,_queryParameters = queryParameters,super._();
  

@override final  String method;
@override final  String url;
@override final  dynamic data;
 final  Map<String, dynamic> _extra;
@override@JsonKey() Map<String, dynamic> get extra {
  if (_extra is EqualUnmodifiableMapView) return _extra;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extra);
}

 final  Map<String, String> _headers;
@override@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

 final  Map<String, dynamic>? _queryParameters;
@override Map<String, dynamic>? get queryParameters {
  final value = _queryParameters;
  if (value == null) return null;
  if (_queryParameters is EqualUnmodifiableMapView) return _queryParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of NetworkRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkRequestCopyWith<_NetworkRequest> get copyWith => __$NetworkRequestCopyWithImpl<_NetworkRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkRequest&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other._extra, _extra)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other._queryParameters, _queryParameters));
}


@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(_extra),const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(_queryParameters));

@override
String toString() {
  return 'NetworkRequest(method: $method, url: $url, data: $data, extra: $extra, headers: $headers, queryParameters: $queryParameters)';
}


}

/// @nodoc
abstract mixin class _$NetworkRequestCopyWith<$Res> implements $NetworkRequestCopyWith<$Res> {
  factory _$NetworkRequestCopyWith(_NetworkRequest value, $Res Function(_NetworkRequest) _then) = __$NetworkRequestCopyWithImpl;
@override @useResult
$Res call({
 String method, String url, dynamic data, Map<String, dynamic> extra, Map<String, String> headers, Map<String, dynamic>? queryParameters
});




}
/// @nodoc
class __$NetworkRequestCopyWithImpl<$Res>
    implements _$NetworkRequestCopyWith<$Res> {
  __$NetworkRequestCopyWithImpl(this._self, this._then);

  final _NetworkRequest _self;
  final $Res Function(_NetworkRequest) _then;

/// Create a copy of NetworkRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? url = null,Object? data = freezed,Object? extra = null,Object? headers = null,Object? queryParameters = freezed,}) {
  return _then(_NetworkRequest(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,extra: null == extra ? _self._extra : extra // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,queryParameters: freezed == queryParameters ? _self._queryParameters : queryParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
