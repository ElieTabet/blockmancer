// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beat.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Beat {

 Duration get duration;
/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeatCopyWith<Beat> get copyWith => _$BeatCopyWithImpl<Beat>(this as Beat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Beat&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,duration);

@override
String toString() {
  return 'Beat(duration: $duration)';
}


}

/// @nodoc
abstract mixin class $BeatCopyWith<$Res>  {
  factory $BeatCopyWith(Beat value, $Res Function(Beat) _then) = _$BeatCopyWithImpl;
@useResult
$Res call({
 Duration duration
});




}
/// @nodoc
class _$BeatCopyWithImpl<$Res>
    implements $BeatCopyWith<$Res> {
  _$BeatCopyWithImpl(this._self, this._then);

  final Beat _self;
  final $Res Function(Beat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [Beat].
extension BeatPatterns on Beat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ClearingBeat value)?  clearing,TResult Function( ComboBeat value)?  combo,TResult Function( CountingChipsBeat value)?  countingChips,TResult Function( CountingMultBeat value)?  countingMult,TResult Function( JokerPulseBeat value)?  jokerPulse,TResult Function( LandingBeat value)?  landing,TResult Function( PlacingBeat value)?  placing,TResult Function( PointsBeat value)?  points,TResult Function( ProductBeat value)?  product,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ClearingBeat() when clearing != null:
return clearing(_that);case ComboBeat() when combo != null:
return combo(_that);case CountingChipsBeat() when countingChips != null:
return countingChips(_that);case CountingMultBeat() when countingMult != null:
return countingMult(_that);case JokerPulseBeat() when jokerPulse != null:
return jokerPulse(_that);case LandingBeat() when landing != null:
return landing(_that);case PlacingBeat() when placing != null:
return placing(_that);case PointsBeat() when points != null:
return points(_that);case ProductBeat() when product != null:
return product(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ClearingBeat value)  clearing,required TResult Function( ComboBeat value)  combo,required TResult Function( CountingChipsBeat value)  countingChips,required TResult Function( CountingMultBeat value)  countingMult,required TResult Function( JokerPulseBeat value)  jokerPulse,required TResult Function( LandingBeat value)  landing,required TResult Function( PlacingBeat value)  placing,required TResult Function( PointsBeat value)  points,required TResult Function( ProductBeat value)  product,}){
final _that = this;
switch (_that) {
case ClearingBeat():
return clearing(_that);case ComboBeat():
return combo(_that);case CountingChipsBeat():
return countingChips(_that);case CountingMultBeat():
return countingMult(_that);case JokerPulseBeat():
return jokerPulse(_that);case LandingBeat():
return landing(_that);case PlacingBeat():
return placing(_that);case PointsBeat():
return points(_that);case ProductBeat():
return product(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ClearingBeat value)?  clearing,TResult? Function( ComboBeat value)?  combo,TResult? Function( CountingChipsBeat value)?  countingChips,TResult? Function( CountingMultBeat value)?  countingMult,TResult? Function( JokerPulseBeat value)?  jokerPulse,TResult? Function( LandingBeat value)?  landing,TResult? Function( PlacingBeat value)?  placing,TResult? Function( PointsBeat value)?  points,TResult? Function( ProductBeat value)?  product,}){
final _that = this;
switch (_that) {
case ClearingBeat() when clearing != null:
return clearing(_that);case ComboBeat() when combo != null:
return combo(_that);case CountingChipsBeat() when countingChips != null:
return countingChips(_that);case CountingMultBeat() when countingMult != null:
return countingMult(_that);case JokerPulseBeat() when jokerPulse != null:
return jokerPulse(_that);case LandingBeat() when landing != null:
return landing(_that);case PlacingBeat() when placing != null:
return placing(_that);case PointsBeat() when points != null:
return points(_that);case ProductBeat() when product != null:
return product(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<ClearedCell> cells,  Duration duration,  Shake shake)?  clearing,TResult Function( Duration duration,  int streak)?  combo,TResult Function( int chips,  Duration duration)?  countingChips,TResult Function( Duration duration,  int mult)?  countingMult,TResult Function( JokerDelta delta,  Duration duration,  JokerId joker)?  jokerPulse,TResult Function( Duration countUp,  Duration duration,  int score,  Shake shake)?  landing,TResult Function( List<Cell> cells,  List<ClearedCell> clearing,  int colorIndex,  Duration duration,  Shake shake)?  placing,TResult Function( Duration duration,  int points)?  points,TResult Function( int bonus,  Duration duration,  int lineScore)?  product,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ClearingBeat() when clearing != null:
return clearing(_that.cells,_that.duration,_that.shake);case ComboBeat() when combo != null:
return combo(_that.duration,_that.streak);case CountingChipsBeat() when countingChips != null:
return countingChips(_that.chips,_that.duration);case CountingMultBeat() when countingMult != null:
return countingMult(_that.duration,_that.mult);case JokerPulseBeat() when jokerPulse != null:
return jokerPulse(_that.delta,_that.duration,_that.joker);case LandingBeat() when landing != null:
return landing(_that.countUp,_that.duration,_that.score,_that.shake);case PlacingBeat() when placing != null:
return placing(_that.cells,_that.clearing,_that.colorIndex,_that.duration,_that.shake);case PointsBeat() when points != null:
return points(_that.duration,_that.points);case ProductBeat() when product != null:
return product(_that.bonus,_that.duration,_that.lineScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<ClearedCell> cells,  Duration duration,  Shake shake)  clearing,required TResult Function( Duration duration,  int streak)  combo,required TResult Function( int chips,  Duration duration)  countingChips,required TResult Function( Duration duration,  int mult)  countingMult,required TResult Function( JokerDelta delta,  Duration duration,  JokerId joker)  jokerPulse,required TResult Function( Duration countUp,  Duration duration,  int score,  Shake shake)  landing,required TResult Function( List<Cell> cells,  List<ClearedCell> clearing,  int colorIndex,  Duration duration,  Shake shake)  placing,required TResult Function( Duration duration,  int points)  points,required TResult Function( int bonus,  Duration duration,  int lineScore)  product,}) {final _that = this;
switch (_that) {
case ClearingBeat():
return clearing(_that.cells,_that.duration,_that.shake);case ComboBeat():
return combo(_that.duration,_that.streak);case CountingChipsBeat():
return countingChips(_that.chips,_that.duration);case CountingMultBeat():
return countingMult(_that.duration,_that.mult);case JokerPulseBeat():
return jokerPulse(_that.delta,_that.duration,_that.joker);case LandingBeat():
return landing(_that.countUp,_that.duration,_that.score,_that.shake);case PlacingBeat():
return placing(_that.cells,_that.clearing,_that.colorIndex,_that.duration,_that.shake);case PointsBeat():
return points(_that.duration,_that.points);case ProductBeat():
return product(_that.bonus,_that.duration,_that.lineScore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<ClearedCell> cells,  Duration duration,  Shake shake)?  clearing,TResult? Function( Duration duration,  int streak)?  combo,TResult? Function( int chips,  Duration duration)?  countingChips,TResult? Function( Duration duration,  int mult)?  countingMult,TResult? Function( JokerDelta delta,  Duration duration,  JokerId joker)?  jokerPulse,TResult? Function( Duration countUp,  Duration duration,  int score,  Shake shake)?  landing,TResult? Function( List<Cell> cells,  List<ClearedCell> clearing,  int colorIndex,  Duration duration,  Shake shake)?  placing,TResult? Function( Duration duration,  int points)?  points,TResult? Function( int bonus,  Duration duration,  int lineScore)?  product,}) {final _that = this;
switch (_that) {
case ClearingBeat() when clearing != null:
return clearing(_that.cells,_that.duration,_that.shake);case ComboBeat() when combo != null:
return combo(_that.duration,_that.streak);case CountingChipsBeat() when countingChips != null:
return countingChips(_that.chips,_that.duration);case CountingMultBeat() when countingMult != null:
return countingMult(_that.duration,_that.mult);case JokerPulseBeat() when jokerPulse != null:
return jokerPulse(_that.delta,_that.duration,_that.joker);case LandingBeat() when landing != null:
return landing(_that.countUp,_that.duration,_that.score,_that.shake);case PlacingBeat() when placing != null:
return placing(_that.cells,_that.clearing,_that.colorIndex,_that.duration,_that.shake);case PointsBeat() when points != null:
return points(_that.duration,_that.points);case ProductBeat() when product != null:
return product(_that.bonus,_that.duration,_that.lineScore);case _:
  return null;

}
}

}

