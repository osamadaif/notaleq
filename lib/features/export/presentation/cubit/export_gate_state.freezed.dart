// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_gate_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportGateState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState()';
}


}

/// @nodoc
class $ExportGateStateCopyWith<$Res>  {
$ExportGateStateCopyWith(ExportGateState _, $Res Function(ExportGateState) __);
}


/// Adds pattern-matching-related methods to [ExportGateState].
extension ExportGateStatePatterns on ExportGateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExportGateInitial value)?  initial,TResult Function( ExportGateOffline value)?  offline,TResult Function( ExportGateAwaitingOptIn value)?  awaitingOptIn,TResult Function( ExportGateLoadingAd value)?  loadingAd,TResult Function( ExportGateShowingAd value)?  showingAd,TResult Function( ExportGateUnlocked value)?  unlocked,TResult Function( ExportGateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExportGateInitial() when initial != null:
return initial(_that);case ExportGateOffline() when offline != null:
return offline(_that);case ExportGateAwaitingOptIn() when awaitingOptIn != null:
return awaitingOptIn(_that);case ExportGateLoadingAd() when loadingAd != null:
return loadingAd(_that);case ExportGateShowingAd() when showingAd != null:
return showingAd(_that);case ExportGateUnlocked() when unlocked != null:
return unlocked(_that);case ExportGateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExportGateInitial value)  initial,required TResult Function( ExportGateOffline value)  offline,required TResult Function( ExportGateAwaitingOptIn value)  awaitingOptIn,required TResult Function( ExportGateLoadingAd value)  loadingAd,required TResult Function( ExportGateShowingAd value)  showingAd,required TResult Function( ExportGateUnlocked value)  unlocked,required TResult Function( ExportGateError value)  error,}){
final _that = this;
switch (_that) {
case ExportGateInitial():
return initial(_that);case ExportGateOffline():
return offline(_that);case ExportGateAwaitingOptIn():
return awaitingOptIn(_that);case ExportGateLoadingAd():
return loadingAd(_that);case ExportGateShowingAd():
return showingAd(_that);case ExportGateUnlocked():
return unlocked(_that);case ExportGateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExportGateInitial value)?  initial,TResult? Function( ExportGateOffline value)?  offline,TResult? Function( ExportGateAwaitingOptIn value)?  awaitingOptIn,TResult? Function( ExportGateLoadingAd value)?  loadingAd,TResult? Function( ExportGateShowingAd value)?  showingAd,TResult? Function( ExportGateUnlocked value)?  unlocked,TResult? Function( ExportGateError value)?  error,}){
final _that = this;
switch (_that) {
case ExportGateInitial() when initial != null:
return initial(_that);case ExportGateOffline() when offline != null:
return offline(_that);case ExportGateAwaitingOptIn() when awaitingOptIn != null:
return awaitingOptIn(_that);case ExportGateLoadingAd() when loadingAd != null:
return loadingAd(_that);case ExportGateShowingAd() when showingAd != null:
return showingAd(_that);case ExportGateUnlocked() when unlocked != null:
return unlocked(_that);case ExportGateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  offline,TResult Function()?  awaitingOptIn,TResult Function()?  loadingAd,TResult Function()?  showingAd,TResult Function()?  unlocked,TResult Function( Failures failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExportGateInitial() when initial != null:
return initial();case ExportGateOffline() when offline != null:
return offline();case ExportGateAwaitingOptIn() when awaitingOptIn != null:
return awaitingOptIn();case ExportGateLoadingAd() when loadingAd != null:
return loadingAd();case ExportGateShowingAd() when showingAd != null:
return showingAd();case ExportGateUnlocked() when unlocked != null:
return unlocked();case ExportGateError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  offline,required TResult Function()  awaitingOptIn,required TResult Function()  loadingAd,required TResult Function()  showingAd,required TResult Function()  unlocked,required TResult Function( Failures failure)  error,}) {final _that = this;
switch (_that) {
case ExportGateInitial():
return initial();case ExportGateOffline():
return offline();case ExportGateAwaitingOptIn():
return awaitingOptIn();case ExportGateLoadingAd():
return loadingAd();case ExportGateShowingAd():
return showingAd();case ExportGateUnlocked():
return unlocked();case ExportGateError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  offline,TResult? Function()?  awaitingOptIn,TResult? Function()?  loadingAd,TResult? Function()?  showingAd,TResult? Function()?  unlocked,TResult? Function( Failures failure)?  error,}) {final _that = this;
switch (_that) {
case ExportGateInitial() when initial != null:
return initial();case ExportGateOffline() when offline != null:
return offline();case ExportGateAwaitingOptIn() when awaitingOptIn != null:
return awaitingOptIn();case ExportGateLoadingAd() when loadingAd != null:
return loadingAd();case ExportGateShowingAd() when showingAd != null:
return showingAd();case ExportGateUnlocked() when unlocked != null:
return unlocked();case ExportGateError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ExportGateInitial implements ExportGateState {
  const ExportGateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.initial()';
}


}




/// @nodoc


class ExportGateOffline implements ExportGateState {
  const ExportGateOffline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateOffline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.offline()';
}


}




/// @nodoc


class ExportGateAwaitingOptIn implements ExportGateState {
  const ExportGateAwaitingOptIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateAwaitingOptIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.awaitingOptIn()';
}


}




/// @nodoc


class ExportGateLoadingAd implements ExportGateState {
  const ExportGateLoadingAd();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateLoadingAd);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.loadingAd()';
}


}




/// @nodoc


class ExportGateShowingAd implements ExportGateState {
  const ExportGateShowingAd();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateShowingAd);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.showingAd()';
}


}




/// @nodoc


class ExportGateUnlocked implements ExportGateState {
  const ExportGateUnlocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateUnlocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportGateState.unlocked()';
}


}




/// @nodoc


class ExportGateError implements ExportGateState {
  const ExportGateError(this.failure);
  

 final  Failures failure;

/// Create a copy of ExportGateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportGateErrorCopyWith<ExportGateError> get copyWith => _$ExportGateErrorCopyWithImpl<ExportGateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportGateError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ExportGateState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExportGateErrorCopyWith<$Res> implements $ExportGateStateCopyWith<$Res> {
  factory $ExportGateErrorCopyWith(ExportGateError value, $Res Function(ExportGateError) _then) = _$ExportGateErrorCopyWithImpl;
@useResult
$Res call({
 Failures failure
});




}
/// @nodoc
class _$ExportGateErrorCopyWithImpl<$Res>
    implements $ExportGateErrorCopyWith<$Res> {
  _$ExportGateErrorCopyWithImpl(this._self, this._then);

  final ExportGateError _self;
  final $Res Function(ExportGateError) _then;

/// Create a copy of ExportGateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ExportGateError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failures,
  ));
}


}

// dart format on
