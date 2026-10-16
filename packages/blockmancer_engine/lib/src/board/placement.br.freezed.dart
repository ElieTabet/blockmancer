// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'placement.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClearResult {

 Board get board;/// Distinct cells, row-major: where a row and a column cross, the shared
/// cell is here once.
 List<Cell> get cells; List<int> get cols; List<int> get rows; int get stonesCleared;
/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClearResultCopyWith<ClearResult> get copyWith => _$ClearResultCopyWithImpl<ClearResult>(this as ClearResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearResult&&(identical(other.board, board) || other.board == board)&&const DeepCollectionEquality().equals(other.cells, cells)&&const DeepCollectionEquality().equals(other.cols, cols)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.stonesCleared, stonesCleared) || other.stonesCleared == stonesCleared));
}


@override
int get hashCode => Object.hash(runtimeType,board,const DeepCollectionEquality().hash(cells),const DeepCollectionEquality().hash(cols),const DeepCollectionEquality().hash(rows),stonesCleared);

@override
String toString() {
  return 'ClearResult(board: $board, cells: $cells, cols: $cols, rows: $rows, stonesCleared: $stonesCleared)';
}


}

/// @nodoc
abstract mixin class $ClearResultCopyWith<$Res>  {
  factory $ClearResultCopyWith(ClearResult value, $Res Function(ClearResult) _then) = _$ClearResultCopyWithImpl;
@useResult
$Res call({
 Board board, List<Cell> cells, List<int> cols, List<int> rows, int stonesCleared
});


$BoardCopyWith<$Res> get board;

}
/// @nodoc
class _$ClearResultCopyWithImpl<$Res>
    implements $ClearResultCopyWith<$Res> {
  _$ClearResultCopyWithImpl(this._self, this._then);

  final ClearResult _self;
  final $Res Function(ClearResult) _then;

/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? cells = null,Object? cols = null,Object? rows = null,Object? stonesCleared = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,cols: null == cols ? _self.cols : cols // ignore: cast_nullable_to_non_nullable
as List<int>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<int>,stonesCleared: null == stonesCleared ? _self.stonesCleared : stonesCleared // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res> get board {
  
  return $BoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClearResult].
extension ClearResultPatterns on ClearResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClearResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClearResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClearResult value)  $default,){
final _that = this;
switch (_that) {
case _ClearResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClearResult value)?  $default,){
final _that = this;
switch (_that) {
case _ClearResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Board board,  List<Cell> cells,  List<int> cols,  List<int> rows,  int stonesCleared)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClearResult() when $default != null:
return $default(_that.board,_that.cells,_that.cols,_that.rows,_that.stonesCleared);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Board board,  List<Cell> cells,  List<int> cols,  List<int> rows,  int stonesCleared)  $default,) {final _that = this;
switch (_that) {
case _ClearResult():
return $default(_that.board,_that.cells,_that.cols,_that.rows,_that.stonesCleared);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Board board,  List<Cell> cells,  List<int> cols,  List<int> rows,  int stonesCleared)?  $default,) {final _that = this;
switch (_that) {
case _ClearResult() when $default != null:
return $default(_that.board,_that.cells,_that.cols,_that.rows,_that.stonesCleared);case _:
  return null;

}
}

}

/// @nodoc


class _ClearResult extends ClearResult {
  const _ClearResult({required this.board, required final  List<Cell> cells, required final  List<int> cols, required final  List<int> rows, required this.stonesCleared}): _cells = cells,_cols = cols,_rows = rows,super._();
  

@override final  Board board;
/// Distinct cells, row-major: where a row and a column cross, the shared
/// cell is here once.
 final  List<Cell> _cells;
/// Distinct cells, row-major: where a row and a column cross, the shared
/// cell is here once.
@override List<Cell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

 final  List<int> _cols;
@override List<int> get cols {
  if (_cols is EqualUnmodifiableListView) return _cols;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cols);
}

 final  List<int> _rows;
@override List<int> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  int stonesCleared;

/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClearResultCopyWith<_ClearResult> get copyWith => __$ClearResultCopyWithImpl<_ClearResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearResult&&(identical(other.board, board) || other.board == board)&&const DeepCollectionEquality().equals(other._cells, _cells)&&const DeepCollectionEquality().equals(other._cols, _cols)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.stonesCleared, stonesCleared) || other.stonesCleared == stonesCleared));
}


@override
int get hashCode => Object.hash(runtimeType,board,const DeepCollectionEquality().hash(_cells),const DeepCollectionEquality().hash(_cols),const DeepCollectionEquality().hash(_rows),stonesCleared);

@override
String toString() {
  return 'ClearResult(board: $board, cells: $cells, cols: $cols, rows: $rows, stonesCleared: $stonesCleared)';
}


}

/// @nodoc
abstract mixin class _$ClearResultCopyWith<$Res> implements $ClearResultCopyWith<$Res> {
  factory _$ClearResultCopyWith(_ClearResult value, $Res Function(_ClearResult) _then) = __$ClearResultCopyWithImpl;
@override @useResult
$Res call({
 Board board, List<Cell> cells, List<int> cols, List<int> rows, int stonesCleared
});


@override $BoardCopyWith<$Res> get board;

}
/// @nodoc
class __$ClearResultCopyWithImpl<$Res>
    implements _$ClearResultCopyWith<$Res> {
  __$ClearResultCopyWithImpl(this._self, this._then);

  final _ClearResult _self;
  final $Res Function(_ClearResult) _then;

/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? cells = null,Object? cols = null,Object? rows = null,Object? stonesCleared = null,}) {
  return _then(_ClearResult(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,cols: null == cols ? _self._cols : cols // ignore: cast_nullable_to_non_nullable
as List<int>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<int>,stonesCleared: null == stonesCleared ? _self.stonesCleared : stonesCleared // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ClearResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res> get board {
  
  return $BoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}

// dart format on
