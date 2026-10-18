// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engagement.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Engagement {

/// Runs played to their end, won or not; the tutorial never counts.
 int get completedRuns;/// Local days the app was opened on, the first included.
 int get daysOpened;/// The local day (`yyyymmdd`) of the first launch; null until then.
 int? get firstOpenedOn; DateTime? get lastInterstitialAt;/// The local day (`yyyymmdd`) of the latest launch.
 int? get lastOpenedOn;/// When the app last asked the OS for its rating prompt, and in which of
/// its versions.
 DateTime? get reviewAskedAt; String? get reviewAskedVersion;/// Run ends since the last interstitial showed.
 int get runEndsSinceInterstitial;
/// Create a copy of Engagement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngagementCopyWith<Engagement> get copyWith => _$EngagementCopyWithImpl<Engagement>(this as Engagement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Engagement&&(identical(other.completedRuns, completedRuns) || other.completedRuns == completedRuns)&&(identical(other.daysOpened, daysOpened) || other.daysOpened == daysOpened)&&(identical(other.firstOpenedOn, firstOpenedOn) || other.firstOpenedOn == firstOpenedOn)&&(identical(other.lastInterstitialAt, lastInterstitialAt) || other.lastInterstitialAt == lastInterstitialAt)&&(identical(other.lastOpenedOn, lastOpenedOn) || other.lastOpenedOn == lastOpenedOn)&&(identical(other.reviewAskedAt, reviewAskedAt) || other.reviewAskedAt == reviewAskedAt)&&(identical(other.reviewAskedVersion, reviewAskedVersion) || other.reviewAskedVersion == reviewAskedVersion)&&(identical(other.runEndsSinceInterstitial, runEndsSinceInterstitial) || other.runEndsSinceInterstitial == runEndsSinceInterstitial));
}


@override
int get hashCode => Object.hash(runtimeType,completedRuns,daysOpened,firstOpenedOn,lastInterstitialAt,lastOpenedOn,reviewAskedAt,reviewAskedVersion,runEndsSinceInterstitial);

@override
String toString() {
  return 'Engagement(completedRuns: $completedRuns, daysOpened: $daysOpened, firstOpenedOn: $firstOpenedOn, lastInterstitialAt: $lastInterstitialAt, lastOpenedOn: $lastOpenedOn, reviewAskedAt: $reviewAskedAt, reviewAskedVersion: $reviewAskedVersion, runEndsSinceInterstitial: $runEndsSinceInterstitial)';
}


}

