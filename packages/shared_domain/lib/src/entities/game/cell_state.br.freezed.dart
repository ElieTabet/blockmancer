// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell_state.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CellState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CellState()';
}


}

/// @nodoc
class $CellStateCopyWith<$Res>  {
$CellStateCopyWith(CellState _, $Res Function(CellState) __);
}


/// Adds pattern-matching-related methods to [CellState].
extension CellStatePatterns on CellState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EmptyCell value)?  empty,TResult Function( FilledCell value)?  filled,TResult Function( FogCell value)?  fog,TResult Function( StoneCell value)?  stone,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EmptyCell() when empty != null:
return empty(_that);case FilledCell() when filled != null:
return filled(_that);case FogCell() when fog != null:
return fog(_that);case StoneCell() when stone != null:
return stone(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EmptyCell value)  empty,required TResult Function( FilledCell value)  filled,required TResult Function( FogCell value)  fog,required TResult Function( StoneCell value)  stone,}){
final _that = this;
switch (_that) {
case EmptyCell():
return empty(_that);case FilledCell():
return filled(_that);case FogCell():
return fog(_that);case StoneCell():
return stone(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EmptyCell value)?  empty,TResult? Function( FilledCell value)?  filled,TResult? Function( FogCell value)?  fog,TResult? Function( StoneCell value)?  stone,}){
final _that = this;
switch (_that) {
case EmptyCell() when empty != null:
return empty(_that);case FilledCell() when filled != null:
return filled(_that);case FogCell() when fog != null:
return fog(_that);case StoneCell() when stone != null:
return stone(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( int colorIndex)?  filled,TResult Function( bool hidesStone)?  fog,TResult Function()?  stone,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EmptyCell() when empty != null:
return empty();case FilledCell() when filled != null:
return filled(_that.colorIndex);case FogCell() when fog != null:
return fog(_that.hidesStone);case StoneCell() when stone != null:
return stone();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( int colorIndex)  filled,required TResult Function( bool hidesStone)  fog,required TResult Function()  stone,}) {final _that = this;
switch (_that) {
case EmptyCell():
return empty();case FilledCell():
return filled(_that.colorIndex);case FogCell():
return fog(_that.hidesStone);case StoneCell():
return stone();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( int colorIndex)?  filled,TResult? Function( bool hidesStone)?  fog,TResult? Function()?  stone,}) {final _that = this;
switch (_that) {
case EmptyCell() when empty != null:
return empty();case FilledCell() when filled != null:
return filled(_that.colorIndex);case FogCell() when fog != null:
return fog(_that.hidesStone);case StoneCell() when stone != null:
return stone();case _:
  return null;

}
}

}

/// @nodoc


class EmptyCell implements CellState {
  const EmptyCell();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyCell);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CellState.empty()';
}


}




/// @nodoc


class FilledCell implements CellState {
  const FilledCell({required this.colorIndex});
  

 final  int colorIndex;

/// Create a copy of CellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilledCellCopyWith<FilledCell> get copyWith => _$FilledCellCopyWithImpl<FilledCell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilledCell&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex));
}


@override
int get hashCode => Object.hash(runtimeType,colorIndex);

@override
String toString() {
  return 'CellState.filled(colorIndex: $colorIndex)';
}


}

/// @nodoc
abstract mixin class $FilledCellCopyWith<$Res> implements $CellStateCopyWith<$Res> {
  factory $FilledCellCopyWith(FilledCell value, $Res Function(FilledCell) _then) = _$FilledCellCopyWithImpl;
@useResult
$Res call({
 int colorIndex
});




}
/// @nodoc
class _$FilledCellCopyWithImpl<$Res>
    implements $FilledCellCopyWith<$Res> {
  _$FilledCellCopyWithImpl(this._self, this._then);

  final FilledCell _self;
  final $Res Function(FilledCell) _then;

/// Create a copy of CellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? colorIndex = null,}) {
  return _then(FilledCell(
colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class FogCell implements CellState {
  const FogCell({required this.hidesStone});
  

 final  bool hidesStone;

/// Create a copy of CellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FogCellCopyWith<FogCell> get copyWith => _$FogCellCopyWithImpl<FogCell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FogCell&&(identical(other.hidesStone, hidesStone) || other.hidesStone == hidesStone));
}


@override
int get hashCode => Object.hash(runtimeType,hidesStone);

@override
String toString() {
  return 'CellState.fog(hidesStone: $hidesStone)';
}


}

/// @nodoc
abstract mixin class $FogCellCopyWith<$Res> implements $CellStateCopyWith<$Res> {
  factory $FogCellCopyWith(FogCell value, $Res Function(FogCell) _then) = _$FogCellCopyWithImpl;
@useResult
$Res call({
 bool hidesStone
});




}
/// @nodoc
class _$FogCellCopyWithImpl<$Res>
    implements $FogCellCopyWith<$Res> {
  _$FogCellCopyWithImpl(this._self, this._then);

  final FogCell _self;
  final $Res Function(FogCell) _then;

/// Create a copy of CellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hidesStone = null,}) {
  return _then(FogCell(
hidesStone: null == hidesStone ? _self.hidesStone : hidesStone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StoneCell implements CellState {
  const StoneCell();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoneCell);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CellState.stone()';
}


}




// dart format on
