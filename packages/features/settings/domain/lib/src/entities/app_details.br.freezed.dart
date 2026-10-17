// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_details.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppDetails {

 String get build; String get device; String get os; String get version;
/// Create a copy of AppDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppDetailsCopyWith<AppDetails> get copyWith => _$AppDetailsCopyWithImpl<AppDetails>(this as AppDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppDetails&&(identical(other.build, build) || other.build == build)&&(identical(other.device, device) || other.device == device)&&(identical(other.os, os) || other.os == os)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,build,device,os,version);

@override
String toString() {
  return 'AppDetails(build: $build, device: $device, os: $os, version: $version)';
}


}

/// @nodoc
abstract mixin class $AppDetailsCopyWith<$Res>  {
  factory $AppDetailsCopyWith(AppDetails value, $Res Function(AppDetails) _then) = _$AppDetailsCopyWithImpl;
@useResult
$Res call({
 String build, String device, String os, String version
});




}
/// @nodoc
class _$AppDetailsCopyWithImpl<$Res>
    implements $AppDetailsCopyWith<$Res> {
  _$AppDetailsCopyWithImpl(this._self, this._then);

  final AppDetails _self;
  final $Res Function(AppDetails) _then;

/// Create a copy of AppDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? build = null,Object? device = null,Object? os = null,Object? version = null,}) {
  return _then(_self.copyWith(
build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,os: null == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppDetails].
extension AppDetailsPatterns on AppDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppDetails value)  $default,){
final _that = this;
switch (_that) {
case _AppDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppDetails value)?  $default,){
final _that = this;
switch (_that) {
case _AppDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String build,  String device,  String os,  String version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppDetails() when $default != null:
return $default(_that.build,_that.device,_that.os,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String build,  String device,  String os,  String version)  $default,) {final _that = this;
switch (_that) {
case _AppDetails():
return $default(_that.build,_that.device,_that.os,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String build,  String device,  String os,  String version)?  $default,) {final _that = this;
switch (_that) {
case _AppDetails() when $default != null:
return $default(_that.build,_that.device,_that.os,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _AppDetails implements AppDetails {
  const _AppDetails({required this.build, required this.device, required this.os, required this.version});
  

@override final  String build;
@override final  String device;
@override final  String os;
@override final  String version;

/// Create a copy of AppDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppDetailsCopyWith<_AppDetails> get copyWith => __$AppDetailsCopyWithImpl<_AppDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppDetails&&(identical(other.build, build) || other.build == build)&&(identical(other.device, device) || other.device == device)&&(identical(other.os, os) || other.os == os)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,build,device,os,version);

@override
String toString() {
  return 'AppDetails(build: $build, device: $device, os: $os, version: $version)';
}


}

/// @nodoc
abstract mixin class _$AppDetailsCopyWith<$Res> implements $AppDetailsCopyWith<$Res> {
  factory _$AppDetailsCopyWith(_AppDetails value, $Res Function(_AppDetails) _then) = __$AppDetailsCopyWithImpl;
@override @useResult
$Res call({
 String build, String device, String os, String version
});




}
/// @nodoc
class __$AppDetailsCopyWithImpl<$Res>
    implements _$AppDetailsCopyWith<$Res> {
  __$AppDetailsCopyWithImpl(this._self, this._then);

  final _AppDetails _self;
  final $Res Function(_AppDetails) _then;

/// Create a copy of AppDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? build = null,Object? device = null,Object? os = null,Object? version = null,}) {
  return _then(_AppDetails(
build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,os: null == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
