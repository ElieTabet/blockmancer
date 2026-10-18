// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joker_tuning.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokerTuning {

 int get anchorMult; int get avalancheChipsPerCell;/// The bottom rows whose filled cells Avalanche counts.
 int get avalancheRows; int get bigBoxFactor; int get bigBoxMinPieceSize; int get brinkFactor;/// Occupied cells, filled and stone, from which On the Brink fires.
 int get brinkMinOccupied; int get collectorMultPerJoker; int get columnFactor; int get comboMultPerStreak; int get emberFactor; int get finisherFactor;/// Occupied cells, filled and stone, per +1 mult from Full House.
 int get fullHouseCellsPerMult;/// The mult Full House adds per [fullHouseCellsPerMult] occupied cells.
 int get fullHouseMultPerBlock; int get hatTrickBonus; int get heavyFactor; int get heavyMinPieceSize; int get momentumMultPerTray; int get patienceStoredPerMove; int get pocketsExtraPieces; int get precisionBonusMult; int get precisionMaxPieceSize;/// Chips per occupied cell whose mirror cell is occupied too (Prism).
 int get prismChipsPerPair; int get quarryStonesPerClear; int get saverPointsPerPiece; int get sprinterMult; int get stonemasonChipsPerStone; int get stonemasonExtraStones; int get sweepBonus; int get symmetryMult; int get tinyFactor; int get tinyMaxPieceSize; int get twinFactor; int get twinMinLines;
/// Create a copy of JokerTuning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<JokerTuning> get copyWith => _$JokerTuningCopyWithImpl<JokerTuning>(this as JokerTuning, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerTuning&&(identical(other.anchorMult, anchorMult) || other.anchorMult == anchorMult)&&(identical(other.avalancheChipsPerCell, avalancheChipsPerCell) || other.avalancheChipsPerCell == avalancheChipsPerCell)&&(identical(other.avalancheRows, avalancheRows) || other.avalancheRows == avalancheRows)&&(identical(other.bigBoxFactor, bigBoxFactor) || other.bigBoxFactor == bigBoxFactor)&&(identical(other.bigBoxMinPieceSize, bigBoxMinPieceSize) || other.bigBoxMinPieceSize == bigBoxMinPieceSize)&&(identical(other.brinkFactor, brinkFactor) || other.brinkFactor == brinkFactor)&&(identical(other.brinkMinOccupied, brinkMinOccupied) || other.brinkMinOccupied == brinkMinOccupied)&&(identical(other.collectorMultPerJoker, collectorMultPerJoker) || other.collectorMultPerJoker == collectorMultPerJoker)&&(identical(other.columnFactor, columnFactor) || other.columnFactor == columnFactor)&&(identical(other.comboMultPerStreak, comboMultPerStreak) || other.comboMultPerStreak == comboMultPerStreak)&&(identical(other.emberFactor, emberFactor) || other.emberFactor == emberFactor)&&(identical(other.finisherFactor, finisherFactor) || other.finisherFactor == finisherFactor)&&(identical(other.fullHouseCellsPerMult, fullHouseCellsPerMult) || other.fullHouseCellsPerMult == fullHouseCellsPerMult)&&(identical(other.fullHouseMultPerBlock, fullHouseMultPerBlock) || other.fullHouseMultPerBlock == fullHouseMultPerBlock)&&(identical(other.hatTrickBonus, hatTrickBonus) || other.hatTrickBonus == hatTrickBonus)&&(identical(other.heavyFactor, heavyFactor) || other.heavyFactor == heavyFactor)&&(identical(other.heavyMinPieceSize, heavyMinPieceSize) || other.heavyMinPieceSize == heavyMinPieceSize)&&(identical(other.momentumMultPerTray, momentumMultPerTray) || other.momentumMultPerTray == momentumMultPerTray)&&(identical(other.patienceStoredPerMove, patienceStoredPerMove) || other.patienceStoredPerMove == patienceStoredPerMove)&&(identical(other.pocketsExtraPieces, pocketsExtraPieces) || other.pocketsExtraPieces == pocketsExtraPieces)&&(identical(other.precisionBonusMult, precisionBonusMult) || other.precisionBonusMult == precisionBonusMult)&&(identical(other.precisionMaxPieceSize, precisionMaxPieceSize) || other.precisionMaxPieceSize == precisionMaxPieceSize)&&(identical(other.prismChipsPerPair, prismChipsPerPair) || other.prismChipsPerPair == prismChipsPerPair)&&(identical(other.quarryStonesPerClear, quarryStonesPerClear) || other.quarryStonesPerClear == quarryStonesPerClear)&&(identical(other.saverPointsPerPiece, saverPointsPerPiece) || other.saverPointsPerPiece == saverPointsPerPiece)&&(identical(other.sprinterMult, sprinterMult) || other.sprinterMult == sprinterMult)&&(identical(other.stonemasonChipsPerStone, stonemasonChipsPerStone) || other.stonemasonChipsPerStone == stonemasonChipsPerStone)&&(identical(other.stonemasonExtraStones, stonemasonExtraStones) || other.stonemasonExtraStones == stonemasonExtraStones)&&(identical(other.sweepBonus, sweepBonus) || other.sweepBonus == sweepBonus)&&(identical(other.symmetryMult, symmetryMult) || other.symmetryMult == symmetryMult)&&(identical(other.tinyFactor, tinyFactor) || other.tinyFactor == tinyFactor)&&(identical(other.tinyMaxPieceSize, tinyMaxPieceSize) || other.tinyMaxPieceSize == tinyMaxPieceSize)&&(identical(other.twinFactor, twinFactor) || other.twinFactor == twinFactor)&&(identical(other.twinMinLines, twinMinLines) || other.twinMinLines == twinMinLines));
}