/// @nodoc


class ClearingBeat implements Beat {
  const ClearingBeat({required final  List<ClearedCell> cells, required this.duration, required this.shake}): _cells = cells;
  

 final  List<ClearedCell> _cells;
 List<ClearedCell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

@override final  Duration duration;
 final  Shake shake;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClearingBeatCopyWith<ClearingBeat> get copyWith => _$ClearingBeatCopyWithImpl<ClearingBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearingBeat&&const DeepCollectionEquality().equals(other._cells, _cells)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.shake, shake) || other.shake == shake));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells),duration,shake);

@override
String toString() {
  return 'Beat.clearing(cells: $cells, duration: $duration, shake: $shake)';
}


}

/// @nodoc
abstract mixin class $ClearingBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $ClearingBeatCopyWith(ClearingBeat value, $Res Function(ClearingBeat) _then) = _$ClearingBeatCopyWithImpl;
@override @useResult
$Res call({
 List<ClearedCell> cells, Duration duration, Shake shake
});




}
/// @nodoc
class _$ClearingBeatCopyWithImpl<$Res>
    implements $ClearingBeatCopyWith<$Res> {
  _$ClearingBeatCopyWithImpl(this._self, this._then);

  final ClearingBeat _self;
  final $Res Function(ClearingBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,Object? duration = null,Object? shake = null,}) {
  return _then(ClearingBeat(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<ClearedCell>,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,shake: null == shake ? _self.shake : shake // ignore: cast_nullable_to_non_nullable
as Shake,
  ));
}


}

