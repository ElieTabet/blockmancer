// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_need.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateNeed {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateNeed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateNeed()';
}


}

/// @nodoc
class $UpdateNeedCopyWith<$Res>  {
$UpdateNeedCopyWith(UpdateNeed _, $Res Function(UpdateNeed) __);
}


/// Adds pattern-matching-related methods to [UpdateNeed].
extension UpdateNeedPatterns on UpdateNeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UpdateNotNeeded value)?  none,TResult Function( UpdateOffered value)?  optional,TResult Function( UpdateRequired value)?  required,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UpdateNotNeeded() when none != null:
return none(_that);case UpdateOffered() when optional != null:
return optional(_that);case UpdateRequired() when required != null:
return required(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UpdateNotNeeded value)  none,required TResult Function( UpdateOffered value)  optional,required TResult Function( UpdateRequired value)  required,}){
final _that = this;
switch (_that) {
case UpdateNotNeeded():
return none(_that);case UpdateOffered():
return optional(_that);case UpdateRequired():
return required(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UpdateNotNeeded value)?  none,TResult? Function( UpdateOffered value)?  optional,TResult? Function( UpdateRequired value)?  required,}){
final _that = this;
switch (_that) {
case UpdateNotNeeded() when none != null:
return none(_that);case UpdateOffered() when optional != null:
return optional(_that);case UpdateRequired() when required != null:
return required(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( String latest)?  optional,TResult Function()?  required,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UpdateNotNeeded() when none != null:
return none();case UpdateOffered() when optional != null:
return optional(_that.latest);case UpdateRequired() when required != null:
return required();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( String latest)  optional,required TResult Function()  required,}) {final _that = this;
switch (_that) {
case UpdateNotNeeded():
return none();case UpdateOffered():
return optional(_that.latest);case UpdateRequired():
return required();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( String latest)?  optional,TResult? Function()?  required,}) {final _that = this;
switch (_that) {
case UpdateNotNeeded() when none != null:
return none();case UpdateOffered() when optional != null:
return optional(_that.latest);case UpdateRequired() when required != null:
return required();case _:
  return null;

}
}

}

/// @nodoc


class UpdateNotNeeded implements UpdateNeed {
  const UpdateNotNeeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateNotNeeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateNeed.none()';
}


}




/// @nodoc


class UpdateOffered implements UpdateNeed {
  const UpdateOffered({required this.latest});
  

 final  String latest;

/// Create a copy of UpdateNeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOfferedCopyWith<UpdateOffered> get copyWith => _$UpdateOfferedCopyWithImpl<UpdateOffered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOffered&&(identical(other.latest, latest) || other.latest == latest));
}


@override
int get hashCode => Object.hash(runtimeType,latest);

@override
String toString() {
  return 'UpdateNeed.optional(latest: $latest)';
}


}

/// @nodoc
abstract mixin class $UpdateOfferedCopyWith<$Res> implements $UpdateNeedCopyWith<$Res> {
  factory $UpdateOfferedCopyWith(UpdateOffered value, $Res Function(UpdateOffered) _then) = _$UpdateOfferedCopyWithImpl;
@useResult
$Res call({
 String latest
});




}
/// @nodoc
class _$UpdateOfferedCopyWithImpl<$Res>
    implements $UpdateOfferedCopyWith<$Res> {
  _$UpdateOfferedCopyWithImpl(this._self, this._then);

  final UpdateOffered _self;
  final $Res Function(UpdateOffered) _then;

/// Create a copy of UpdateNeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latest = null,}) {
  return _then(UpdateOffered(
latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateRequired implements UpdateNeed {
  const UpdateRequired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateNeed.required()';
}


}




// dart format on
