// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_phase.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunPhase {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunPhase()';
}


}

/// @nodoc
class $RunPhaseCopyWith<$Res>  {
$RunPhaseCopyWith(RunPhase _, $Res Function(RunPhase) __);
}


/// Adds pattern-matching-related methods to [RunPhase].
extension RunPhasePatterns on RunPhase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OverPhase value)?  over,TResult Function( PickingJokerPhase value)?  pickingJoker,TResult Function( PlayingPhase value)?  playing,TResult Function( RoundLostPhase value)?  roundLost,TResult Function( WonPhase value)?  won,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OverPhase() when over != null:
return over(_that);case PickingJokerPhase() when pickingJoker != null:
return pickingJoker(_that);case PlayingPhase() when playing != null:
return playing(_that);case RoundLostPhase() when roundLost != null:
return roundLost(_that);case WonPhase() when won != null:
return won(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OverPhase value)  over,required TResult Function( PickingJokerPhase value)  pickingJoker,required TResult Function( PlayingPhase value)  playing,required TResult Function( RoundLostPhase value)  roundLost,required TResult Function( WonPhase value)  won,}){
final _that = this;
switch (_that) {
case OverPhase():
return over(_that);case PickingJokerPhase():
return pickingJoker(_that);case PlayingPhase():
return playing(_that);case RoundLostPhase():
return roundLost(_that);case WonPhase():
return won(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OverPhase value)?  over,TResult? Function( PickingJokerPhase value)?  pickingJoker,TResult? Function( PlayingPhase value)?  playing,TResult? Function( RoundLostPhase value)?  roundLost,TResult? Function( WonPhase value)?  won,}){
final _that = this;
switch (_that) {
case OverPhase() when over != null:
return over(_that);case PickingJokerPhase() when pickingJoker != null:
return pickingJoker(_that);case PlayingPhase() when playing != null:
return playing(_that);case RoundLostPhase() when roundLost != null:
return roundLost(_that);case WonPhase() when won != null:
return won(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  over,TResult Function( List<JokerId> offers)?  pickingJoker,TResult Function()?  playing,TResult Function( LossReason reason)?  roundLost,TResult Function()?  won,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OverPhase() when over != null:
return over();case PickingJokerPhase() when pickingJoker != null:
return pickingJoker(_that.offers);case PlayingPhase() when playing != null:
return playing();case RoundLostPhase() when roundLost != null:
return roundLost(_that.reason);case WonPhase() when won != null:
return won();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  over,required TResult Function( List<JokerId> offers)  pickingJoker,required TResult Function()  playing,required TResult Function( LossReason reason)  roundLost,required TResult Function()  won,}) {final _that = this;
switch (_that) {
case OverPhase():
return over();case PickingJokerPhase():
return pickingJoker(_that.offers);case PlayingPhase():
return playing();case RoundLostPhase():
return roundLost(_that.reason);case WonPhase():
return won();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  over,TResult? Function( List<JokerId> offers)?  pickingJoker,TResult? Function()?  playing,TResult? Function( LossReason reason)?  roundLost,TResult? Function()?  won,}) {final _that = this;
switch (_that) {
case OverPhase() when over != null:
return over();case PickingJokerPhase() when pickingJoker != null:
return pickingJoker(_that.offers);case PlayingPhase() when playing != null:
return playing();case RoundLostPhase() when roundLost != null:
return roundLost(_that.reason);case WonPhase() when won != null:
return won();case _:
  return null;

}
}

}

/// @nodoc


class OverPhase implements RunPhase {
  const OverPhase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunPhase.over()';
}


}




/// @nodoc


class PickingJokerPhase implements RunPhase {
  const PickingJokerPhase({required final  List<JokerId> offers}): _offers = offers;
  

 final  List<JokerId> _offers;
 List<JokerId> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}


/// Create a copy of RunPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickingJokerPhaseCopyWith<PickingJokerPhase> get copyWith => _$PickingJokerPhaseCopyWithImpl<PickingJokerPhase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickingJokerPhase&&const DeepCollectionEquality().equals(other._offers, _offers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_offers));

@override
String toString() {
  return 'RunPhase.pickingJoker(offers: $offers)';
}


}

/// @nodoc
abstract mixin class $PickingJokerPhaseCopyWith<$Res> implements $RunPhaseCopyWith<$Res> {
  factory $PickingJokerPhaseCopyWith(PickingJokerPhase value, $Res Function(PickingJokerPhase) _then) = _$PickingJokerPhaseCopyWithImpl;
@useResult
$Res call({
 List<JokerId> offers
});




}
/// @nodoc
class _$PickingJokerPhaseCopyWithImpl<$Res>
    implements $PickingJokerPhaseCopyWith<$Res> {
  _$PickingJokerPhaseCopyWithImpl(this._self, this._then);

  final PickingJokerPhase _self;
  final $Res Function(PickingJokerPhase) _then;

/// Create a copy of RunPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offers = null,}) {
  return _then(PickingJokerPhase(
offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<JokerId>,
  ));
}


}

/// @nodoc


class PlayingPhase implements RunPhase {
  const PlayingPhase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayingPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunPhase.playing()';
}


}




/// @nodoc


class RoundLostPhase implements RunPhase {
  const RoundLostPhase({required this.reason});
  

 final  LossReason reason;

/// Create a copy of RunPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundLostPhaseCopyWith<RoundLostPhase> get copyWith => _$RoundLostPhaseCopyWithImpl<RoundLostPhase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundLostPhase&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'RunPhase.roundLost(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RoundLostPhaseCopyWith<$Res> implements $RunPhaseCopyWith<$Res> {
  factory $RoundLostPhaseCopyWith(RoundLostPhase value, $Res Function(RoundLostPhase) _then) = _$RoundLostPhaseCopyWithImpl;
@useResult
$Res call({
 LossReason reason
});




}
/// @nodoc
class _$RoundLostPhaseCopyWithImpl<$Res>
    implements $RoundLostPhaseCopyWith<$Res> {
  _$RoundLostPhaseCopyWithImpl(this._self, this._then);

  final RoundLostPhase _self;
  final $Res Function(RoundLostPhase) _then;

/// Create a copy of RunPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(RoundLostPhase(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LossReason,
  ));
}


}

/// @nodoc


class WonPhase implements RunPhase {
  const WonPhase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WonPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RunPhase.won()';
}


}




// dart format on