/// @nodoc


class ComboBeat implements Beat {
  const ComboBeat({required this.duration, required this.streak});
  

@override final  Duration duration;
 final  int streak;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComboBeatCopyWith<ComboBeat> get copyWith => _$ComboBeatCopyWithImpl<ComboBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComboBeat&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streak, streak) || other.streak == streak));
}


@override
int get hashCode => Object.hash(runtimeType,duration,streak);

@override
String toString() {
  return 'Beat.combo(duration: $duration, streak: $streak)';
}


}

/// @nodoc
abstract mixin class $ComboBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $ComboBeatCopyWith(ComboBeat value, $Res Function(ComboBeat) _then) = _$ComboBeatCopyWithImpl;
@override @useResult
$Res call({
 Duration duration, int streak
});




}
/// @nodoc
class _$ComboBeatCopyWithImpl<$Res>
    implements $ComboBeatCopyWith<$Res> {
  _$ComboBeatCopyWithImpl(this._self, this._then);

  final ComboBeat _self;
  final $Res Function(ComboBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? streak = null,}) {
  return _then(ComboBeat(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CountingChipsBeat implements Beat {
  const CountingChipsBeat({required this.chips, required this.duration});
  

 final  int chips;
@override final  Duration duration;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountingChipsBeatCopyWith<CountingChipsBeat> get copyWith => _$CountingChipsBeatCopyWithImpl<CountingChipsBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountingChipsBeat&&(identical(other.chips, chips) || other.chips == chips)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,chips,duration);

@override
String toString() {
  return 'Beat.countingChips(chips: $chips, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $CountingChipsBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $CountingChipsBeatCopyWith(CountingChipsBeat value, $Res Function(CountingChipsBeat) _then) = _$CountingChipsBeatCopyWithImpl;
@override @useResult
$Res call({
 int chips, Duration duration
});




}
/// @nodoc
class _$CountingChipsBeatCopyWithImpl<$Res>
    implements $CountingChipsBeatCopyWith<$Res> {
  _$CountingChipsBeatCopyWithImpl(this._self, this._then);

  final CountingChipsBeat _self;
  final $Res Function(CountingChipsBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chips = null,Object? duration = null,}) {
  return _then(CountingChipsBeat(
chips: null == chips ? _self.chips : chips // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class CountingMultBeat implements Beat {
  const CountingMultBeat({required this.duration, required this.mult});
  

@override final  Duration duration;
 final  int mult;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountingMultBeatCopyWith<CountingMultBeat> get copyWith => _$CountingMultBeatCopyWithImpl<CountingMultBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountingMultBeat&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.mult, mult) || other.mult == mult));
}


@override
int get hashCode => Object.hash(runtimeType,duration,mult);

@override
String toString() {
  return 'Beat.countingMult(duration: $duration, mult: $mult)';
}


}

/// @nodoc
abstract mixin class $CountingMultBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $CountingMultBeatCopyWith(CountingMultBeat value, $Res Function(CountingMultBeat) _then) = _$CountingMultBeatCopyWithImpl;
@override @useResult
$Res call({
 Duration duration, int mult
});




}
/// @nodoc
class _$CountingMultBeatCopyWithImpl<$Res>
    implements $CountingMultBeatCopyWith<$Res> {
  _$CountingMultBeatCopyWithImpl(this._self, this._then);

  final CountingMultBeat _self;
  final $Res Function(CountingMultBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? mult = null,}) {
  return _then(CountingMultBeat(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,mult: null == mult ? _self.mult : mult // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class JokerPulseBeat implements Beat {
  const JokerPulseBeat({required this.delta, required this.duration, required this.joker});
  

 final  JokerDelta delta;
@override final  Duration duration;
 final  JokerId joker;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerPulseBeatCopyWith<JokerPulseBeat> get copyWith => _$JokerPulseBeatCopyWithImpl<JokerPulseBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerPulseBeat&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.joker, joker) || other.joker == joker));
}


