// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webview_ui_configuration.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebViewUiConfiguration {

 URLRequest? get initialUrlRequest; InAppWebViewInitialData? get initialData;
/// Create a copy of WebViewUiConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewUiConfigurationCopyWith<WebViewUiConfiguration> get copyWith => _$WebViewUiConfigurationCopyWithImpl<WebViewUiConfiguration>(this as WebViewUiConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewUiConfiguration&&(identical(other.initialUrlRequest, initialUrlRequest) || other.initialUrlRequest == initialUrlRequest)&&(identical(other.initialData, initialData) || other.initialData == initialData));
}


@override
int get hashCode => Object.hash(runtimeType,initialUrlRequest,initialData);

@override
String toString() {
  return 'WebViewUiConfiguration(initialUrlRequest: $initialUrlRequest, initialData: $initialData)';
}


}

/// @nodoc
abstract mixin class $WebViewUiConfigurationCopyWith<$Res>  {
  factory $WebViewUiConfigurationCopyWith(WebViewUiConfiguration value, $Res Function(WebViewUiConfiguration) _then) = _$WebViewUiConfigurationCopyWithImpl;
@useResult
$Res call({
 URLRequest? initialUrlRequest, InAppWebViewInitialData? initialData
});




}
/// @nodoc
class _$WebViewUiConfigurationCopyWithImpl<$Res>
    implements $WebViewUiConfigurationCopyWith<$Res> {
  _$WebViewUiConfigurationCopyWithImpl(this._self, this._then);

  final WebViewUiConfiguration _self;
  final $Res Function(WebViewUiConfiguration) _then;

/// Create a copy of WebViewUiConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialUrlRequest = freezed,Object? initialData = freezed,}) {
  return _then(_self.copyWith(
initialUrlRequest: freezed == initialUrlRequest ? _self.initialUrlRequest : initialUrlRequest // ignore: cast_nullable_to_non_nullable
as URLRequest?,initialData: freezed == initialData ? _self.initialData : initialData // ignore: cast_nullable_to_non_nullable
as InAppWebViewInitialData?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebViewUiConfiguration].
extension WebViewUiConfigurationPatterns on WebViewUiConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebViewUiConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebViewUiConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebViewUiConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _WebViewUiConfiguration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebViewUiConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _WebViewUiConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( URLRequest? initialUrlRequest,  InAppWebViewInitialData? initialData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebViewUiConfiguration() when $default != null:
return $default(_that.initialUrlRequest,_that.initialData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( URLRequest? initialUrlRequest,  InAppWebViewInitialData? initialData)  $default,) {final _that = this;
switch (_that) {
case _WebViewUiConfiguration():
return $default(_that.initialUrlRequest,_that.initialData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( URLRequest? initialUrlRequest,  InAppWebViewInitialData? initialData)?  $default,) {final _that = this;
switch (_that) {
case _WebViewUiConfiguration() when $default != null:
return $default(_that.initialUrlRequest,_that.initialData);case _:
  return null;

}
}

}

/// @nodoc


class _WebViewUiConfiguration implements WebViewUiConfiguration {
  const _WebViewUiConfiguration({this.initialUrlRequest, this.initialData}): assert((initialUrlRequest != null ? 1 : 0) + (initialData != null ? 1 : 0) == 1, 'Exactly one of initialUrlRequest or initialData must be set.');
  

@override final  URLRequest? initialUrlRequest;
@override final  InAppWebViewInitialData? initialData;

/// Create a copy of WebViewUiConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebViewUiConfigurationCopyWith<_WebViewUiConfiguration> get copyWith => __$WebViewUiConfigurationCopyWithImpl<_WebViewUiConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebViewUiConfiguration&&(identical(other.initialUrlRequest, initialUrlRequest) || other.initialUrlRequest == initialUrlRequest)&&(identical(other.initialData, initialData) || other.initialData == initialData));
}


@override
int get hashCode => Object.hash(runtimeType,initialUrlRequest,initialData);

@override
String toString() {
  return 'WebViewUiConfiguration(initialUrlRequest: $initialUrlRequest, initialData: $initialData)';
}


}

/// @nodoc
abstract mixin class _$WebViewUiConfigurationCopyWith<$Res> implements $WebViewUiConfigurationCopyWith<$Res> {
  factory _$WebViewUiConfigurationCopyWith(_WebViewUiConfiguration value, $Res Function(_WebViewUiConfiguration) _then) = __$WebViewUiConfigurationCopyWithImpl;
@override @useResult
$Res call({
 URLRequest? initialUrlRequest, InAppWebViewInitialData? initialData
});




}
/// @nodoc
class __$WebViewUiConfigurationCopyWithImpl<$Res>
    implements _$WebViewUiConfigurationCopyWith<$Res> {
  __$WebViewUiConfigurationCopyWithImpl(this._self, this._then);

  final _WebViewUiConfiguration _self;
  final $Res Function(_WebViewUiConfiguration) _then;

/// Create a copy of WebViewUiConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialUrlRequest = freezed,Object? initialData = freezed,}) {
  return _then(_WebViewUiConfiguration(
initialUrlRequest: freezed == initialUrlRequest ? _self.initialUrlRequest : initialUrlRequest // ignore: cast_nullable_to_non_nullable
as URLRequest?,initialData: freezed == initialData ? _self.initialData : initialData // ignore: cast_nullable_to_non_nullable
as InAppWebViewInitialData?,
  ));
}


}

// dart format on
