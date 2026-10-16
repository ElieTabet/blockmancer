// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drag_preview.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DragPreview {

/// `null` while the piece is off the board.
 Cell? get anchor; int get colorIndex; PlacementPreview get preview; int get trayIndex;
/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DragPreviewCopyWith<DragPreview> get copyWith => _$DragPreviewCopyWithImpl<DragPreview>(this as DragPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragPreview&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.trayIndex, trayIndex) || other.trayIndex == trayIndex));
}


@override
int get hashCode => Object.hash(runtimeType,anchor,colorIndex,preview,trayIndex);

@override
String toString() {
  return 'DragPreview(anchor: $anchor, colorIndex: $colorIndex, preview: $preview, trayIndex: $trayIndex)';
}


}

/// @nodoc
abstract mixin class $DragPreviewCopyWith<$Res>  {
  factory $DragPreviewCopyWith(DragPreview value, $Res Function(DragPreview) _then) = _$DragPreviewCopyWithImpl;
@useResult
$Res call({
 Cell? anchor, int colorIndex, PlacementPreview preview, int trayIndex
});


$CellCopyWith<$Res>? get anchor;$PlacementPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class _$DragPreviewCopyWithImpl<$Res>
    implements $DragPreviewCopyWith<$Res> {
  _$DragPreviewCopyWithImpl(this._self, this._then);

  final DragPreview _self;
  final $Res Function(DragPreview) _then;

/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anchor = freezed,Object? colorIndex = null,Object? preview = null,Object? trayIndex = null,}) {
  return _then(_self.copyWith(
anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Cell?,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as PlacementPreview,trayIndex: null == trayIndex ? _self.trayIndex : trayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CellCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $CellCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementPreviewCopyWith<$Res> get preview {
  
  return $PlacementPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [DragPreview].
extension DragPreviewPatterns on DragPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DragPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DragPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DragPreview value)  $default,){
final _that = this;
switch (_that) {
case _DragPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DragPreview value)?  $default,){
final _that = this;
switch (_that) {
case _DragPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Cell? anchor,  int colorIndex,  PlacementPreview preview,  int trayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DragPreview() when $default != null:
return $default(_that.anchor,_that.colorIndex,_that.preview,_that.trayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Cell? anchor,  int colorIndex,  PlacementPreview preview,  int trayIndex)  $default,) {final _that = this;
switch (_that) {
case _DragPreview():
return $default(_that.anchor,_that.colorIndex,_that.preview,_that.trayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Cell? anchor,  int colorIndex,  PlacementPreview preview,  int trayIndex)?  $default,) {final _that = this;
switch (_that) {
case _DragPreview() when $default != null:
return $default(_that.anchor,_that.colorIndex,_that.preview,_that.trayIndex);case _:
  return null;

}
}

}

/// @nodoc


class _DragPreview implements DragPreview {
  const _DragPreview({required this.anchor, required this.colorIndex, required this.preview, required this.trayIndex});
  

/// `null` while the piece is off the board.
@override final  Cell? anchor;
@override final  int colorIndex;
@override final  PlacementPreview preview;
@override final  int trayIndex;

/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DragPreviewCopyWith<_DragPreview> get copyWith => __$DragPreviewCopyWithImpl<_DragPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DragPreview&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.trayIndex, trayIndex) || other.trayIndex == trayIndex));
}


@override
int get hashCode => Object.hash(runtimeType,anchor,colorIndex,preview,trayIndex);

@override
String toString() {
  return 'DragPreview(anchor: $anchor, colorIndex: $colorIndex, preview: $preview, trayIndex: $trayIndex)';
}


}

/// @nodoc
abstract mixin class _$DragPreviewCopyWith<$Res> implements $DragPreviewCopyWith<$Res> {
  factory _$DragPreviewCopyWith(_DragPreview value, $Res Function(_DragPreview) _then) = __$DragPreviewCopyWithImpl;
@override @useResult
$Res call({
 Cell? anchor, int colorIndex, PlacementPreview preview, int trayIndex
});


@override $CellCopyWith<$Res>? get anchor;@override $PlacementPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class __$DragPreviewCopyWithImpl<$Res>
    implements _$DragPreviewCopyWith<$Res> {
  __$DragPreviewCopyWithImpl(this._self, this._then);

  final _DragPreview _self;
  final $Res Function(_DragPreview) _then;

/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anchor = freezed,Object? colorIndex = null,Object? preview = null,Object? trayIndex = null,}) {
  return _then(_DragPreview(
anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Cell?,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as PlacementPreview,trayIndex: null == trayIndex ? _self.trayIndex : trayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CellCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $CellCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}/// Create a copy of DragPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementPreviewCopyWith<$Res> get preview {
  
  return $PlacementPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

// dart format on