@override
int get hashCode => Object.hashAll([runtimeType,anchorMult,avalancheChipsPerCell,avalancheRows,bigBoxFactor,bigBoxMinPieceSize,brinkFactor,brinkMinOccupied,collectorMultPerJoker,columnFactor,comboMultPerStreak,emberFactor,finisherFactor,fullHouseCellsPerMult,fullHouseMultPerBlock,hatTrickBonus,heavyFactor,heavyMinPieceSize,momentumMultPerTray,patienceStoredPerMove,pocketsExtraPieces,precisionBonusMult,precisionMaxPieceSize,prismChipsPerPair,quarryStonesPerClear,saverPointsPerPiece,sprinterMult,stonemasonChipsPerStone,stonemasonExtraStones,sweepBonus,symmetryMult,tinyFactor,tinyMaxPieceSize,twinFactor,twinMinLines]);

@override
String toString() {
  return 'JokerTuning(anchorMult: $anchorMult, avalancheChipsPerCell: $avalancheChipsPerCell, avalancheRows: $avalancheRows, bigBoxFactor: $bigBoxFactor, bigBoxMinPieceSize: $bigBoxMinPieceSize, brinkFactor: $brinkFactor, brinkMinOccupied: $brinkMinOccupied, collectorMultPerJoker: $collectorMultPerJoker, columnFactor: $columnFactor, comboMultPerStreak: $comboMultPerStreak, emberFactor: $emberFactor, finisherFactor: $finisherFactor, fullHouseCellsPerMult: $fullHouseCellsPerMult, fullHouseMultPerBlock: $fullHouseMultPerBlock, hatTrickBonus: $hatTrickBonus, heavyFactor: $heavyFactor, heavyMinPieceSize: $heavyMinPieceSize, momentumMultPerTray: $momentumMultPerTray, patienceStoredPerMove: $patienceStoredPerMove, pocketsExtraPieces: $pocketsExtraPieces, precisionBonusMult: $precisionBonusMult, precisionMaxPieceSize: $precisionMaxPieceSize, prismChipsPerPair: $prismChipsPerPair, quarryStonesPerClear: $quarryStonesPerClear, saverPointsPerPiece: $saverPointsPerPiece, sprinterMult: $sprinterMult, stonemasonChipsPerStone: $stonemasonChipsPerStone, stonemasonExtraStones: $stonemasonExtraStones, sweepBonus: $sweepBonus, symmetryMult: $symmetryMult, tinyFactor: $tinyFactor, tinyMaxPieceSize: $tinyMaxPieceSize, twinFactor: $twinFactor, twinMinLines: $twinMinLines)';
}


}

