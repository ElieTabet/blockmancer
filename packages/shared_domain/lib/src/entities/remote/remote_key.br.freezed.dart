// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_key.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteKey {

/// The in-app default, as Remote Config would publish it.
 String get defaultValue; String get description; RemoteKeyKind get kind; String get name;/// The allowed range of a number, inclusive; a value outside it is
/// ignored.
 num? get max; num? get min;
/// Create a copy of RemoteKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteKeyCopyWith<RemoteKey> get copyWith => _$RemoteKeyCopyWithImpl<RemoteKey>(this as RemoteKey, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteKey&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.max, max) || other.max == max)&&(identical(other.min, min) || other.min == min));
}


@override
int get hashCode => Object.hash(runtimeType,defaultValue,description,kind,name,max,min);

@override
String toString() {
  return 'RemoteKey(defaultValue: $defaultValue, description: $description, kind: $kind, name: $name, max: $max, min: $min)';
}


}

/// @nodoc
abstract mixin class $RemoteKeyCopyWith<$Res>  {
  factory $RemoteKeyCopyWith(RemoteKey value, $Res Function(RemoteKey) _then) = _$RemoteKeyCopyWithImpl;
@useResult
$Res call({
 String defaultValue, String description, RemoteKeyKind kind, String name, num? max, num? min
});




}
/// @nodoc
class _$RemoteKeyCopyWithImpl<$Res>
    implements $RemoteKeyCopyWith<$Res> {
  _$RemoteKeyCopyWithImpl(this._self, this._then);

  final RemoteKey _self;
  final $Res Function(RemoteKey) _then;

/// Create a copy of RemoteKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultValue = null,Object? description = null,Object? kind = null,Object? name = null,Object? max = freezed,Object? min = freezed,}) {
  return _then(_self.copyWith(
defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RemoteKeyKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as num?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteKey].
extension RemoteKeyPatterns on RemoteKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteKey value)  $default,){
final _that = this;
switch (_that) {
case _RemoteKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteKey value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String defaultValue,  String description,  RemoteKeyKind kind,  String name,  num? max,  num? min)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteKey() when $default != null:
return $default(_that.defaultValue,_that.description,_that.kind,_that.name,_that.max,_that.min);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String defaultValue,  String description,  RemoteKeyKind kind,  String name,  num? max,  num? min)  $default,) {final _that = this;
switch (_that) {
case _RemoteKey():
return $default(_that.defaultValue,_that.description,_that.kind,_that.name,_that.max,_that.min);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String defaultValue,  String description,  RemoteKeyKind kind,  String name,  num? max,  num? min)?  $default,) {final _that = this;
switch (_that) {
case _RemoteKey() when $default != null:
return $default(_that.defaultValue,_that.description,_that.kind,_that.name,_that.max,_that.min);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteKey implements RemoteKey {
  const _RemoteKey({required this.defaultValue, required this.description, required this.kind, required this.name, this.max, this.min});
  

/// The in-app default, as Remote Config would publish it.
@override final  String defaultValue;
@override final  String description;
@override final  RemoteKeyKind kind;
@override final  String name;
/// The allowed range of a number, inclusive; a value outside it is
/// ignored.
@override final  num? max;
@override final  num? min;

/// Create a copy of RemoteKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteKeyCopyWith<_RemoteKey> get copyWith => __$RemoteKeyCopyWithImpl<_RemoteKey>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteKey&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.max, max) || other.max == max)&&(identical(other.min, min) || other.min == min));
}


@override
int get hashCode => Object.hash(runtimeType,defaultValue,description,kind,name,max,min);

@override
String toString() {
  return 'RemoteKey(defaultValue: $defaultValue, description: $description, kind: $kind, name: $name, max: $max, min: $min)';
}


}

/// @nodoc
abstract mixin class _$RemoteKeyCopyWith<$Res> implements $RemoteKeyCopyWith<$Res> {
  factory _$RemoteKeyCopyWith(_RemoteKey value, $Res Function(_RemoteKey) _then) = __$RemoteKeyCopyWithImpl;
@override @useResult
$Res call({
 String defaultValue, String description, RemoteKeyKind kind, String name, num? max, num? min
});




}
/// @nodoc
class __$RemoteKeyCopyWithImpl<$Res>
    implements _$RemoteKeyCopyWith<$Res> {
  __$RemoteKeyCopyWithImpl(this._self, this._then);

  final _RemoteKey _self;
  final $Res Function(_RemoteKey) _then;

/// Create a copy of RemoteKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultValue = null,Object? description = null,Object? kind = null,Object? name = null,Object? max = freezed,Object? min = freezed,}) {
  return _then(_RemoteKey(
defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RemoteKeyKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as num?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