/// @nodoc
abstract mixin class $EngagementCopyWith<$Res>  {
  factory $EngagementCopyWith(Engagement value, $Res Function(Engagement) _then) = _$EngagementCopyWithImpl;
@useResult
$Res call({
 int completedRuns, int daysOpened, int? firstOpenedOn, DateTime? lastInterstitialAt, int? lastOpenedOn, DateTime? reviewAskedAt, String? reviewAskedVersion, int runEndsSinceInterstitial
});




}
/// @nodoc
class _$EngagementCopyWithImpl<$Res>
    implements $EngagementCopyWith<$Res> {
  _$EngagementCopyWithImpl(this._self, this._then);

  final Engagement _self;
  final $Res Function(Engagement) _then;

/// Create a copy of Engagement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedRuns = null,Object? daysOpened = null,Object? firstOpenedOn = freezed,Object? lastInterstitialAt = freezed,Object? lastOpenedOn = freezed,Object? reviewAskedAt = freezed,Object? reviewAskedVersion = freezed,Object? runEndsSinceInterstitial = null,}) {
  return _then(_self.copyWith(
completedRuns: null == completedRuns ? _self.completedRuns : completedRuns // ignore: cast_nullable_to_non_nullable
as int,daysOpened: null == daysOpened ? _self.daysOpened : daysOpened // ignore: cast_nullable_to_non_nullable
as int,firstOpenedOn: freezed == firstOpenedOn ? _self.firstOpenedOn : firstOpenedOn // ignore: cast_nullable_to_non_nullable
as int?,lastInterstitialAt: freezed == lastInterstitialAt ? _self.lastInterstitialAt : lastInterstitialAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastOpenedOn: freezed == lastOpenedOn ? _self.lastOpenedOn : lastOpenedOn // ignore: cast_nullable_to_non_nullable
as int?,reviewAskedAt: freezed == reviewAskedAt ? _self.reviewAskedAt : reviewAskedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewAskedVersion: freezed == reviewAskedVersion ? _self.reviewAskedVersion : reviewAskedVersion // ignore: cast_nullable_to_non_nullable
as String?,runEndsSinceInterstitial: null == runEndsSinceInterstitial ? _self.runEndsSinceInterstitial : runEndsSinceInterstitial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Engagement].
extension EngagementPatterns on Engagement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Engagement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Engagement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Engagement value)  $default,){
final _that = this;
switch (_that) {
case _Engagement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Engagement value)?  $default,){
final _that = this;
switch (_that) {
case _Engagement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completedRuns,  int daysOpened,  int? firstOpenedOn,  DateTime? lastInterstitialAt,  int? lastOpenedOn,  DateTime? reviewAskedAt,  String? reviewAskedVersion,  int runEndsSinceInterstitial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Engagement() when $default != null:
return $default(_that.completedRuns,_that.daysOpened,_that.firstOpenedOn,_that.lastInterstitialAt,_that.lastOpenedOn,_that.reviewAskedAt,_that.reviewAskedVersion,_that.runEndsSinceInterstitial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completedRuns,  int daysOpened,  int? firstOpenedOn,  DateTime? lastInterstitialAt,  int? lastOpenedOn,  DateTime? reviewAskedAt,  String? reviewAskedVersion,  int runEndsSinceInterstitial)  $default,) {final _that = this;
switch (_that) {
case _Engagement():
return $default(_that.completedRuns,_that.daysOpened,_that.firstOpenedOn,_that.lastInterstitialAt,_that.lastOpenedOn,_that.reviewAskedAt,_that.reviewAskedVersion,_that.runEndsSinceInterstitial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completedRuns,  int daysOpened,  int? firstOpenedOn,  DateTime? lastInterstitialAt,  int? lastOpenedOn,  DateTime? reviewAskedAt,  String? reviewAskedVersion,  int runEndsSinceInterstitial)?  $default,) {final _that = this;
switch (_that) {
case _Engagement() when $default != null:
return $default(_that.completedRuns,_that.daysOpened,_that.firstOpenedOn,_that.lastInterstitialAt,_that.lastOpenedOn,_that.reviewAskedAt,_that.reviewAskedVersion,_that.runEndsSinceInterstitial);case _:
  return null;

}
}

}

/// @nodoc


class _Engagement implements Engagement {
  const _Engagement({this.completedRuns = 0, this.daysOpened = 0, this.firstOpenedOn, this.lastInterstitialAt, this.lastOpenedOn, this.reviewAskedAt, this.reviewAskedVersion, this.runEndsSinceInterstitial = 0});
  

/// Runs played to their end, won or not; the tutorial never counts.
@override@JsonKey() final  int completedRuns;
/// Local days the app was opened on, the first included.
@override@JsonKey() final  int daysOpened;
/// The local day (`yyyymmdd`) of the first launch; null until then.
@override final  int? firstOpenedOn;
@override final  DateTime? lastInterstitialAt;
/// The local day (`yyyymmdd`) of the latest launch.
@override final  int? lastOpenedOn;
/// When the app last asked the OS for its rating prompt, and in which of
/// its versions.
@override final  DateTime? reviewAskedAt;
@override final  String? reviewAskedVersion;
/// Run ends since the last interstitial showed.
@override@JsonKey() final  int runEndsSinceInterstitial;

/// Create a copy of Engagement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngagementCopyWith<_Engagement> get copyWith => __$EngagementCopyWithImpl<_Engagement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Engagement&&(identical(other.completedRuns, completedRuns) || other.completedRuns == completedRuns)&&(identical(other.daysOpened, daysOpened) || other.daysOpened == daysOpened)&&(identical(other.firstOpenedOn, firstOpenedOn) || other.firstOpenedOn == firstOpenedOn)&&(identical(other.lastInterstitialAt, lastInterstitialAt) || other.lastInterstitialAt == lastInterstitialAt)&&(identical(other.lastOpenedOn, lastOpenedOn) || other.lastOpenedOn == lastOpenedOn)&&(identical(other.reviewAskedAt, reviewAskedAt) || other.reviewAskedAt == reviewAskedAt)&&(identical(other.reviewAskedVersion, reviewAskedVersion) || other.reviewAskedVersion == reviewAskedVersion)&&(identical(other.runEndsSinceInterstitial, runEndsSinceInterstitial) || other.runEndsSinceInterstitial == runEndsSinceInterstitial));
}


@override
int get hashCode => Object.hash(runtimeType,completedRuns,daysOpened,firstOpenedOn,lastInterstitialAt,lastOpenedOn,reviewAskedAt,reviewAskedVersion,runEndsSinceInterstitial);

@override
String toString() {
  return 'Engagement(completedRuns: $completedRuns, daysOpened: $daysOpened, firstOpenedOn: $firstOpenedOn, lastInterstitialAt: $lastInterstitialAt, lastOpenedOn: $lastOpenedOn, reviewAskedAt: $reviewAskedAt, reviewAskedVersion: $reviewAskedVersion, runEndsSinceInterstitial: $runEndsSinceInterstitial)';
}


}

