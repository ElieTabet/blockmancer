// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joker_collection.br.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokerCollection {

/// The new player's pairs first, then each world's, then the stars'.
 List<JokerPair> get pairs;/// The numbers the jokers play with, for describing them.
 JokerTuning get tuning;
/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerCollectionCopyWith<JokerCollection> get copyWith => _$JokerCollectionCopyWithImpl<JokerCollection>(this as JokerCollection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerCollection&&const DeepCollectionEquality().equals(other.pairs, pairs)&&(identical(other.tuning, tuning) || other.tuning == tuning));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pairs),tuning);

@override
String toString() {
  return 'JokerCollection(pairs: $pairs, tuning: $tuning)';
}


}

/// @nodoc
abstract mixin class $JokerCollectionCopyWith<$Res>  {
  factory $JokerCollectionCopyWith(JokerCollection value, $Res Function(JokerCollection) _then) = _$JokerCollectionCopyWithImpl;
@useResult
$Res call({
 List<JokerPair> pairs, JokerTuning tuning
});


$JokerTuningCopyWith<$Res> get tuning;

}
/// @nodoc
class _$JokerCollectionCopyWithImpl<$Res>
    implements $JokerCollectionCopyWith<$Res> {
  _$JokerCollectionCopyWithImpl(this._self, this._then);

  final JokerCollection _self;
  final $Res Function(JokerCollection) _then;

/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pairs = null,Object? tuning = null,}) {
  return _then(_self.copyWith(
pairs: null == pairs ? _self.pairs : pairs // ignore: cast_nullable_to_non_nullable
as List<JokerPair>,tuning: null == tuning ? _self.tuning : tuning // ignore: cast_nullable_to_non_nullable
as JokerTuning,
  ));
}
/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get tuning {
  
  return $JokerTuningCopyWith<$Res>(_self.tuning, (value) {
    return _then(_self.copyWith(tuning: value));
  });
}
}


/// Adds pattern-matching-related methods to [JokerCollection].
extension JokerCollectionPatterns on JokerCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokerCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokerCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokerCollection value)  $default,){
final _that = this;
switch (_that) {
case _JokerCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokerCollection value)?  $default,){
final _that = this;
switch (_that) {
case _JokerCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<JokerPair> pairs,  JokerTuning tuning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokerCollection() when $default != null:
return $default(_that.pairs,_that.tuning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<JokerPair> pairs,  JokerTuning tuning)  $default,) {final _that = this;
switch (_that) {
case _JokerCollection():
return $default(_that.pairs,_that.tuning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<JokerPair> pairs,  JokerTuning tuning)?  $default,) {final _that = this;
switch (_that) {
case _JokerCollection() when $default != null:
return $default(_that.pairs,_that.tuning);case _:
  return null;

}
}

}

/// @nodoc


class _JokerCollection implements JokerCollection {
  const _JokerCollection({required final  List<JokerPair> pairs, required this.tuning}): _pairs = pairs;
  

/// The new player's pairs first, then each world's, then the stars'.
 final  List<JokerPair> _pairs;
/// The new player's pairs first, then each world's, then the stars'.
@override List<JokerPair> get pairs {
  if (_pairs is EqualUnmodifiableListView) return _pairs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pairs);
}

/// The numbers the jokers play with, for describing them.
@override final  JokerTuning tuning;

/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokerCollectionCopyWith<_JokerCollection> get copyWith => __$JokerCollectionCopyWithImpl<_JokerCollection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokerCollection&&const DeepCollectionEquality().equals(other._pairs, _pairs)&&(identical(other.tuning, tuning) || other.tuning == tuning));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pairs),tuning);

@override
String toString() {
  return 'JokerCollection(pairs: $pairs, tuning: $tuning)';
}


}

/// @nodoc
abstract mixin class _$JokerCollectionCopyWith<$Res> implements $JokerCollectionCopyWith<$Res> {
  factory _$JokerCollectionCopyWith(_JokerCollection value, $Res Function(_JokerCollection) _then) = __$JokerCollectionCopyWithImpl;
@override @useResult
$Res call({
 List<JokerPair> pairs, JokerTuning tuning
});


@override $JokerTuningCopyWith<$Res> get tuning;

}
/// @nodoc
class __$JokerCollectionCopyWithImpl<$Res>
    implements _$JokerCollectionCopyWith<$Res> {
  __$JokerCollectionCopyWithImpl(this._self, this._then);

  final _JokerCollection _self;
  final $Res Function(_JokerCollection) _then;

/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pairs = null,Object? tuning = null,}) {
  return _then(_JokerCollection(
pairs: null == pairs ? _self._pairs : pairs // ignore: cast_nullable_to_non_nullable
as List<JokerPair>,tuning: null == tuning ? _self.tuning : tuning // ignore: cast_nullable_to_non_nullable
as JokerTuning,
  ));
}

