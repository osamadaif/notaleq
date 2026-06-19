// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sheet_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SheetDetailState {

 SheetDetailStatus get status; Calculation? get sheet; List<Line> get lines; String? get failureMessage;
/// Create a copy of SheetDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SheetDetailStateCopyWith<SheetDetailState> get copyWith => _$SheetDetailStateCopyWithImpl<SheetDetailState>(this as SheetDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SheetDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.sheet, sheet) || other.sheet == sheet)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,sheet,const DeepCollectionEquality().hash(lines),failureMessage);

@override
String toString() {
  return 'SheetDetailState(status: $status, sheet: $sheet, lines: $lines, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class $SheetDetailStateCopyWith<$Res>  {
  factory $SheetDetailStateCopyWith(SheetDetailState value, $Res Function(SheetDetailState) _then) = _$SheetDetailStateCopyWithImpl;
@useResult
$Res call({
 SheetDetailStatus status, Calculation? sheet, List<Line> lines, String? failureMessage
});




}
/// @nodoc
class _$SheetDetailStateCopyWithImpl<$Res>
    implements $SheetDetailStateCopyWith<$Res> {
  _$SheetDetailStateCopyWithImpl(this._self, this._then);

  final SheetDetailState _self;
  final $Res Function(SheetDetailState) _then;

/// Create a copy of SheetDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? sheet = freezed,Object? lines = null,Object? failureMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SheetDetailStatus,sheet: freezed == sheet ? _self.sheet : sheet // ignore: cast_nullable_to_non_nullable
as Calculation?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<Line>,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SheetDetailState].
extension SheetDetailStatePatterns on SheetDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SheetDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SheetDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SheetDetailState value)  $default,){
final _that = this;
switch (_that) {
case _SheetDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SheetDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _SheetDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SheetDetailStatus status,  Calculation? sheet,  List<Line> lines,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SheetDetailState() when $default != null:
return $default(_that.status,_that.sheet,_that.lines,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SheetDetailStatus status,  Calculation? sheet,  List<Line> lines,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _SheetDetailState():
return $default(_that.status,_that.sheet,_that.lines,_that.failureMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SheetDetailStatus status,  Calculation? sheet,  List<Line> lines,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _SheetDetailState() when $default != null:
return $default(_that.status,_that.sheet,_that.lines,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SheetDetailState implements SheetDetailState {
  const _SheetDetailState({this.status = SheetDetailStatus.loading, this.sheet, final  List<Line> lines = const <Line>[], this.failureMessage}): _lines = lines;
  

@override@JsonKey() final  SheetDetailStatus status;
@override final  Calculation? sheet;
 final  List<Line> _lines;
@override@JsonKey() List<Line> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? failureMessage;

/// Create a copy of SheetDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SheetDetailStateCopyWith<_SheetDetailState> get copyWith => __$SheetDetailStateCopyWithImpl<_SheetDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SheetDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.sheet, sheet) || other.sheet == sheet)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,sheet,const DeepCollectionEquality().hash(_lines),failureMessage);

@override
String toString() {
  return 'SheetDetailState(status: $status, sheet: $sheet, lines: $lines, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$SheetDetailStateCopyWith<$Res> implements $SheetDetailStateCopyWith<$Res> {
  factory _$SheetDetailStateCopyWith(_SheetDetailState value, $Res Function(_SheetDetailState) _then) = __$SheetDetailStateCopyWithImpl;
@override @useResult
$Res call({
 SheetDetailStatus status, Calculation? sheet, List<Line> lines, String? failureMessage
});




}
/// @nodoc
class __$SheetDetailStateCopyWithImpl<$Res>
    implements _$SheetDetailStateCopyWith<$Res> {
  __$SheetDetailStateCopyWithImpl(this._self, this._then);

  final _SheetDetailState _self;
  final $Res Function(_SheetDetailState) _then;

/// Create a copy of SheetDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? sheet = freezed,Object? lines = null,Object? failureMessage = freezed,}) {
  return _then(_SheetDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SheetDetailStatus,sheet: freezed == sheet ? _self.sheet : sheet // ignore: cast_nullable_to_non_nullable
as Calculation?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<Line>,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