/// @nodoc
abstract mixin class $JokerTuningCopyWith<$Res>  {
  factory $JokerTuningCopyWith(JokerTuning value, $Res Function(JokerTuning) _then) = _$JokerTuningCopyWithImpl;
@useResult
$Res call({
 int anchorMult, int avalancheChipsPerCell, int avalancheRows, int bigBoxFactor, int bigBoxMinPieceSize, int brinkFactor, int brinkMinOccupied, int collectorMultPerJoker, int columnFactor, int comboMultPerStreak, int emberFactor, int finisherFactor, int fullHouseCellsPerMult, int fullHouseMultPerBlock, int hatTrickBonus, int heavyFactor, int heavyMinPieceSize, int momentumMultPerTray, int patienceStoredPerMove, int pocketsExtraPieces, int precisionBonusMult, int precisionMaxPieceSize, int prismChipsPerPair, int quarryStonesPerClear, int saverPointsPerPiece, int sprinterMult, int stonemasonChipsPerStone, int stonemasonExtraStones, int sweepBonus, int symmetryMult, int tinyFactor, int tinyMaxPieceSize, int twinFactor, int twinMinLines
});




}
/// @nodoc
class _$JokerTuningCopyWithImpl<$Res>
    implements $JokerTuningCopyWith<$Res> {
  _$JokerTuningCopyWithImpl(this._self, this._then);

  final JokerTuning _self;
  final $Res Function(JokerTuning) _then;

/// Create a copy of JokerTuning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anchorMult = null,Object? avalancheChipsPerCell = null,Object? avalancheRows = null,Object? bigBoxFactor = null,Object? bigBoxMinPieceSize = null,Object? brinkFactor = null,Object? brinkMinOccupied = null,Object? collectorMultPerJoker = null,Object? columnFactor = null,Object? comboMultPerStreak = null,Object? emberFactor = null,Object? finisherFactor = null,Object? fullHouseCellsPerMult = null,Object? fullHouseMultPerBlock = null,Object? hatTrickBonus = null,Object? heavyFactor = null,Object? heavyMinPieceSize = null,Object? momentumMultPerTray = null,Object? patienceStoredPerMove = null,Object? pocketsExtraPieces = null,Object? precisionBonusMult = null,Object? precisionMaxPieceSize = null,Object? prismChipsPerPair = null,Object? quarryStonesPerClear = null,Object? saverPointsPerPiece = null,Object? sprinterMult = null,Object? stonemasonChipsPerStone = null,Object? stonemasonExtraStones = null,Object? sweepBonus = null,Object? symmetryMult = null,Object? tinyFactor = null,Object? tinyMaxPieceSize = null,Object? twinFactor = null,Object? twinMinLines = null,}) {
  return _then(_self.copyWith(
anchorMult: null == anchorMult ? _self.anchorMult : anchorMult // ignore: cast_nullable_to_non_nullable
as int,avalancheChipsPerCell: null == avalancheChipsPerCell ? _self.avalancheChipsPerCell : avalancheChipsPerCell // ignore: cast_nullable_to_non_nullable
as int,avalancheRows: null == avalancheRows ? _self.avalancheRows : avalancheRows // ignore: cast_nullable_to_non_nullable
as int,bigBoxFactor: null == bigBoxFactor ? _self.bigBoxFactor : bigBoxFactor // ignore: cast_nullable_to_non_nullable
as int,bigBoxMinPieceSize: null == bigBoxMinPieceSize ? _self.bigBoxMinPieceSize : bigBoxMinPieceSize // ignore: cast_nullable_to_non_nullable
as int,brinkFactor: null == brinkFactor ? _self.brinkFactor : brinkFactor // ignore: cast_nullable_to_non_nullable
as int,brinkMinOccupied: null == brinkMinOccupied ? _self.brinkMinOccupied : brinkMinOccupied // ignore: cast_nullable_to_non_nullable
as int,collectorMultPerJoker: null == collectorMultPerJoker ? _self.collectorMultPerJoker : collectorMultPerJoker // ignore: cast_nullable_to_non_nullable
as int,columnFactor: null == columnFactor ? _self.columnFactor : columnFactor // ignore: cast_nullable_to_non_nullable
as int,comboMultPerStreak: null == comboMultPerStreak ? _self.comboMultPerStreak : comboMultPerStreak // ignore: cast_nullable_to_non_nullable
as int,emberFactor: null == emberFactor ? _self.emberFactor : emberFactor // ignore: cast_nullable_to_non_nullable
as int,finisherFactor: null == finisherFactor ? _self.finisherFactor : finisherFactor // ignore: cast_nullable_to_non_nullable
as int,fullHouseCellsPerMult: null == fullHouseCellsPerMult ? _self.fullHouseCellsPerMult : fullHouseCellsPerMult // ignore: cast_nullable_to_non_nullable
as int,fullHouseMultPerBlock: null == fullHouseMultPerBlock ? _self.fullHouseMultPerBlock : fullHouseMultPerBlock // ignore: cast_nullable_to_non_nullable
as int,hatTrickBonus: null == hatTrickBonus ? _self.hatTrickBonus : hatTrickBonus // ignore: cast_nullable_to_non_nullable
as int,heavyFactor: null == heavyFactor ? _self.heavyFactor : heavyFactor // ignore: cast_nullable_to_non_nullable
as int,heavyMinPieceSize: null == heavyMinPieceSize ? _self.heavyMinPieceSize : heavyMinPieceSize // ignore: cast_nullable_to_non_nullable
as int,momentumMultPerTray: null == momentumMultPerTray ? _self.momentumMultPerTray : momentumMultPerTray // ignore: cast_nullable_to_non_nullable
as int,patienceStoredPerMove: null == patienceStoredPerMove ? _self.patienceStoredPerMove : patienceStoredPerMove // ignore: cast_nullable_to_non_nullable
as int,pocketsExtraPieces: null == pocketsExtraPieces ? _self.pocketsExtraPieces : pocketsExtraPieces // ignore: cast_nullable_to_non_nullable
as int,precisionBonusMult: null == precisionBonusMult ? _self.precisionBonusMult : precisionBonusMult // ignore: cast_nullable_to_non_nullable
as int,precisionMaxPieceSize: null == precisionMaxPieceSize ? _self.precisionMaxPieceSize : precisionMaxPieceSize // ignore: cast_nullable_to_non_nullable
as int,prismChipsPerPair: null == prismChipsPerPair ? _self.prismChipsPerPair : prismChipsPerPair // ignore: cast_nullable_to_non_nullable
as int,quarryStonesPerClear: null == quarryStonesPerClear ? _self.quarryStonesPerClear : quarryStonesPerClear // ignore: cast_nullable_to_non_nullable
as int,saverPointsPerPiece: null == saverPointsPerPiece ? _self.saverPointsPerPiece : saverPointsPerPiece // ignore: cast_nullable_to_non_nullable
as int,sprinterMult: null == sprinterMult ? _self.sprinterMult : sprinterMult // ignore: cast_nullable_to_non_nullable
as int,stonemasonChipsPerStone: null == stonemasonChipsPerStone ? _self.stonemasonChipsPerStone : stonemasonChipsPerStone // ignore: cast_nullable_to_non_nullable
as int,stonemasonExtraStones: null == stonemasonExtraStones ? _self.stonemasonExtraStones : stonemasonExtraStones // ignore: cast_nullable_to_non_nullable
as int,sweepBonus: null == sweepBonus ? _self.sweepBonus : sweepBonus // ignore: cast_nullable_to_non_nullable
as int,symmetryMult: null == symmetryMult ? _self.symmetryMult : symmetryMult // ignore: cast_nullable_to_non_nullable
as int,tinyFactor: null == tinyFactor ? _self.tinyFactor : tinyFactor // ignore: cast_nullable_to_non_nullable
as int,tinyMaxPieceSize: null == tinyMaxPieceSize ? _self.tinyMaxPieceSize : tinyMaxPieceSize // ignore: cast_nullable_to_non_nullable
as int,twinFactor: null == twinFactor ? _self.twinFactor : twinFactor // ignore: cast_nullable_to_non_nullable
as int,twinMinLines: null == twinMinLines ? _self.twinMinLines : twinMinLines // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JokerTuning].
extension JokerTuningPatterns on JokerTuning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokerTuning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokerTuning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokerTuning value)  $default,){
final _that = this;
switch (_that) {
case _JokerTuning():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokerTuning value)?  $default,){
final _that = this;
switch (_that) {
case _JokerTuning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int anchorMult,  int avalancheChipsPerCell,  int avalancheRows,  int bigBoxFactor,  int bigBoxMinPieceSize,  int brinkFactor,  int brinkMinOccupied,  int collectorMultPerJoker,  int columnFactor,  int comboMultPerStreak,  int emberFactor,  int finisherFactor,  int fullHouseCellsPerMult,  int fullHouseMultPerBlock,  int hatTrickBonus,  int heavyFactor,  int heavyMinPieceSize,  int momentumMultPerTray,  int patienceStoredPerMove,  int pocketsExtraPieces,  int precisionBonusMult,  int precisionMaxPieceSize,  int prismChipsPerPair,  int quarryStonesPerClear,  int saverPointsPerPiece,  int sprinterMult,  int stonemasonChipsPerStone,  int stonemasonExtraStones,  int sweepBonus,  int symmetryMult,  int tinyFactor,  int tinyMaxPieceSize,  int twinFactor,  int twinMinLines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokerTuning() when $default != null:
return $default(_that.anchorMult,_that.avalancheChipsPerCell,_that.avalancheRows,_that.bigBoxFactor,_that.bigBoxMinPieceSize,_that.brinkFactor,_that.brinkMinOccupied,_that.collectorMultPerJoker,_that.columnFactor,_that.comboMultPerStreak,_that.emberFactor,_that.finisherFactor,_that.fullHouseCellsPerMult,_that.fullHouseMultPerBlock,_that.hatTrickBonus,_that.heavyFactor,_that.heavyMinPieceSize,_that.momentumMultPerTray,_that.patienceStoredPerMove,_that.pocketsExtraPieces,_that.precisionBonusMult,_that.precisionMaxPieceSize,_that.prismChipsPerPair,_that.quarryStonesPerClear,_that.saverPointsPerPiece,_that.sprinterMult,_that.stonemasonChipsPerStone,_that.stonemasonExtraStones,_that.sweepBonus,_that.symmetryMult,_that.tinyFactor,_that.tinyMaxPieceSize,_that.twinFactor,_that.twinMinLines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int anchorMult,  int avalancheChipsPerCell,  int avalancheRows,  int bigBoxFactor,  int bigBoxMinPieceSize,  int brinkFactor,  int brinkMinOccupied,  int collectorMultPerJoker,  int columnFactor,  int comboMultPerStreak,  int emberFactor,  int finisherFactor,  int fullHouseCellsPerMult,  int fullHouseMultPerBlock,  int hatTrickBonus,  int heavyFactor,  int heavyMinPieceSize,  int momentumMultPerTray,  int patienceStoredPerMove,  int pocketsExtraPieces,  int precisionBonusMult,  int precisionMaxPieceSize,  int prismChipsPerPair,  int quarryStonesPerClear,  int saverPointsPerPiece,  int sprinterMult,  int stonemasonChipsPerStone,  int stonemasonExtraStones,  int sweepBonus,  int symmetryMult,  int tinyFactor,  int tinyMaxPieceSize,  int twinFactor,  int twinMinLines)  $default,) {final _that = this;
switch (_that) {
case _JokerTuning():
return $default(_that.anchorMult,_that.avalancheChipsPerCell,_that.avalancheRows,_that.bigBoxFactor,_that.bigBoxMinPieceSize,_that.brinkFactor,_that.brinkMinOccupied,_that.collectorMultPerJoker,_that.columnFactor,_that.comboMultPerStreak,_that.emberFactor,_that.finisherFactor,_that.fullHouseCellsPerMult,_that.fullHouseMultPerBlock,_that.hatTrickBonus,_that.heavyFactor,_that.heavyMinPieceSize,_that.momentumMultPerTray,_that.patienceStoredPerMove,_that.pocketsExtraPieces,_that.precisionBonusMult,_that.precisionMaxPieceSize,_that.prismChipsPerPair,_that.quarryStonesPerClear,_that.saverPointsPerPiece,_that.sprinterMult,_that.stonemasonChipsPerStone,_that.stonemasonExtraStones,_that.sweepBonus,_that.symmetryMult,_that.tinyFactor,_that.tinyMaxPieceSize,_that.twinFactor,_that.twinMinLines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int anchorMult,  int avalancheChipsPerCell,  int avalancheRows,  int bigBoxFactor,  int bigBoxMinPieceSize,  int brinkFactor,  int brinkMinOccupied,  int collectorMultPerJoker,  int columnFactor,  int comboMultPerStreak,  int emberFactor,  int finisherFactor,  int fullHouseCellsPerMult,  int fullHouseMultPerBlock,  int hatTrickBonus,  int heavyFactor,  int heavyMinPieceSize,  int momentumMultPerTray,  int patienceStoredPerMove,  int pocketsExtraPieces,  int precisionBonusMult,  int precisionMaxPieceSize,  int prismChipsPerPair,  int quarryStonesPerClear,  int saverPointsPerPiece,  int sprinterMult,  int stonemasonChipsPerStone,  int stonemasonExtraStones,  int sweepBonus,  int symmetryMult,  int tinyFactor,  int tinyMaxPieceSize,  int twinFactor,  int twinMinLines)?  $default,) {final _that = this;
switch (_that) {
case _JokerTuning() when $default != null:
return $default(_that.anchorMult,_that.avalancheChipsPerCell,_that.avalancheRows,_that.bigBoxFactor,_that.bigBoxMinPieceSize,_that.brinkFactor,_that.brinkMinOccupied,_that.collectorMultPerJoker,_that.columnFactor,_that.comboMultPerStreak,_that.emberFactor,_that.finisherFactor,_that.fullHouseCellsPerMult,_that.fullHouseMultPerBlock,_that.hatTrickBonus,_that.heavyFactor,_that.heavyMinPieceSize,_that.momentumMultPerTray,_that.patienceStoredPerMove,_that.pocketsExtraPieces,_that.precisionBonusMult,_that.precisionMaxPieceSize,_that.prismChipsPerPair,_that.quarryStonesPerClear,_that.saverPointsPerPiece,_that.sprinterMult,_that.stonemasonChipsPerStone,_that.stonemasonExtraStones,_that.sweepBonus,_that.symmetryMult,_that.tinyFactor,_that.tinyMaxPieceSize,_that.twinFactor,_that.twinMinLines);case _:
  return null;

}
}

}

/// @nodoc


class _JokerTuning implements JokerTuning {
  const _JokerTuning({required this.anchorMult, required this.avalancheChipsPerCell, required this.avalancheRows, required this.bigBoxFactor, required this.bigBoxMinPieceSize, required this.brinkFactor, required this.brinkMinOccupied, required this.collectorMultPerJoker, required this.columnFactor, required this.comboMultPerStreak, required this.emberFactor, required this.finisherFactor, required this.fullHouseCellsPerMult, required this.fullHouseMultPerBlock, required this.hatTrickBonus, required this.heavyFactor, required this.heavyMinPieceSize, required this.momentumMultPerTray, required this.patienceStoredPerMove, required this.pocketsExtraPieces, required this.precisionBonusMult, required this.precisionMaxPieceSize, required this.prismChipsPerPair, required this.quarryStonesPerClear, required this.saverPointsPerPiece, required this.sprinterMult, required this.stonemasonChipsPerStone, required this.stonemasonExtraStones, required this.sweepBonus, required this.symmetryMult, required this.tinyFactor, required this.tinyMaxPieceSize, required this.twinFactor, required this.twinMinLines});
  

@override final  int anchorMult;
@override final  int avalancheChipsPerCell;
/// The bottom rows whose filled cells Avalanche counts.
@override final  int avalancheRows;
@override final  int bigBoxFactor;
@override final  int bigBoxMinPieceSize;
@override final  int brinkFactor;
/// Occupied cells, filled and stone, from which On the Brink fires.
@override final  int brinkMinOccupied;
@override final  int collectorMultPerJoker;
@override final  int columnFactor;
@override final  int comboMultPerStreak;
@override final  int emberFactor;
@override final  int finisherFactor;
/// Occupied cells, filled and stone, per +1 mult from Full House.
@override final  int fullHouseCellsPerMult;
/// The mult Full House adds per [fullHouseCellsPerMult] occupied cells.
@override final  int fullHouseMultPerBlock;
@override final  int hatTrickBonus;
@override final  int heavyFactor;
@override final  int heavyMinPieceSize;
@override final  int momentumMultPerTray;
@override final  int patienceStoredPerMove;
@override final  int pocketsExtraPieces;
@override final  int precisionBonusMult;
@override final  int precisionMaxPieceSize;
/// Chips per occupied cell whose mirror cell is occupied too (Prism).
@override final  int prismChipsPerPair;
@override final  int quarryStonesPerClear;
@override final  int saverPointsPerPiece;
@override final  int sprinterMult;
@override final  int stonemasonChipsPerStone;
@override final  int stonemasonExtraStones;
@override final  int sweepBonus;
@override final  int symmetryMult;
@override final  int tinyFactor;
@override final  int tinyMaxPieceSize;
@override final  int twinFactor;
@override final  int twinMinLines;

/// Create a copy of JokerTuning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokerTuningCopyWith<_JokerTuning> get copyWith => __$JokerTuningCopyWithImpl<_JokerTuning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokerTuning&&(identical(other.anchorMult, anchorMult) || other.anchorMult == anchorMult)&&(identical(other.avalancheChipsPerCell, avalancheChipsPerCell) || other.avalancheChipsPerCell == avalancheChipsPerCell)&&(identical(other.avalancheRows, avalancheRows) || other.avalancheRows == avalancheRows)&&(identical(other.bigBoxFactor, bigBoxFactor) || other.bigBoxFactor == bigBoxFactor)&&(identical(other.bigBoxMinPieceSize, bigBoxMinPieceSize) || other.bigBoxMinPieceSize == bigBoxMinPieceSize)&&(identical(other.brinkFactor, brinkFactor) || other.brinkFactor == brinkFactor)&&(identical(other.brinkMinOccupied, brinkMinOccupied) || other.brinkMinOccupied == brinkMinOccupied)&&(identical(other.collectorMultPerJoker, collectorMultPerJoker) || other.collectorMultPerJoker == collectorMultPerJoker)&&(identical(other.columnFactor, columnFactor) || other.columnFactor == columnFactor)&&(identical(other.comboMultPerStreak, comboMultPerStreak) || other.comboMultPerStreak == comboMultPerStreak)&&(identical(other.emberFactor, emberFactor) || other.emberFactor == emberFactor)&&(identical(other.finisherFactor, finisherFactor) || other.finisherFactor == finisherFactor)&&(identical(other.fullHouseCellsPerMult, fullHouseCellsPerMult) || other.fullHouseCellsPerMult == fullHouseCellsPerMult)&&(identical(other.fullHouseMultPerBlock, fullHouseMultPerBlock) || other.fullHouseMultPerBlock == fullHouseMultPerBlock)&&(identical(other.hatTrickBonus, hatTrickBonus) || other.hatTrickBonus == hatTrickBonus)&&(identical(other.heavyFactor, heavyFactor) || other.heavyFactor == heavyFactor)&&(identical(other.heavyMinPieceSize, heavyMinPieceSize) || other.heavyMinPieceSize == heavyMinPieceSize)&&(identical(other.momentumMultPerTray, momentumMultPerTray) || other.momentumMultPerTray == momentumMultPerTray)&&(identical(other.patienceStoredPerMove, patienceStoredPerMove) || other.patienceStoredPerMove == patienceStoredPerMove)&&(identical(other.pocketsExtraPieces, pocketsExtraPieces) || other.pocketsExtraPieces == pocketsExtraPieces)&&(identical(other.precisionBonusMult, precisionBonusMult) || other.precisionBonusMult == precisionBonusMult)&&(identical(other.precisionMaxPieceSize, precisionMaxPieceSize) || other.precisionMaxPieceSize == precisionMaxPieceSize)&&(identical(other.prismChipsPerPair, prismChipsPerPair) || other.prismChipsPerPair == prismChipsPerPair)&&(identical(other.quarryStonesPerClear, quarryStonesPerClear) || other.quarryStonesPerClear == quarryStonesPerClear)&&(identical(other.saverPointsPerPiece, saverPointsPerPiece) || other.saverPointsPerPiece == saverPointsPerPiece)&&(identical(other.sprinterMult, sprinterMult) || other.sprinterMult == sprinterMult)&&(identical(other.stonemasonChipsPerStone, stonemasonChipsPerStone) || other.stonemasonChipsPerStone == stonemasonChipsPerStone)&&(identical(other.stonemasonExtraStones, stonemasonExtraStones) || other.stonemasonExtraStones == stonemasonExtraStones)&&(identical(other.sweepBonus, sweepBonus) || other.sweepBonus == sweepBonus)&&(identical(other.symmetryMult, symmetryMult) || other.symmetryMult == symmetryMult)&&(identical(other.tinyFactor, tinyFactor) || other.tinyFactor == tinyFactor)&&(identical(other.tinyMaxPieceSize, tinyMaxPieceSize) || other.tinyMaxPieceSize == tinyMaxPieceSize)&&(identical(other.twinFactor, twinFactor) || other.twinFactor == twinFactor)&&(identical(other.twinMinLines, twinMinLines) || other.twinMinLines == twinMinLines));
}


@override
int get hashCode => Object.hashAll([runtimeType,anchorMult,avalancheChipsPerCell,avalancheRows,bigBoxFactor,bigBoxMinPieceSize,brinkFactor,brinkMinOccupied,collectorMultPerJoker,columnFactor,comboMultPerStreak,emberFactor,finisherFactor,fullHouseCellsPerMult,fullHouseMultPerBlock,hatTrickBonus,heavyFactor,heavyMinPieceSize,momentumMultPerTray,patienceStoredPerMove,pocketsExtraPieces,precisionBonusMult,precisionMaxPieceSize,prismChipsPerPair,quarryStonesPerClear,saverPointsPerPiece,sprinterMult,stonemasonChipsPerStone,stonemasonExtraStones,sweepBonus,symmetryMult,tinyFactor,tinyMaxPieceSize,twinFactor,twinMinLines]);

@override
String toString() {
  return 'JokerTuning(anchorMult: $anchorMult, avalancheChipsPerCell: $avalancheChipsPerCell, avalancheRows: $avalancheRows, bigBoxFactor: $bigBoxFactor, bigBoxMinPieceSize: $bigBoxMinPieceSize, brinkFactor: $brinkFactor, brinkMinOccupied: $brinkMinOccupied, collectorMultPerJoker: $collectorMultPerJoker, columnFactor: $columnFactor, comboMultPerStreak: $comboMultPerStreak, emberFactor: $emberFactor, finisherFactor: $finisherFactor, fullHouseCellsPerMult: $fullHouseCellsPerMult, fullHouseMultPerBlock: $fullHouseMultPerBlock, hatTrickBonus: $hatTrickBonus, heavyFactor: $heavyFactor, heavyMinPieceSize: $heavyMinPieceSize, momentumMultPerTray: $momentumMultPerTray, patienceStoredPerMove: $patienceStoredPerMove, pocketsExtraPieces: $pocketsExtraPieces, precisionBonusMult: $precisionBonusMult, precisionMaxPieceSize: $precisionMaxPieceSize, prismChipsPerPair: $prismChipsPerPair, quarryStonesPerClear: $quarryStonesPerClear, saverPointsPerPiece: $saverPointsPerPiece, sprinterMult: $sprinterMult, stonemasonChipsPerStone: $stonemasonChipsPerStone, stonemasonExtraStones: $stonemasonExtraStones, sweepBonus: $sweepBonus, symmetryMult: $symmetryMult, tinyFactor: $tinyFactor, tinyMaxPieceSize: $tinyMaxPieceSize, twinFactor: $twinFactor, twinMinLines: $twinMinLines)';
}


}

/// @nodoc
abstract mixin class _$JokerTuningCopyWith<$Res> implements $JokerTuningCopyWith<$Res> {
  factory _$JokerTuningCopyWith(_JokerTuning value, $Res Function(_JokerTuning) _then) = __$JokerTuningCopyWithImpl;
@override @useResult
$Res call({
 int anchorMult, int avalancheChipsPerCell, int avalancheRows, int bigBoxFactor, int bigBoxMinPieceSize, int brinkFactor, int brinkMinOccupied, int collectorMultPerJoker, int columnFactor, int comboMultPerStreak, int emberFactor, int finisherFactor, int fullHouseCellsPerMult, int fullHouseMultPerBlock, int hatTrickBonus, int heavyFactor, int heavyMinPieceSize, int momentumMultPerTray, int patienceStoredPerMove, int pocketsExtraPieces, int precisionBonusMult, int precisionMaxPieceSize, int prismChipsPerPair, int quarryStonesPerClear, int saverPointsPerPiece, int sprinterMult, int stonemasonChipsPerStone, int stonemasonExtraStones, int sweepBonus, int symmetryMult, int tinyFactor, int tinyMaxPieceSize, int twinFactor, int twinMinLines
});




}
/// @nodoc
class __$JokerTuningCopyWithImpl<$Res>
    implements _$JokerTuningCopyWith<$Res> {
  __$JokerTuningCopyWithImpl(this._self, this._then);

  final _JokerTuning _self;
  final $Res Function(_JokerTuning) _then;

/// Create a copy of JokerTuning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anchorMult = null,Object? avalancheChipsPerCell = null,Object? avalancheRows = null,Object? bigBoxFactor = null,Object? bigBoxMinPieceSize = null,Object? brinkFactor = null,Object? brinkMinOccupied = null,Object? collectorMultPerJoker = null,Object? columnFactor = null,Object? comboMultPerStreak = null,Object? emberFactor = null,Object? finisherFactor = null,Object? fullHouseCellsPerMult = null,Object? fullHouseMultPerBlock = null,Object? hatTrickBonus = null,Object? heavyFactor = null,Object? heavyMinPieceSize = null,Object? momentumMultPerTray = null,Object? patienceStoredPerMove = null,Object? pocketsExtraPieces = null,Object? precisionBonusMult = null,Object? precisionMaxPieceSize = null,Object? prismChipsPerPair = null,Object? quarryStonesPerClear = null,Object? saverPointsPerPiece = null,Object? sprinterMult = null,Object? stonemasonChipsPerStone = null,Object? stonemasonExtraStones = null,Object? sweepBonus = null,Object? symmetryMult = null,Object? tinyFactor = null,Object? tinyMaxPieceSize = null,Object? twinFactor = null,Object? twinMinLines = null,}) {
  return _then(_JokerTuning(
anchorMult: null == anchorMult ? _self.anchorMult : anchorMult // ignore: cast_nullable_to_non_nullable
as int,avalancheChipsPerCell: null == avalancheChipsPerCell ? _self.avalancheChipsPerCell : avalancheChipsPerCell // ignore: cast_nullable_to_non_nullable
as int,avalancheRows: null == avalancheRows ? _self.avalancheRows : avalancheRows // ignore: cast_nullable_to_non_nullable
as int,bigBoxFactor: null == bigBoxFactor ? _self.bigBoxFactor : bigBoxFactor // ignore: cast_nullable_to_non_nullable
as int,bigBoxMinPieceSize: null == bigBoxMinPieceSize ? _self.bigBoxMinPieceSize : bigBoxMinPieceSize // ignore: cast_nullable_to_non_nullable
as int,brinkFactor: null == brinkFactor ? _self.brinkFactor : brinkFactor // ignore: cast_nullable_to_non_nullable
as int,brinkMinOccupied: null == brinkMinOccupied ? _self.brinkMinOccupied : brinkMinOccupied // ignore: cast_nullable_to_non_nullable
as int,collectorMultPerJoker: null == collectorMultPerJoker ? _self.collectorMultPerJoker : collectorMultPerJoker // ignore: cast_nullable_to_non_nullable
as int,columnFactor: null == columnFactor ? _self.columnFactor : columnFactor // ignore: cast_nullable_to_non_nullable
as int,comboMultPerStreak: null == comboMultPerStreak ? _self.comboMultPerStreak : comboMultPerStreak // ignore: cast_nullable_to_non_nullable
as int,emberFactor: null == emberFactor ? _self.emberFactor : emberFactor // ignore: cast_nullable_to_non_nullable
as int,finisherFactor: null == finisherFactor ? _self.finisherFactor : finisherFactor // ignore: cast_nullable_to_non_nullable
as int,fullHouseCellsPerMult: null == fullHouseCellsPerMult ? _self.fullHouseCellsPerMult : fullHouseCellsPerMult // ignore: cast_nullable_to_non_nullable
as int,fullHouseMultPerBlock: null == fullHouseMultPerBlock ? _self.fullHouseMultPerBlock : fullHouseMultPerBlock // ignore: cast_nullable_to_non_nullable
as int,hatTrickBonus: null == hatTrickBonus ? _self.hatTrickBonus : hatTrickBonus // ignore: cast_nullable_to_non_nullable
as int,heavyFactor: null == heavyFactor ? _self.heavyFactor : heavyFactor // ignore: cast_nullable_to_non_nullable
as int,heavyMinPieceSize: null == heavyMinPieceSize ? _self.heavyMinPieceSize : heavyMinPieceSize // ignore: cast_nullable_to_non_nullable
as int,momentumMultPerTray: null == momentumMultPerTray ? _self.momentumMultPerTray : momentumMultPerTray // ignore: cast_nullable_to_non_nullable
as int,patienceStoredPerMove: null == patienceStoredPerMove ? _self.patienceStoredPerMove : patienceStoredPerMove // ignore: cast_nullable_to_non_nullable
as int,pocketsExtraPieces: null == pocketsExtraPieces ? _self.pocketsExtraPieces : pocketsExtraPieces // ignore: cast_nullable_to_non_nullable
as int,precisionBonusMult: null == precisionBonusMult ? _self.precisionBonusMult : precisionBonusMult // ignore: cast_nullable_to_non_nullable
as int,precisionMaxPieceSize: null == precisionMaxPieceSize ? _self.precisionMaxPieceSize : precisionMaxPieceSize // ignore: cast_nullable_to_non_nullable
as int,prismChipsPerPair: null == prismChipsPerPair ? _self.prismChipsPerPair : prismChipsPerPair // ignore: cast_nullable_to_non_nullable
as int,quarryStonesPerClear: null == quarryStonesPerClear ? _self.quarryStonesPerClear : quarryStonesPerClear // ignore: cast_nullable_to_non_nullable
as int,saverPointsPerPiece: null == saverPointsPerPiece ? _self.saverPointsPerPiece : saverPointsPerPiece // ignore: cast_nullable_to_non_nullable
as int,sprinterMult: null == sprinterMult ? _self.sprinterMult : sprinterMult // ignore: cast_nullable_to_non_nullable
as int,stonemasonChipsPerStone: null == stonemasonChipsPerStone ? _self.stonemasonChipsPerStone : stonemasonChipsPerStone // ignore: cast_nullable_to_non_nullable
as int,stonemasonExtraStones: null == stonemasonExtraStones ? _self.stonemasonExtraStones : stonemasonExtraStones // ignore: cast_nullable_to_non_nullable
as int,sweepBonus: null == sweepBonus ? _self.sweepBonus : sweepBonus // ignore: cast_nullable_to_non_nullable
as int,symmetryMult: null == symmetryMult ? _self.symmetryMult : symmetryMult // ignore: cast_nullable_to_non_nullable
as int,tinyFactor: null == tinyFactor ? _self.tinyFactor : tinyFactor // ignore: cast_nullable_to_non_nullable
as int,tinyMaxPieceSize: null == tinyMaxPieceSize ? _self.tinyMaxPieceSize : tinyMaxPieceSize // ignore: cast_nullable_to_non_nullable
as int,twinFactor: null == twinFactor ? _self.twinFactor : twinFactor // ignore: cast_nullable_to_non_nullable
as int,twinMinLines: null == twinMinLines ? _self.twinMinLines : twinMinLines // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