/// @nodoc
abstract mixin class _$EngagementCopyWith<$Res> implements $EngagementCopyWith<$Res> {
  factory _$EngagementCopyWith(_Engagement value, $Res Function(_Engagement) _then) = __$EngagementCopyWithImpl;
@override @useResult
$Res call({
 int completedRuns, int daysOpened, int? firstOpenedOn, DateTime? lastInterstitialAt, int? lastOpenedOn, DateTime? reviewAskedAt, String? reviewAskedVersion, int runEndsSinceInterstitial
});




}
/// @nodoc
class __$EngagementCopyWithImpl<$Res>
    implements _$EngagementCopyWith<$Res> {
  __$EngagementCopyWithImpl(this._self, this._then);

  final _Engagement _self;
  final $Res Function(_Engagement) _then;

/// Create a copy of Engagement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedRuns = null,Object? daysOpened = null,Object? firstOpenedOn = freezed,Object? lastInterstitialAt = freezed,Object? lastOpenedOn = freezed,Object? reviewAskedAt = freezed,Object? reviewAskedVersion = freezed,Object? runEndsSinceInterstitial = null,}) {
  return _then(_Engagement(
completedRuns: null == completedRuns ? _self.completedRuns : completedRuns // ignore: cast_nullable_to_non_nullable
as int,daysOpened: null == daysOpened ? _self.daysOpened : daysOpened // ignore: cast_nullable_to_non_nullable
as int,firstOpenedOn: freezed == firstOpenedOn ? _self.firstOpenedOn : firstOpenedOn // ignore: cast_nullable_to_non_nullable
as int?,lastInterstitialAt: freezed == lastInterstitialAt ? _self.lastInterstitialAt : lastInterstitialAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastOpenedOn: freezed == lastOpenedOn ? _self.lastOpenedOn : lastOpenedOn // ignore: cast_nullable_to_non_nullable
as int?,reviewAskedAt: freezed == reviewAskedAt ? _self.reviewAskedAt : reviewAskedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewAskedVersion: freezed == reviewAskedVersion ? _self.reviewAskedVersion : reviewAskedVersion // ignore: cast_nullable_to_non_nullable
as String?,runEndsSinceInterstitial: null == runEndsSinceInterstitial ? _self.runEndsSinceInterstitial : runEndsSinceInterstitial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
