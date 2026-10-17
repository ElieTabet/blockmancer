// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_end_record.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunEndRecord {

 int get best; bool get isNewBest;
/// Create a copy of RunEndRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunEndRecordCopyWith<RunEndRecord> get copyWith => _$RunEndRecordCopyWithImpl<RunEndRecord>(this as RunEndRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunEndRecord&&(identical(other.best, best) || other.best == best)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}


@override
int get hashCode => Object.hash(runtimeType,best,isNewBest);

@override
String toString() {
  return 'RunEndRecord(best: $best, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class $RunEndRecordCopyWith<$Res>  {
  factory $RunEndRecordCopyWith(RunEndRecord value, $Res Function(RunEndRecord) _then) = _$RunEndRecordCopyWithImpl;
@useResult
$Res call({
 int best, bool isNewBest
});




}
/// @nodoc
class _$RunEndRecordCopyWithImpl<$Res>
    implements $RunEndRecordCopyWith<$Res> {
  _$RunEndRecordCopyWithImpl(this._self, this._then);

  final RunEndRecord _self;
  final $Res Function(RunEndRecord) _then;

/// Create a copy of RunEndRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? best = null,Object? isNewBest = null,}) {
  return _then(_self.copyWith(
best: null == best ? _self.best : best // ignore: cast_nullable_to_non_nullable
as int,isNewBest: null == isNewBest ? _self.isNewBest : isNewBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RunEndRecord].
extension RunEndRecordPatterns on RunEndRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunEndRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunEndRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunEndRecord value)  $default,){
final _that = this;
switch (_that) {
case _RunEndRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunEndRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RunEndRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int best,  bool isNewBest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunEndRecord() when $default != null:
return $default(_that.best,_that.isNewBest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int best,  bool isNewBest)  $default,) {final _that = this;
switch (_that) {
case _RunEndRecord():
return $default(_that.best,_that.isNewBest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int best,  bool isNewBest)?  $default,) {final _that = this;
switch (_that) {
case _RunEndRecord() when $default != null:
return $default(_that.best,_that.isNewBest);case _:
  return null;

}
}

}

/// @nodoc


class _RunEndRecord implements RunEndRecord {
  const _RunEndRecord({required this.best, required this.isNewBest});
  

@override final  int best;
@override final  bool isNewBest;

/// Create a copy of RunEndRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunEndRecordCopyWith<_RunEndRecord> get copyWith => __$RunEndRecordCopyWithImpl<_RunEndRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunEndRecord&&(identical(other.best, best) || other.best == best)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}


@override
int get hashCode => Object.hash(runtimeType,best,isNewBest);

@override
String toString() {
  return 'RunEndRecord(best: $best, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class _$RunEndRecordCopyWith<$Res> implements $RunEndRecordCopyWith<$Res> {
  factory _$RunEndRecordCopyWith(_RunEndRecord value, $Res Function(_RunEndRecord) _then) = __$RunEndRecordCopyWithImpl;
@override @useResult
$Res call({
 int best, bool isNewBest
});




}
/// @nodoc
class __$RunEndRecordCopyWithImpl<$Res>
    implements _$RunEndRecordCopyWith<$Res> {
  __$RunEndRecordCopyWithImpl(this._self, this._then);

  final _RunEndRecord _self;
  final $Res Function(_RunEndRecord) _then;

/// Create a copy of RunEndRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? best = null,Object? isNewBest = null,}) {
  return _then(_RunEndRecord(
best: null == best ? _self.best : best // ignore: cast_nullable_to_non_nullable
as int,isNewBest: null == isNewBest ? _self.isNewBest : isNewBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
