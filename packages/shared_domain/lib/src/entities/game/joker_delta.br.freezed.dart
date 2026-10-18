// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joker_delta.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokerDelta {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerDelta);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokerDelta()';
}


}

/// @nodoc
class $JokerDeltaCopyWith<$Res>  {
$JokerDeltaCopyWith(JokerDelta _, $Res Function(JokerDelta) __);
}


/// Adds pattern-matching-related methods to [JokerDelta].
extension JokerDeltaPatterns on JokerDelta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChipsAdded value)?  chipsAdded,TResult Function( MultAdded value)?  multAdded,TResult Function( MultMultiplied value)?  multMultiplied,TResult Function( MultStored value)?  multStored,TResult Function( ObstaclesRemoved value)?  obstaclesRemoved,TResult Function( PiecesAdded value)?  piecesAdded,TResult Function( PointsAdded value)?  pointsAdded,TResult Function( RunPointsAdded value)?  runPointsAdded,TResult Function( StoneDropped value)?  stoneDropped,TResult Function( StonesAdded value)?  stonesAdded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChipsAdded() when chipsAdded != null:
return chipsAdded(_that);case MultAdded() when multAdded != null:
return multAdded(_that);case MultMultiplied() when multMultiplied != null:
return multMultiplied(_that);case MultStored() when multStored != null:
return multStored(_that);case ObstaclesRemoved() when obstaclesRemoved != null:
return obstaclesRemoved(_that);case PiecesAdded() when piecesAdded != null:
return piecesAdded(_that);case PointsAdded() when pointsAdded != null:
return pointsAdded(_that);case RunPointsAdded() when runPointsAdded != null:
return runPointsAdded(_that);case StoneDropped() when stoneDropped != null:
return stoneDropped(_that);case StonesAdded() when stonesAdded != null:
return stonesAdded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChipsAdded value)  chipsAdded,required TResult Function( MultAdded value)  multAdded,required TResult Function( MultMultiplied value)  multMultiplied,required TResult Function( MultStored value)  multStored,required TResult Function( ObstaclesRemoved value)  obstaclesRemoved,required TResult Function( PiecesAdded value)  piecesAdded,required TResult Function( PointsAdded value)  pointsAdded,required TResult Function( RunPointsAdded value)  runPointsAdded,required TResult Function( StoneDropped value)  stoneDropped,required TResult Function( StonesAdded value)  stonesAdded,}){
final _that = this;
switch (_that) {
case ChipsAdded():
return chipsAdded(_that);case MultAdded():
return multAdded(_that);case MultMultiplied():
return multMultiplied(_that);case MultStored():
return multStored(_that);case ObstaclesRemoved():
return obstaclesRemoved(_that);case PiecesAdded():
return piecesAdded(_that);case PointsAdded():
return pointsAdded(_that);case RunPointsAdded():
return runPointsAdded(_that);case StoneDropped():
return stoneDropped(_that);case StonesAdded():
return stonesAdded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChipsAdded value)?  chipsAdded,TResult? Function( MultAdded value)?  multAdded,TResult? Function( MultMultiplied value)?  multMultiplied,TResult? Function( MultStored value)?  multStored,TResult? Function( ObstaclesRemoved value)?  obstaclesRemoved,TResult? Function( PiecesAdded value)?  piecesAdded,TResult? Function( PointsAdded value)?  pointsAdded,TResult? Function( RunPointsAdded value)?  runPointsAdded,TResult? Function( StoneDropped value)?  stoneDropped,TResult? Function( StonesAdded value)?  stonesAdded,}){
final _that = this;
switch (_that) {
case ChipsAdded() when chipsAdded != null:
return chipsAdded(_that);case MultAdded() when multAdded != null:
return multAdded(_that);case MultMultiplied() when multMultiplied != null:
return multMultiplied(_that);case MultStored() when multStored != null:
return multStored(_that);case ObstaclesRemoved() when obstaclesRemoved != null:
return obstaclesRemoved(_that);case PiecesAdded() when piecesAdded != null:
return piecesAdded(_that);case PointsAdded() when pointsAdded != null:
return pointsAdded(_that);case RunPointsAdded() when runPointsAdded != null:
return runPointsAdded(_that);case StoneDropped() when stoneDropped != null:
return stoneDropped(_that);case StonesAdded() when stonesAdded != null:
return stonesAdded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int amount)?  chipsAdded,TResult Function( int amount)?  multAdded,TResult Function( int factor)?  multMultiplied,TResult Function( int total)?  multStored,TResult Function( List<Cell> cells)?  obstaclesRemoved,TResult Function( int amount)?  piecesAdded,TResult Function( int amount)?  pointsAdded,TResult Function( int amount)?  runPointsAdded,TResult Function( Cell cell)?  stoneDropped,TResult Function( int amount)?  stonesAdded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChipsAdded() when chipsAdded != null:
return chipsAdded(_that.amount);case MultAdded() when multAdded != null:
return multAdded(_that.amount);case MultMultiplied() when multMultiplied != null:
return multMultiplied(_that.factor);case MultStored() when multStored != null:
return multStored(_that.total);case ObstaclesRemoved() when obstaclesRemoved != null:
return obstaclesRemoved(_that.cells);case PiecesAdded() when piecesAdded != null:
return piecesAdded(_that.amount);case PointsAdded() when pointsAdded != null:
return pointsAdded(_that.amount);case RunPointsAdded() when runPointsAdded != null:
return runPointsAdded(_that.amount);case StoneDropped() when stoneDropped != null:
return stoneDropped(_that.cell);case StonesAdded() when stonesAdded != null:
return stonesAdded(_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int amount)  chipsAdded,required TResult Function( int amount)  multAdded,required TResult Function( int factor)  multMultiplied,required TResult Function( int total)  multStored,required TResult Function( List<Cell> cells)  obstaclesRemoved,required TResult Function( int amount)  piecesAdded,required TResult Function( int amount)  pointsAdded,required TResult Function( int amount)  runPointsAdded,required TResult Function( Cell cell)  stoneDropped,required TResult Function( int amount)  stonesAdded,}) {final _that = this;
switch (_that) {
case ChipsAdded():
return chipsAdded(_that.amount);case MultAdded():
return multAdded(_that.amount);case MultMultiplied():
return multMultiplied(_that.factor);case MultStored():
return multStored(_that.total);case ObstaclesRemoved():
return obstaclesRemoved(_that.cells);case PiecesAdded():
return piecesAdded(_that.amount);case PointsAdded():
return pointsAdded(_that.amount);case RunPointsAdded():
return runPointsAdded(_that.amount);case StoneDropped():
return stoneDropped(_that.cell);case StonesAdded():
return stonesAdded(_that.amount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int amount)?  chipsAdded,TResult? Function( int amount)?  multAdded,TResult? Function( int factor)?  multMultiplied,TResult? Function( int total)?  multStored,TResult? Function( List<Cell> cells)?  obstaclesRemoved,TResult? Function( int amount)?  piecesAdded,TResult? Function( int amount)?  pointsAdded,TResult? Function( int amount)?  runPointsAdded,TResult? Function( Cell cell)?  stoneDropped,TResult? Function( int amount)?  stonesAdded,}) {final _that = this;
switch (_that) {
case ChipsAdded() when chipsAdded != null:
return chipsAdded(_that.amount);case MultAdded() when multAdded != null:
return multAdded(_that.amount);case MultMultiplied() when multMultiplied != null:
return multMultiplied(_that.factor);case MultStored() when multStored != null:
return multStored(_that.total);case ObstaclesRemoved() when obstaclesRemoved != null:
return obstaclesRemoved(_that.cells);case PiecesAdded() when piecesAdded != null:
return piecesAdded(_that.amount);case PointsAdded() when pointsAdded != null:
return pointsAdded(_that.amount);case RunPointsAdded() when runPointsAdded != null:
return runPointsAdded(_that.amount);case StoneDropped() when stoneDropped != null:
return stoneDropped(_that.cell);case StonesAdded() when stonesAdded != null:
return stonesAdded(_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class ChipsAdded implements JokerDelta {
  const ChipsAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChipsAddedCopyWith<ChipsAdded> get copyWith => _$ChipsAddedCopyWithImpl<ChipsAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChipsAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.chipsAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $ChipsAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $ChipsAddedCopyWith(ChipsAdded value, $Res Function(ChipsAdded) _then) = _$ChipsAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$ChipsAddedCopyWithImpl<$Res>
    implements $ChipsAddedCopyWith<$Res> {
  _$ChipsAddedCopyWithImpl(this._self, this._then);

  final ChipsAdded _self;
  final $Res Function(ChipsAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(ChipsAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MultAdded implements JokerDelta {
  const MultAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultAddedCopyWith<MultAdded> get copyWith => _$MultAddedCopyWithImpl<MultAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.multAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $MultAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $MultAddedCopyWith(MultAdded value, $Res Function(MultAdded) _then) = _$MultAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$MultAddedCopyWithImpl<$Res>
    implements $MultAddedCopyWith<$Res> {
  _$MultAddedCopyWithImpl(this._self, this._then);

  final MultAdded _self;
  final $Res Function(MultAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(MultAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MultMultiplied implements JokerDelta {
  const MultMultiplied({required this.factor});
  

 final  int factor;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultMultipliedCopyWith<MultMultiplied> get copyWith => _$MultMultipliedCopyWithImpl<MultMultiplied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultMultiplied&&(identical(other.factor, factor) || other.factor == factor));
}


@override
int get hashCode => Object.hash(runtimeType,factor);

@override
String toString() {
  return 'JokerDelta.multMultiplied(factor: $factor)';
}


}

/// @nodoc
abstract mixin class $MultMultipliedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $MultMultipliedCopyWith(MultMultiplied value, $Res Function(MultMultiplied) _then) = _$MultMultipliedCopyWithImpl;
@useResult
$Res call({
 int factor
});




}
/// @nodoc
class _$MultMultipliedCopyWithImpl<$Res>
    implements $MultMultipliedCopyWith<$Res> {
  _$MultMultipliedCopyWithImpl(this._self, this._then);

  final MultMultiplied _self;
  final $Res Function(MultMultiplied) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? factor = null,}) {
  return _then(MultMultiplied(
factor: null == factor ? _self.factor : factor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MultStored implements JokerDelta {
  const MultStored({required this.total});
  

 final  int total;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultStoredCopyWith<MultStored> get copyWith => _$MultStoredCopyWithImpl<MultStored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultStored&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,total);

@override
String toString() {
  return 'JokerDelta.multStored(total: $total)';
}


}

/// @nodoc
abstract mixin class $MultStoredCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $MultStoredCopyWith(MultStored value, $Res Function(MultStored) _then) = _$MultStoredCopyWithImpl;
@useResult
$Res call({
 int total
});




}
/// @nodoc
class _$MultStoredCopyWithImpl<$Res>
    implements $MultStoredCopyWith<$Res> {
  _$MultStoredCopyWithImpl(this._self, this._then);

  final MultStored _self;
  final $Res Function(MultStored) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? total = null,}) {
  return _then(MultStored(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ObstaclesRemoved implements JokerDelta {
  const ObstaclesRemoved({required final  List<Cell> cells}): _cells = cells;
  

 final  List<Cell> _cells;
 List<Cell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}


/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObstaclesRemovedCopyWith<ObstaclesRemoved> get copyWith => _$ObstaclesRemovedCopyWithImpl<ObstaclesRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObstaclesRemoved&&const DeepCollectionEquality().equals(other._cells, _cells));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells));

@override
String toString() {
  return 'JokerDelta.obstaclesRemoved(cells: $cells)';
}


}

/// @nodoc
abstract mixin class $ObstaclesRemovedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $ObstaclesRemovedCopyWith(ObstaclesRemoved value, $Res Function(ObstaclesRemoved) _then) = _$ObstaclesRemovedCopyWithImpl;
@useResult
$Res call({
 List<Cell> cells
});




}
/// @nodoc
class _$ObstaclesRemovedCopyWithImpl<$Res>
    implements $ObstaclesRemovedCopyWith<$Res> {
  _$ObstaclesRemovedCopyWithImpl(this._self, this._then);

  final ObstaclesRemoved _self;
  final $Res Function(ObstaclesRemoved) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cells = null,}) {
  return _then(ObstaclesRemoved(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,
  ));
}


}

/// @nodoc


class PiecesAdded implements JokerDelta {
  const PiecesAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PiecesAddedCopyWith<PiecesAdded> get copyWith => _$PiecesAddedCopyWithImpl<PiecesAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PiecesAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.piecesAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PiecesAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $PiecesAddedCopyWith(PiecesAdded value, $Res Function(PiecesAdded) _then) = _$PiecesAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$PiecesAddedCopyWithImpl<$Res>
    implements $PiecesAddedCopyWith<$Res> {
  _$PiecesAddedCopyWithImpl(this._self, this._then);

  final PiecesAdded _self;
  final $Res Function(PiecesAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(PiecesAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PointsAdded implements JokerDelta {
  const PointsAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsAddedCopyWith<PointsAdded> get copyWith => _$PointsAddedCopyWithImpl<PointsAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.pointsAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PointsAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $PointsAddedCopyWith(PointsAdded value, $Res Function(PointsAdded) _then) = _$PointsAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$PointsAddedCopyWithImpl<$Res>
    implements $PointsAddedCopyWith<$Res> {
  _$PointsAddedCopyWithImpl(this._self, this._then);

  final PointsAdded _self;
  final $Res Function(PointsAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(PointsAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RunPointsAdded implements JokerDelta {
  const RunPointsAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunPointsAddedCopyWith<RunPointsAdded> get copyWith => _$RunPointsAddedCopyWithImpl<RunPointsAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunPointsAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.runPointsAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $RunPointsAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $RunPointsAddedCopyWith(RunPointsAdded value, $Res Function(RunPointsAdded) _then) = _$RunPointsAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$RunPointsAddedCopyWithImpl<$Res>
    implements $RunPointsAddedCopyWith<$Res> {
  _$RunPointsAddedCopyWithImpl(this._self, this._then);

  final RunPointsAdded _self;
  final $Res Function(RunPointsAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(RunPointsAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class StoneDropped implements JokerDelta {
  const StoneDropped({required this.cell});
  

 final  Cell cell;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoneDroppedCopyWith<StoneDropped> get copyWith => _$StoneDroppedCopyWithImpl<StoneDropped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoneDropped&&(identical(other.cell, cell) || other.cell == cell));
}


@override
int get hashCode => Object.hash(runtimeType,cell);

@override
String toString() {
  return 'JokerDelta.stoneDropped(cell: $cell)';
}


}

/// @nodoc
abstract mixin class $StoneDroppedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $StoneDroppedCopyWith(StoneDropped value, $Res Function(StoneDropped) _then) = _$StoneDroppedCopyWithImpl;
@useResult
$Res call({
 Cell cell
});


$CellCopyWith<$Res> get cell;

}
/// @nodoc
class _$StoneDroppedCopyWithImpl<$Res>
    implements $StoneDroppedCopyWith<$Res> {
  _$StoneDroppedCopyWithImpl(this._self, this._then);

  final StoneDropped _self;
  final $Res Function(StoneDropped) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cell = null,}) {
  return _then(StoneDropped(
cell: null == cell ? _self.cell : cell // ignore: cast_nullable_to_non_nullable
as Cell,
  ));
}

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CellCopyWith<$Res> get cell {
  
  return $CellCopyWith<$Res>(_self.cell, (value) {
    return _then(_self.copyWith(cell: value));
  });
}
}

/// @nodoc


class StonesAdded implements JokerDelta {
  const StonesAdded({required this.amount});
  

 final  int amount;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StonesAddedCopyWith<StonesAdded> get copyWith => _$StonesAddedCopyWithImpl<StonesAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StonesAdded&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'JokerDelta.stonesAdded(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $StonesAddedCopyWith<$Res> implements $JokerDeltaCopyWith<$Res> {
  factory $StonesAddedCopyWith(StonesAdded value, $Res Function(StonesAdded) _then) = _$StonesAddedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class _$StonesAddedCopyWithImpl<$Res>
    implements $StonesAddedCopyWith<$Res> {
  _$StonesAddedCopyWithImpl(this._self, this._then);

  final StonesAdded _self;
  final $Res Function(StonesAdded) _then;

/// Create a copy of JokerDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(StonesAdded(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
