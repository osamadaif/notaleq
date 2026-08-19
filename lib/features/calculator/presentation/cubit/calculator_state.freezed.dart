// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculator_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalculatorState {

 CalcStatus get status; List<LedgerLine> get lines; int get activeIndex; int? get calculationId;/// Sheet name; null = unsaved draft.
 String? get sheetName; String? get currencyCode; int get decimalPlaces;/// True while the comment field of the active line has focus (system
/// keyboard up, numpad swapped out).
 bool get commentEditing;/// Bumped each time a non-operator key is rejected on a line that still
/// needs a leading operator — the screen shows a quick notice.
 int get operatorNoticeTick; String? get failureMessage;
/// Create a copy of CalculatorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalculatorStateCopyWith<CalculatorState> get copyWith => _$CalculatorStateCopyWithImpl<CalculatorState>(this as CalculatorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalculatorState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.calculationId, calculationId) || other.calculationId == calculationId)&&(identical(other.sheetName, sheetName) || other.sheetName == sheetName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces)&&(identical(other.commentEditing, commentEditing) || other.commentEditing == commentEditing)&&(identical(other.operatorNoticeTick, operatorNoticeTick) || other.operatorNoticeTick == operatorNoticeTick)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(lines),activeIndex,calculationId,sheetName,currencyCode,decimalPlaces,commentEditing,operatorNoticeTick,failureMessage);

