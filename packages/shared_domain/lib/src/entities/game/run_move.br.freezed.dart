// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_move.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunMove {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunMove);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunMove()';
}


}

/// @nodoc
class $RunMoveCopyWith<$Res>  {
$RunMoveCopyWith(RunMove _, $Res Function(RunMove) __);
}


/// Adds pattern-matching-related methods to [RunMove].
extension RunMovePatterns on RunMove {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EndMove value)?  end,TResult Function( PickMove value)?  pick,TResult Function( PlaceMove value)?  place,TResult Function( ReviveMove value)?  revive,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EndMove() when end != null:
return end(_that);case PickMove() when pick != null:
return pick(_that);case PlaceMove() when place != null:
return place(_that);case ReviveMove() when revive != null:
return revive(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EndMove value)  end,required TResult Function( PickMove value)  pick,required TResult Function( PlaceMove value)  place,required TResult Function( ReviveMove value)  revive,}){
final _that = this;
switch (_that) {
case EndMove():
return end(_that);case PickMove():
return pick(_that);case PlaceMove():
return place(_that);case ReviveMove():
return revive(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EndMove value)?  end,TResult? Function( PickMove value)?  pick,TResult? Function( PlaceMove value)?  place,TResult? Function( ReviveMove value)?  revive,}){
final _that = this;
switch (_that) {
case EndMove() when end != null:
return end(_that);case PickMove() when pick != null:
return pick(_that);case PlaceMove() when place != null:
return place(_that);case ReviveMove() when revive != null:
return revive(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  end,TResult Function( JokerId id)?  pick,TResult Function( Cell anchor,  int trayIndex)?  place,TResult Function()?  revive,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EndMove() when end != null:
return end();case PickMove() when pick != null:
return pick(_that.id);case PlaceMove() when place != null:
return place(_that.anchor,_that.trayIndex);case ReviveMove() when revive != null:
return revive();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  end,required TResult Function( JokerId id)  pick,required TResult Function( Cell anchor,  int trayIndex)  place,required TResult Function()  revive,}) {final _that = this;
switch (_that) {
case EndMove():
return end();case PickMove():
return pick(_that.id);case PlaceMove():
return place(_that.anchor,_that.trayIndex);case ReviveMove():
return revive();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  end,TResult? Function( JokerId id)?  pick,TResult? Function( Cell anchor,  int trayIndex)?  place,TResult? Function()?  revive,}) {final _that = this;
switch (_that) {
case EndMove() when end != null:
return end();case PickMove() when pick != null:
return pick(_that.id);case PlaceMove() when place != null:
return place(_that.anchor,_that.trayIndex);case ReviveMove() when revive != null:
return revive();case _:
  return null;

}
}

}

/// @nodoc


class EndMove implements RunMove {
  const EndMove();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndMove);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunMove.end()';
}


}




/// @nodoc


class PickMove implements RunMove {
  const PickMove({required this.id});
  

 final  JokerId id;

/// Create a copy of RunMove
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickMoveCopyWith<PickMove> get copyWith => _$PickMoveCopyWithImpl<PickMove>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickMove&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'RunMove.pick(id: $id)';
}


}

/// @nodoc
abstract mixin class $PickMoveCopyWith<$Res> implements $RunMoveCopyWith<$Res> {
  factory $PickMoveCopyWith(PickMove value, $Res Function(PickMove) _then) = _$PickMoveCopyWithImpl;
@useResult
$Res call({
 JokerId id
});




}
/// @nodoc
class _$PickMoveCopyWithImpl<$Res>
    implements $PickMoveCopyWith<$Res> {
  _$PickMoveCopyWithImpl(this._self, this._then);

  final PickMove _self;
  final $Res Function(PickMove) _then;

/// Create a copy of RunMove
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(PickMove(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as JokerId,
  ));
}


}

/// @nodoc


class PlaceMove implements RunMove {
  const PlaceMove({required this.anchor, required this.trayIndex});
  

 final  Cell anchor;
 final  int trayIndex;

/// Create a copy of RunMove
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceMoveCopyWith<PlaceMove> get copyWith => _$PlaceMoveCopyWithImpl<PlaceMove>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceMove&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.trayIndex, trayIndex) || other.trayIndex == trayIndex));
}


@override
int get hashCode => Object.hash(runtimeType,anchor,trayIndex);

@override
String toString() {
  return 'RunMove.place(anchor: $anchor, trayIndex: $trayIndex)';
}


}

/// @nodoc
abstract mixin class $PlaceMoveCopyWith<$Res> implements $RunMoveCopyWith<$Res> {
  factory $PlaceMoveCopyWith(PlaceMove value, $Res Function(PlaceMove) _then) = _$PlaceMoveCopyWithImpl;
@useResult
$Res call({
 Cell anchor, int trayIndex
});


$CellCopyWith<$Res> get anchor;

}
/// @nodoc
class _$PlaceMoveCopyWithImpl<$Res>
    implements $PlaceMoveCopyWith<$Res> {
  _$PlaceMoveCopyWithImpl(this._self, this._then);

  final PlaceMove _self;
  final $Res Function(PlaceMove) _then;

/// Create a copy of RunMove
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? anchor = null,Object? trayIndex = null,}) {
  return _then(PlaceMove(
anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Cell,trayIndex: null == trayIndex ? _self.trayIndex : trayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RunMove
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CellCopyWith<$Res> get anchor {
  
  return $CellCopyWith<$Res>(_self.anchor, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}

/// @nodoc


class ReviveMove implements RunMove {
  const ReviveMove();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviveMove);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunMove.revive()';
}


}




// dart format on
