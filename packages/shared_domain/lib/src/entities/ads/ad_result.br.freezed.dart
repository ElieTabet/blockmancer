// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_result.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdResult()';
}


}

/// @nodoc
class $AdResultCopyWith<$Res>  {
$AdResultCopyWith(AdResult _, $Res Function(AdResult) __);
}


/// Adds pattern-matching-related methods to [AdResult].
extension AdResultPatterns on AdResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AdClosed value)?  closed,TResult Function( AdEarned value)?  earned,TResult Function( AdFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AdClosed() when closed != null:
return closed(_that);case AdEarned() when earned != null:
return earned(_that);case AdFailed() when failed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AdClosed value)  closed,required TResult Function( AdEarned value)  earned,required TResult Function( AdFailed value)  failed,}){
final _that = this;
switch (_that) {
case AdClosed():
return closed(_that);case AdEarned():
return earned(_that);case AdFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AdClosed value)?  closed,TResult? Function( AdEarned value)?  earned,TResult? Function( AdFailed value)?  failed,}){
final _that = this;
switch (_that) {
case AdClosed() when closed != null:
return closed(_that);case AdEarned() when earned != null:
return earned(_that);case AdFailed() when failed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  closed,TResult Function()?  earned,TResult Function( String code)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AdClosed() when closed != null:
return closed();case AdEarned() when earned != null:
return earned();case AdFailed() when failed != null:
return failed(_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  closed,required TResult Function()  earned,required TResult Function( String code)  failed,}) {final _that = this;
switch (_that) {
case AdClosed():
return closed();case AdEarned():
return earned();case AdFailed():
return failed(_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  closed,TResult? Function()?  earned,TResult? Function( String code)?  failed,}) {final _that = this;
switch (_that) {
case AdClosed() when closed != null:
return closed();case AdEarned() when earned != null:
return earned();case AdFailed() when failed != null:
return failed(_that.code);case _:
  return null;

}
}

}

/// @nodoc


class AdClosed implements AdResult {
  const AdClosed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdClosed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdResult.closed()';
}


}




/// @nodoc


class AdEarned implements AdResult {
  const AdEarned();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdEarned);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdResult.earned()';
}


}




/// @nodoc


class AdFailed implements AdResult {
  const AdFailed({required this.code});
  

 final  String code;

/// Create a copy of AdResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdFailedCopyWith<AdFailed> get copyWith => _$AdFailedCopyWithImpl<AdFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdFailed&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'AdResult.failed(code: $code)';
}


}

/// @nodoc
abstract mixin class $AdFailedCopyWith<$Res> implements $AdResultCopyWith<$Res> {
  factory $AdFailedCopyWith(AdFailed value, $Res Function(AdFailed) _then) = _$AdFailedCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$AdFailedCopyWithImpl<$Res>
    implements $AdFailedCopyWith<$Res> {
  _$AdFailedCopyWithImpl(this._self, this._then);

  final AdFailed _self;
  final $Res Function(AdFailed) _then;

/// Create a copy of AdResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(AdFailed(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
