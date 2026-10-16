// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webview_errors.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebviewError {

 bool get isMainFrame; String get requestUrl;
/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebviewErrorCopyWith<WebviewError> get copyWith => _$WebviewErrorCopyWithImpl<WebviewError>(this as WebviewError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebviewError&&(identical(other.isMainFrame, isMainFrame) || other.isMainFrame == isMainFrame)&&(identical(other.requestUrl, requestUrl) || other.requestUrl == requestUrl));
}


@override
int get hashCode => Object.hash(runtimeType,isMainFrame,requestUrl);

@override
String toString() {
  return 'WebviewError(isMainFrame: $isMainFrame, requestUrl: $requestUrl)';
}


}

/// @nodoc
abstract mixin class $WebviewErrorCopyWith<$Res>  {
  factory $WebviewErrorCopyWith(WebviewError value, $Res Function(WebviewError) _then) = _$WebviewErrorCopyWithImpl;
@useResult
$Res call({
 bool isMainFrame, String requestUrl
});




}
/// @nodoc
class _$WebviewErrorCopyWithImpl<$Res>
    implements $WebviewErrorCopyWith<$Res> {
  _$WebviewErrorCopyWithImpl(this._self, this._then);

  final WebviewError _self;
  final $Res Function(WebviewError) _then;

/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isMainFrame = null,Object? requestUrl = null,}) {
  return _then(_self.copyWith(
isMainFrame: null == isMainFrame ? _self.isMainFrame : isMainFrame // ignore: cast_nullable_to_non_nullable
as bool,requestUrl: null == requestUrl ? _self.requestUrl : requestUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WebviewError].
extension WebviewErrorPatterns on WebviewError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RuntimeWebviewError value)?  runtimeError,TResult Function( HttpWebviewError value)?  httpError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RuntimeWebviewError() when runtimeError != null:
return runtimeError(_that);case HttpWebviewError() when httpError != null:
return httpError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RuntimeWebviewError value)  runtimeError,required TResult Function( HttpWebviewError value)  httpError,}){
final _that = this;
switch (_that) {
case RuntimeWebviewError():
return runtimeError(_that);case HttpWebviewError():
return httpError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RuntimeWebviewError value)?  runtimeError,TResult? Function( HttpWebviewError value)?  httpError,}){
final _that = this;
switch (_that) {
case RuntimeWebviewError() when runtimeError != null:
return runtimeError(_that);case HttpWebviewError() when httpError != null:
return httpError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String description,  bool isMainFrame,  String requestUrl)?  runtimeError,TResult Function( bool isMainFrame,  String requestUrl,  int? statusCode)?  httpError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RuntimeWebviewError() when runtimeError != null:
return runtimeError(_that.description,_that.isMainFrame,_that.requestUrl);case HttpWebviewError() when httpError != null:
return httpError(_that.isMainFrame,_that.requestUrl,_that.statusCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String description,  bool isMainFrame,  String requestUrl)  runtimeError,required TResult Function( bool isMainFrame,  String requestUrl,  int? statusCode)  httpError,}) {final _that = this;
switch (_that) {
case RuntimeWebviewError():
return runtimeError(_that.description,_that.isMainFrame,_that.requestUrl);case HttpWebviewError():
return httpError(_that.isMainFrame,_that.requestUrl,_that.statusCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String description,  bool isMainFrame,  String requestUrl)?  runtimeError,TResult? Function( bool isMainFrame,  String requestUrl,  int? statusCode)?  httpError,}) {final _that = this;
switch (_that) {
case RuntimeWebviewError() when runtimeError != null:
return runtimeError(_that.description,_that.isMainFrame,_that.requestUrl);case HttpWebviewError() when httpError != null:
return httpError(_that.isMainFrame,_that.requestUrl,_that.statusCode);case _:
  return null;

}
}

}

/// @nodoc


class RuntimeWebviewError implements WebviewError {
  const RuntimeWebviewError({required this.description, required this.isMainFrame, required this.requestUrl});
  

 final  String description;
@override final  bool isMainFrame;
@override final  String requestUrl;

/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuntimeWebviewErrorCopyWith<RuntimeWebviewError> get copyWith => _$RuntimeWebviewErrorCopyWithImpl<RuntimeWebviewError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuntimeWebviewError&&(identical(other.description, description) || other.description == description)&&(identical(other.isMainFrame, isMainFrame) || other.isMainFrame == isMainFrame)&&(identical(other.requestUrl, requestUrl) || other.requestUrl == requestUrl));
}


@override
int get hashCode => Object.hash(runtimeType,description,isMainFrame,requestUrl);

@override
String toString() {
  return 'WebviewError.runtimeError(description: $description, isMainFrame: $isMainFrame, requestUrl: $requestUrl)';
}


}

/// @nodoc
abstract mixin class $RuntimeWebviewErrorCopyWith<$Res> implements $WebviewErrorCopyWith<$Res> {
  factory $RuntimeWebviewErrorCopyWith(RuntimeWebviewError value, $Res Function(RuntimeWebviewError) _then) = _$RuntimeWebviewErrorCopyWithImpl;
@override @useResult
$Res call({
 String description, bool isMainFrame, String requestUrl
});




}
/// @nodoc
class _$RuntimeWebviewErrorCopyWithImpl<$Res>
    implements $RuntimeWebviewErrorCopyWith<$Res> {
  _$RuntimeWebviewErrorCopyWithImpl(this._self, this._then);

  final RuntimeWebviewError _self;
  final $Res Function(RuntimeWebviewError) _then;

/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? isMainFrame = null,Object? requestUrl = null,}) {
  return _then(RuntimeWebviewError(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMainFrame: null == isMainFrame ? _self.isMainFrame : isMainFrame // ignore: cast_nullable_to_non_nullable
as bool,requestUrl: null == requestUrl ? _self.requestUrl : requestUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HttpWebviewError implements WebviewError {
  const HttpWebviewError({required this.isMainFrame, required this.requestUrl, this.statusCode});
  

@override final  bool isMainFrame;
@override final  String requestUrl;
 final  int? statusCode;

/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpWebviewErrorCopyWith<HttpWebviewError> get copyWith => _$HttpWebviewErrorCopyWithImpl<HttpWebviewError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpWebviewError&&(identical(other.isMainFrame, isMainFrame) || other.isMainFrame == isMainFrame)&&(identical(other.requestUrl, requestUrl) || other.requestUrl == requestUrl)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,isMainFrame,requestUrl,statusCode);

@override
String toString() {
  return 'WebviewError.httpError(isMainFrame: $isMainFrame, requestUrl: $requestUrl, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpWebviewErrorCopyWith<$Res> implements $WebviewErrorCopyWith<$Res> {
  factory $HttpWebviewErrorCopyWith(HttpWebviewError value, $Res Function(HttpWebviewError) _then) = _$HttpWebviewErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isMainFrame, String requestUrl, int? statusCode
});




}
/// @nodoc
class _$HttpWebviewErrorCopyWithImpl<$Res>
    implements $HttpWebviewErrorCopyWith<$Res> {
  _$HttpWebviewErrorCopyWithImpl(this._self, this._then);

  final HttpWebviewError _self;
  final $Res Function(HttpWebviewError) _then;

/// Create a copy of WebviewError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isMainFrame = null,Object? requestUrl = null,Object? statusCode = freezed,}) {
  return _then(HttpWebviewError(
isMainFrame: null == isMainFrame ? _self.isMainFrame : isMainFrame // ignore: cast_nullable_to_non_nullable
as bool,requestUrl: null == requestUrl ? _self.requestUrl : requestUrl // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
