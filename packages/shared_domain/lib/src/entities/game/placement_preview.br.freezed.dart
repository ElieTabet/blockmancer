// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'placement_preview.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlacementPreview {

/// The piece's cells that land inside the board.
 List<Cell> get cells;/// Only when [fits].
 List<int> get clearingCols; List<int> get clearingRows;/// Piece cells over a filled cell or a stone.
 List<Cell> get colliding; bool get fits;
/// Create a copy of PlacementPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementPreviewCopyWith<PlacementPreview> get copyWith => _$PlacementPreviewCopyWithImpl<PlacementPreview>(this as PlacementPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementPreview&&const DeepCollectionEquality().equals(other.cells, cells)&&const DeepCollectionEquality().equals(other.clearingCols, clearingCols)&&const DeepCollectionEquality().equals(other.clearingRows, clearingRows)&&const DeepCollectionEquality().equals(other.colliding, colliding)&&(identical(other.fits, fits) || other.fits == fits));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cells),const DeepCollectionEquality().hash(clearingCols),const DeepCollectionEquality().hash(clearingRows),const DeepCollectionEquality().hash(colliding),fits);

@override
String toString() {
  return 'PlacementPreview(cells: $cells, clearingCols: $clearingCols, clearingRows: $clearingRows, colliding: $colliding, fits: $fits)';
}


}

/// @nodoc
abstract mixin class $PlacementPreviewCopyWith<$Res>  {
  factory $PlacementPreviewCopyWith(PlacementPreview value, $Res Function(PlacementPreview) _then) = _$PlacementPreviewCopyWithImpl;
@useResult
$Res call({
 List<Cell> cells, List<int> clearingCols, List<int> clearingRows, List<Cell> colliding, bool fits
});




}
/// @nodoc
class _$PlacementPreviewCopyWithImpl<$Res>
    implements $PlacementPreviewCopyWith<$Res> {
  _$PlacementPreviewCopyWithImpl(this._self, this._then);

  final PlacementPreview _self;
  final $Res Function(PlacementPreview) _then;

/// Create a copy of PlacementPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cells = null,Object? clearingCols = null,Object? clearingRows = null,Object? colliding = null,Object? fits = null,}) {
  return _then(_self.copyWith(
cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,clearingCols: null == clearingCols ? _self.clearingCols : clearingCols // ignore: cast_nullable_to_non_nullable
as List<int>,clearingRows: null == clearingRows ? _self.clearingRows : clearingRows // ignore: cast_nullable_to_non_nullable
as List<int>,colliding: null == colliding ? _self.colliding : colliding // ignore: cast_nullable_to_non_nullable
as List<Cell>,fits: null == fits ? _self.fits : fits // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlacementPreview].
extension PlacementPreviewPatterns on PlacementPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementPreview value)  $default,){
final _that = this;
switch (_that) {
case _PlacementPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementPreview value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Cell> cells,  List<int> clearingCols,  List<int> clearingRows,  List<Cell> colliding,  bool fits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementPreview() when $default != null:
return $default(_that.cells,_that.clearingCols,_that.clearingRows,_that.colliding,_that.fits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Cell> cells,  List<int> clearingCols,  List<int> clearingRows,  List<Cell> colliding,  bool fits)  $default,) {final _that = this;
switch (_that) {
case _PlacementPreview():
return $default(_that.cells,_that.clearingCols,_that.clearingRows,_that.colliding,_that.fits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Cell> cells,  List<int> clearingCols,  List<int> clearingRows,  List<Cell> colliding,  bool fits)?  $default,) {final _that = this;
switch (_that) {
case _PlacementPreview() when $default != null:
return $default(_that.cells,_that.clearingCols,_that.clearingRows,_that.colliding,_that.fits);case _:
  return null;

}
}

}

/// @nodoc


class _PlacementPreview implements PlacementPreview {
  const _PlacementPreview({required final  List<Cell> cells, required final  List<int> clearingCols, required final  List<int> clearingRows, required final  List<Cell> colliding, required this.fits}): _cells = cells,_clearingCols = clearingCols,_clearingRows = clearingRows,_colliding = colliding;
  

/// The piece's cells that land inside the board.
 final  List<Cell> _cells;
/// The piece's cells that land inside the board.
@override List<Cell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

/// Only when [fits].
 final  List<int> _clearingCols;
/// Only when [fits].
@override List<int> get clearingCols {
  if (_clearingCols is EqualUnmodifiableListView) return _clearingCols;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clearingCols);
}

 final  List<int> _clearingRows;
@override List<int> get clearingRows {
  if (_clearingRows is EqualUnmodifiableListView) return _clearingRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clearingRows);
}

/// Piece cells over a filled cell or a stone.
 final  List<Cell> _colliding;
/// Piece cells over a filled cell or a stone.
@override List<Cell> get colliding {
  if (_colliding is EqualUnmodifiableListView) return _colliding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colliding);
}

@override final  bool fits;

/// Create a copy of PlacementPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementPreviewCopyWith<_PlacementPreview> get copyWith => __$PlacementPreviewCopyWithImpl<_PlacementPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementPreview&&const DeepCollectionEquality().equals(other._cells, _cells)&&const DeepCollectionEquality().equals(other._clearingCols, _clearingCols)&&const DeepCollectionEquality().equals(other._clearingRows, _clearingRows)&&const DeepCollectionEquality().equals(other._colliding, _colliding)&&(identical(other.fits, fits) || other.fits == fits));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells),const DeepCollectionEquality().hash(_clearingCols),const DeepCollectionEquality().hash(_clearingRows),const DeepCollectionEquality().hash(_colliding),fits);

@override
String toString() {
  return 'PlacementPreview(cells: $cells, clearingCols: $clearingCols, clearingRows: $clearingRows, colliding: $colliding, fits: $fits)';
}


}

/// @nodoc
abstract mixin class _$PlacementPreviewCopyWith<$Res> implements $PlacementPreviewCopyWith<$Res> {
  factory _$PlacementPreviewCopyWith(_PlacementPreview value, $Res Function(_PlacementPreview) _then) = __$PlacementPreviewCopyWithImpl;
@override @useResult
$Res call({
 List<Cell> cells, List<int> clearingCols, List<int> clearingRows, List<Cell> colliding, bool fits
});




}
/// @nodoc
class __$PlacementPreviewCopyWithImpl<$Res>
    implements _$PlacementPreviewCopyWith<$Res> {
  __$PlacementPreviewCopyWithImpl(this._self, this._then);

  final _PlacementPreview _self;
  final $Res Function(_PlacementPreview) _then;

/// Create a copy of PlacementPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,Object? clearingCols = null,Object? clearingRows = null,Object? colliding = null,Object? fits = null,}) {
  return _then(_PlacementPreview(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,clearingCols: null == clearingCols ? _self._clearingCols : clearingCols // ignore: cast_nullable_to_non_nullable
as List<int>,clearingRows: null == clearingRows ? _self._clearingRows : clearingRows // ignore: cast_nullable_to_non_nullable
as List<int>,colliding: null == colliding ? _self._colliding : colliding // ignore: cast_nullable_to_non_nullable
as List<Cell>,fits: null == fits ? _self.fits : fits // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