/// Create a copy of JokerCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerTuningCopyWith<$Res> get tuning {
  
  return $JokerTuningCopyWith<$Res>(_self.tuning, (value) {
    return _then(_self.copyWith(tuning: value));
  });
}
}

/// @nodoc
mixin _$JokerPair {

 JokerId get first; JokerId get second; JokerUnlock get unlock;
/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokerPairCopyWith<JokerPair> get copyWith => _$JokerPairCopyWithImpl<JokerPair>(this as JokerPair, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerPair&&(identical(other.first, first) || other.first == first)&&(identical(other.second, second) || other.second == second)&&(identical(other.unlock, unlock) || other.unlock == unlock));
}


@override
int get hashCode => Object.hash(runtimeType,first,second,unlock);

@override
String toString() {
  return 'JokerPair(first: $first, second: $second, unlock: $unlock)';
}


}

/// @nodoc
abstract mixin class $JokerPairCopyWith<$Res>  {
  factory $JokerPairCopyWith(JokerPair value, $Res Function(JokerPair) _then) = _$JokerPairCopyWithImpl;
@useResult
$Res call({
 JokerId first, JokerId second, JokerUnlock unlock
});


$JokerUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class _$JokerPairCopyWithImpl<$Res>
    implements $JokerPairCopyWith<$Res> {
  _$JokerPairCopyWithImpl(this._self, this._then);

  final JokerPair _self;
  final $Res Function(JokerPair) _then;

/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? first = null,Object? second = null,Object? unlock = null,}) {
  return _then(_self.copyWith(
first: null == first ? _self.first : first // ignore: cast_nullable_to_non_nullable
as JokerId,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as JokerId,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as JokerUnlock,
  ));
}
/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerUnlockCopyWith<$Res> get unlock {
  
  return $JokerUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}


/// Adds pattern-matching-related methods to [JokerPair].
extension JokerPairPatterns on JokerPair {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokerPair value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokerPair() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokerPair value)  $default,){
final _that = this;
switch (_that) {
case _JokerPair():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokerPair value)?  $default,){
final _that = this;
switch (_that) {
case _JokerPair() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JokerId first,  JokerId second,  JokerUnlock unlock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokerPair() when $default != null:
return $default(_that.first,_that.second,_that.unlock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JokerId first,  JokerId second,  JokerUnlock unlock)  $default,) {final _that = this;
switch (_that) {
case _JokerPair():
return $default(_that.first,_that.second,_that.unlock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JokerId first,  JokerId second,  JokerUnlock unlock)?  $default,) {final _that = this;
switch (_that) {
case _JokerPair() when $default != null:
return $default(_that.first,_that.second,_that.unlock);case _:
  return null;

}
}

}

/// @nodoc


class _JokerPair implements JokerPair {
  const _JokerPair({required this.first, required this.second, required this.unlock});
  

@override final  JokerId first;
@override final  JokerId second;
@override final  JokerUnlock unlock;

/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokerPairCopyWith<_JokerPair> get copyWith => __$JokerPairCopyWithImpl<_JokerPair>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokerPair&&(identical(other.first, first) || other.first == first)&&(identical(other.second, second) || other.second == second)&&(identical(other.unlock, unlock) || other.unlock == unlock));
}


@override
int get hashCode => Object.hash(runtimeType,first,second,unlock);

@override
String toString() {
  return 'JokerPair(first: $first, second: $second, unlock: $unlock)';
}


}

/// @nodoc
abstract mixin class _$JokerPairCopyWith<$Res> implements $JokerPairCopyWith<$Res> {
  factory _$JokerPairCopyWith(_JokerPair value, $Res Function(_JokerPair) _then) = __$JokerPairCopyWithImpl;
@override @useResult
$Res call({
 JokerId first, JokerId second, JokerUnlock unlock
});


@override $JokerUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class __$JokerPairCopyWithImpl<$Res>
    implements _$JokerPairCopyWith<$Res> {
  __$JokerPairCopyWithImpl(this._self, this._then);

  final _JokerPair _self;
  final $Res Function(_JokerPair) _then;

/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? first = null,Object? second = null,Object? unlock = null,}) {
  return _then(_JokerPair(
first: null == first ? _self.first : first // ignore: cast_nullable_to_non_nullable
as JokerId,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as JokerId,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as JokerUnlock,
  ));
}

/// Create a copy of JokerPair
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JokerUnlockCopyWith<$Res> get unlock {
  
  return $JokerUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}