@override
int get hashCode => Object.hash(runtimeType,delta,duration,joker);

@override
String toString() {
  return 'Beat.jokerPulse(delta: $delta, duration: $duration, joker: $joker)';
}


}

/// @nodoc
abstract mixin class $JokerPulseBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $JokerPulseBeatCopyWith(JokerPulseBeat value, $Res Function(JokerPulseBeat) _then) = _$JokerPulseBeatCopyWithImpl;
@override @useResult
$Res call({
 JokerDelta delta, Duration duration, JokerId joker
});


$JokerDeltaCopyWith<$Res> get delta;

}
/// @nodoc
class _$JokerPulseBeatCopyWithImpl<$Res>
    implements $JokerPulseBeatCopyWith<$Res> {
  _$JokerPulseBeatCopyWithImpl(this._self, this._then);

  final JokerPulseBeat _self;
  final $Res Function(JokerPulseBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? delta = null,Object? duration = null,Object? joker = null,}) {
  return _then(JokerPulseBeat(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as JokerDelta,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,joker: null == joker ? _self.joker : joker // ignore: cast_nullable_to_non_nullable
as JokerId,
  ));
}

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerDeltaCopyWith<$Res> get delta {
  
  return $JokerDeltaCopyWith<$Res>(_self.delta, (value) {
    return _then(_self.copyWith(delta: value));
  });
}
}

/// @nodoc


class LandingBeat implements Beat {
  const LandingBeat({required this.countUp, required this.duration, required this.score, required this.shake});
  

 final  Duration countUp;
@override final  Duration duration;
 final  int score;
 final  Shake shake;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandingBeatCopyWith<LandingBeat> get copyWith => _$LandingBeatCopyWithImpl<LandingBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingBeat&&(identical(other.countUp, countUp) || other.countUp == countUp)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.score, score) || other.score == score)&&(identical(other.shake, shake) || other.shake == shake));
}


@override
int get hashCode => Object.hash(runtimeType,countUp,duration,score,shake);

@override
String toString() {
  return 'Beat.landing(countUp: $countUp, duration: $duration, score: $score, shake: $shake)';
}


}

/// @nodoc
abstract mixin class $LandingBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $LandingBeatCopyWith(LandingBeat value, $Res Function(LandingBeat) _then) = _$LandingBeatCopyWithImpl;
@override @useResult
$Res call({
 Duration countUp, Duration duration, int score, Shake shake
});




}
/// @nodoc
class _$LandingBeatCopyWithImpl<$Res>
    implements $LandingBeatCopyWith<$Res> {
  _$LandingBeatCopyWithImpl(this._self, this._then);

  final LandingBeat _self;
  final $Res Function(LandingBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countUp = null,Object? duration = null,Object? score = null,Object? shake = null,}) {
  return _then(LandingBeat(
countUp: null == countUp ? _self.countUp : countUp // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,shake: null == shake ? _self.shake : shake // ignore: cast_nullable_to_non_nullable
as Shake,
  ));
}


}

/// @nodoc


class PlacingBeat implements Beat {
  const PlacingBeat({required final  List<Cell> cells, required final  List<ClearedCell> clearing, required this.colorIndex, required this.duration, required this.shake}): _cells = cells,_clearing = clearing;
  

 final  List<Cell> _cells;
 List<Cell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