@override
String toString() {
  return 'CalculatorState(status: $status, lines: $lines, activeIndex: $activeIndex, calculationId: $calculationId, sheetName: $sheetName, currencyCode: $currencyCode, decimalPlaces: $decimalPlaces, commentEditing: $commentEditing, operatorNoticeTick: $operatorNoticeTick, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class $CalculatorStateCopyWith<$Res>  {
  factory $CalculatorStateCopyWith(CalculatorState value, $Res Function(CalculatorState) _then) = _$CalculatorStateCopyWithImpl;
@useResult
$Res call({
 CalcStatus status, List<LedgerLine> lines, int activeIndex, int? calculationId, String? sheetName, String? currencyCode, int decimalPlaces, bool commentEditing, int operatorNoticeTick, String? failureMessage
});




}
/// @nodoc
class _$CalculatorStateCopyWithImpl<$Res>
    implements $CalculatorStateCopyWith<$Res> {
  _$CalculatorStateCopyWithImpl(this._self, this._then);

  final CalculatorState _self;
  final $Res Function(CalculatorState) _then;

/// Create a copy of CalculatorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? lines = null,Object? activeIndex = null,Object? calculationId = freezed,Object? sheetName = freezed,Object? currencyCode = freezed,Object? decimalPlaces = null,Object? commentEditing = null,Object? operatorNoticeTick = null,Object? failureMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalcStatus,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<LedgerLine>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,calculationId: freezed == calculationId ? _self.calculationId : calculationId // ignore: cast_nullable_to_non_nullable
as int?,sheetName: freezed == sheetName ? _self.sheetName : sheetName // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,decimalPlaces: null == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int,commentEditing: null == commentEditing ? _self.commentEditing : commentEditing // ignore: cast_nullable_to_non_nullable
as bool,operatorNoticeTick: null == operatorNoticeTick ? _self.operatorNoticeTick : operatorNoticeTick // ignore: cast_nullable_to_non_nullable
as int,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalculatorState].
extension CalculatorStatePatterns on CalculatorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalculatorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalculatorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalculatorState value)  $default,){
final _that = this;
switch (_that) {
case _CalculatorState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalculatorState value)?  $default,){
final _that = this;
switch (_that) {
case _CalculatorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalcStatus status,  List<LedgerLine> lines,  int activeIndex,  int? calculationId,  String? sheetName,  String? currencyCode,  int decimalPlaces,  bool commentEditing,  int operatorNoticeTick,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalculatorState() when $default != null:
return $default(_that.status,_that.lines,_that.activeIndex,_that.calculationId,_that.sheetName,_that.currencyCode,_that.decimalPlaces,_that.commentEditing,_that.operatorNoticeTick,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalcStatus status,  List<LedgerLine> lines,  int activeIndex,  int? calculationId,  String? sheetName,  String? currencyCode,  int decimalPlaces,  bool commentEditing,  int operatorNoticeTick,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _CalculatorState():
return $default(_that.status,_that.lines,_that.activeIndex,_that.calculationId,_that.sheetName,_that.currencyCode,_that.decimalPlaces,_that.commentEditing,_that.operatorNoticeTick,_that.failureMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalcStatus status,  List<LedgerLine> lines,  int activeIndex,  int? calculationId,  String? sheetName,  String? currencyCode,  int decimalPlaces,  bool commentEditing,  int operatorNoticeTick,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _CalculatorState() when $default != null:
return $default(_that.status,_that.lines,_that.activeIndex,_that.calculationId,_that.sheetName,_that.currencyCode,_that.decimalPlaces,_that.commentEditing,_that.operatorNoticeTick,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CalculatorState extends CalculatorState {
  const _CalculatorState({this.status = CalcStatus.loading, final  List<LedgerLine> lines = const <LedgerLine>[], this.activeIndex = 0, this.calculationId, this.sheetName, this.currencyCode, this.decimalPlaces = 2, this.commentEditing = false, this.operatorNoticeTick = 0, this.failureMessage}): _lines = lines,super._();
  

@override@JsonKey() final  CalcStatus status;
 final  List<LedgerLine> _lines;
@override@JsonKey() List<LedgerLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  int activeIndex;
@override final  int? calculationId;
/// Sheet name; null = unsaved draft.
@override final  String? sheetName;
@override final  String? currencyCode;
@override@JsonKey() final  int decimalPlaces;
/// True while the comment field of the active line has focus (system
/// keyboard up, numpad swapped out).
@override@JsonKey() final  bool commentEditing;
/// Bumped each time a non-operator key is rejected on a line that still
/// needs a leading operator — the screen shows a quick notice.
@override@JsonKey() final  int operatorNoticeTick;
@override final  String? failureMessage;

/// Create a copy of CalculatorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalculatorStateCopyWith<_CalculatorState> get copyWith => __$CalculatorStateCopyWithImpl<_CalculatorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalculatorState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.calculationId, calculationId) || other.calculationId == calculationId)&&(identical(other.sheetName, sheetName) || other.sheetName == sheetName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces)&&(identical(other.commentEditing, commentEditing) || other.commentEditing == commentEditing)&&(identical(other.operatorNoticeTick, operatorNoticeTick) || other.operatorNoticeTick == operatorNoticeTick)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_lines),activeIndex,calculationId,sheetName,currencyCode,decimalPlaces,commentEditing,operatorNoticeTick,failureMessage);

@override
String toString() {
  return 'CalculatorState(status: $status, lines: $lines, activeIndex: $activeIndex, calculationId: $calculationId, sheetName: $sheetName, currencyCode: $currencyCode, decimalPlaces: $decimalPlaces, commentEditing: $commentEditing, operatorNoticeTick: $operatorNoticeTick, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$CalculatorStateCopyWith<$Res> implements $CalculatorStateCopyWith<$Res> {
  factory _$CalculatorStateCopyWith(_CalculatorState value, $Res Function(_CalculatorState) _then) = __$CalculatorStateCopyWithImpl;
@override @useResult
$Res call({
 CalcStatus status, List<LedgerLine> lines, int activeIndex, int? calculationId, String? sheetName, String? currencyCode, int decimalPlaces, bool commentEditing, int operatorNoticeTick, String? failureMessage
});




}
/// @nodoc
class __$CalculatorStateCopyWithImpl<$Res>
    implements _$CalculatorStateCopyWith<$Res> {
  __$CalculatorStateCopyWithImpl(this._self, this._then);

  final _CalculatorState _self;
  final $Res Function(_CalculatorState) _then;

/// Create a copy of CalculatorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? lines = null,Object? activeIndex = null,Object? calculationId = freezed,Object? sheetName = freezed,Object? currencyCode = freezed,Object? decimalPlaces = null,Object? commentEditing = null,Object? operatorNoticeTick = null,Object? failureMessage = freezed,}) {
  return _then(_CalculatorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalcStatus,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<LedgerLine>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,calculationId: freezed == calculationId ? _self.calculationId : calculationId // ignore: cast_nullable_to_non_nullable
as int?,sheetName: freezed == sheetName ? _self.sheetName : sheetName // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,decimalPlaces: null == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int,commentEditing: null == commentEditing ? _self.commentEditing : commentEditing // ignore: cast_nullable_to_non_nullable
as bool,operatorNoticeTick: null == operatorNoticeTick ? _self.operatorNoticeTick : operatorNoticeTick // ignore: cast_nullable_to_non_nullable
as int,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