/// @nodoc
mixin _$JokerUnlock {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerUnlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokerUnlock()';
}


}

/// @nodoc
class $JokerUnlockCopyWith<$Res>  {
$JokerUnlockCopyWith(JokerUnlock _, $Res Function(JokerUnlock) __);
}


/// Adds pattern-matching-related methods to [JokerUnlock].
extension JokerUnlockPatterns on JokerUnlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BossUnlock value)?  boss,TResult Function( StartingUnlock value)?  starting,TResult Function( StarsUnlock value)?  stars,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BossUnlock() when boss != null:
return boss(_that);case StartingUnlock() when starting != null:
return starting(_that);case StarsUnlock() when stars != null:
return stars(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BossUnlock value)  boss,required TResult Function( StartingUnlock value)  starting,required TResult Function( StarsUnlock value)  stars,}){
final _that = this;
switch (_that) {
case BossUnlock():
return boss(_that);case StartingUnlock():
return starting(_that);case StarsUnlock():
return stars(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BossUnlock value)?  boss,TResult? Function( StartingUnlock value)?  starting,TResult? Function( StarsUnlock value)?  stars,}){
final _that = this;
switch (_that) {
case BossUnlock() when boss != null:
return boss(_that);case StartingUnlock() when starting != null:
return starting(_that);case StarsUnlock() when stars != null:
return stars(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WorldId world)?  boss,TResult Function()?  starting,TResult Function( int count)?  stars,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BossUnlock() when boss != null:
return boss(_that.world);case StartingUnlock() when starting != null:
return starting();case StarsUnlock() when stars != null:
return stars(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WorldId world)  boss,required TResult Function()  starting,required TResult Function( int count)  stars,}) {final _that = this;
switch (_that) {
case BossUnlock():
return boss(_that.world);case StartingUnlock():
return starting();case StarsUnlock():
return stars(_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WorldId world)?  boss,TResult? Function()?  starting,TResult? Function( int count)?  stars,}) {final _that = this;
switch (_that) {
case BossUnlock() when boss != null:
return boss(_that.world);case StartingUnlock() when starting != null:
return starting();case StarsUnlock() when stars != null:
return stars(_that.count);case _:
  return null;

}
}

}

/// @nodoc


class BossUnlock implements JokerUnlock {
  const BossUnlock({required this.world});
  

 final  WorldId world;

/// Create a copy of JokerUnlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BossUnlockCopyWith<BossUnlock> get copyWith => _$BossUnlockCopyWithImpl<BossUnlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BossUnlock&&(identical(other.world, world) || other.world == world));
}


@override
int get hashCode => Object.hash(runtimeType,world);

@override
String toString() {
  return 'JokerUnlock.boss(world: $world)';
}


}

/// @nodoc
abstract mixin class $BossUnlockCopyWith<$Res> implements $JokerUnlockCopyWith<$Res> {
  factory $BossUnlockCopyWith(BossUnlock value, $Res Function(BossUnlock) _then) = _$BossUnlockCopyWithImpl;
@useResult
$Res call({
 WorldId world
});




}
/// @nodoc
class _$BossUnlockCopyWithImpl<$Res>
    implements $BossUnlockCopyWith<$Res> {
  _$BossUnlockCopyWithImpl(this._self, this._then);

  final BossUnlock _self;
  final $Res Function(BossUnlock) _then;

/// Create a copy of JokerUnlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? world = null,}) {
  return _then(BossUnlock(
world: null == world ? _self.world : world // ignore: cast_nullable_to_non_nullable
as WorldId,
  ));
}


}

/// @nodoc


class StartingUnlock implements JokerUnlock {
  const StartingUnlock();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartingUnlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokerUnlock.starting()';
}


}




/// @nodoc


class StarsUnlock implements JokerUnlock {
  const StarsUnlock({required this.count});
  

 final  int count;

/// Create a copy of JokerUnlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarsUnlockCopyWith<StarsUnlock> get copyWith => _$StarsUnlockCopyWithImpl<StarsUnlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarsUnlock&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'JokerUnlock.stars(count: $count)';
}


}

/// @nodoc
abstract mixin class $StarsUnlockCopyWith<$Res> implements $JokerUnlockCopyWith<$Res> {
  factory $StarsUnlockCopyWith(StarsUnlock value, $Res Function(StarsUnlock) _then) = _$StarsUnlockCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$StarsUnlockCopyWithImpl<$Res>
    implements $StarsUnlockCopyWith<$Res> {
  _$StarsUnlockCopyWithImpl(this._self, this._then);

  final StarsUnlock _self;
  final $Res Function(StarsUnlock) _then;

/// Create a copy of JokerUnlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(StarsUnlock(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