 final  List<ClearedCell> _clearing;
 List<ClearedCell> get clearing {
  if (_clearing is EqualUnmodifiableListView) return _clearing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clearing);
}

 final  int colorIndex;
@override final  Duration duration;
 final  Shake shake;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacingBeatCopyWith<PlacingBeat> get copyWith => _$PlacingBeatCopyWithImpl<PlacingBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacingBeat&&const DeepCollectionEquality().equals(other._cells, _cells)&&const DeepCollectionEquality().equals(other._clearing, _clearing)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.shake, shake) || other.shake == shake));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells),const DeepCollectionEquality().hash(_clearing),colorIndex,duration,shake);

@override
String toString() {
  return 'Beat.placing(cells: $cells, clearing: $clearing, colorIndex: $colorIndex, duration: $duration, shake: $shake)';
}


}

/// @nodoc
abstract mixin class $PlacingBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $PlacingBeatCopyWith(PlacingBeat value, $Res Function(PlacingBeat) _then) = _$PlacingBeatCopyWithImpl;
@override @useResult
$Res call({
 List<Cell> cells, List<ClearedCell> clearing, int colorIndex, Duration duration, Shake shake
});




}
/// @nodoc
class _$PlacingBeatCopyWithImpl<$Res>
    implements $PlacingBeatCopyWith<$Res> {
  _$PlacingBeatCopyWithImpl(this._self, this._then);

  final PlacingBeat _self;
  final $Res Function(PlacingBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,Object? clearing = null,Object? colorIndex = null,Object? duration = null,Object? shake = null,}) {
  return _then(PlacingBeat(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,clearing: null == clearing ? _self._clearing : clearing // ignore: cast_nullable_to_non_nullable
as List<ClearedCell>,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,shake: null == shake ? _self.shake : shake // ignore: cast_nullable_to_non_nullable
as Shake,
  ));
}


}

/// @nodoc


class PointsBeat implements Beat {
  const PointsBeat({required this.duration, required this.points});
  

@override final  Duration duration;
 final  int points;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsBeatCopyWith<PointsBeat> get copyWith => _$PointsBeatCopyWithImpl<PointsBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsBeat&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.points, points) || other.points == points));
}


@override
int get hashCode => Object.hash(runtimeType,duration,points);

@override
String toString() {
  return 'Beat.points(duration: $duration, points: $points)';
}


}

/// @nodoc
abstract mixin class $PointsBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $PointsBeatCopyWith(PointsBeat value, $Res Function(PointsBeat) _then) = _$PointsBeatCopyWithImpl;
@override @useResult
$Res call({
 Duration duration, int points
});




}
/// @nodoc
class _$PointsBeatCopyWithImpl<$Res>
    implements $PointsBeatCopyWith<$Res> {
  _$PointsBeatCopyWithImpl(this._self, this._then);

  final PointsBeat _self;
  final $Res Function(PointsBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? points = null,}) {
  return _then(PointsBeat(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ProductBeat implements Beat {
  const ProductBeat({required this.bonus, required this.duration, required this.lineScore});
  

 final  int bonus;
@override final  Duration duration;
 final  int lineScore;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductBeatCopyWith<ProductBeat> get copyWith => _$ProductBeatCopyWithImpl<ProductBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductBeat&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.lineScore, lineScore) || other.lineScore == lineScore));
}


@override
int get hashCode => Object.hash(runtimeType,bonus,duration,lineScore);

@override
String toString() {
  return 'Beat.product(bonus: $bonus, duration: $duration, lineScore: $lineScore)';
}


}

/// @nodoc
abstract mixin class $ProductBeatCopyWith<$Res> implements $BeatCopyWith<$Res> {
  factory $ProductBeatCopyWith(ProductBeat value, $Res Function(ProductBeat) _then) = _$ProductBeatCopyWithImpl;
@override @useResult
$Res call({
 int bonus, Duration duration, int lineScore
});




}
/// @nodoc
class _$ProductBeatCopyWithImpl<$Res>
    implements $ProductBeatCopyWith<$Res> {
  _$ProductBeatCopyWithImpl(this._self, this._then);

  final ProductBeat _self;
  final $Res Function(ProductBeat) _then;

/// Create a copy of Beat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bonus = null,Object? duration = null,Object? lineScore = null,}) {
  return _then(ProductBeat(
bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,lineScore: null == lineScore ? _self.lineScore : lineScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
