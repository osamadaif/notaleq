// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LedgerLine {

 LedgerLineKind get kind; String get rawExpression; String? get comment; LedgerJoin get join; Decimal get computedValue; bool get isError; ExpressionErrorKind? get errorKind;
/// Create a copy of LedgerLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerLineCopyWith<LedgerLine> get copyWith => _$LedgerLineCopyWithImpl<LedgerLine>(this as LedgerLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rawExpression, rawExpression) || other.rawExpression == rawExpression)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.join, join) || other.join == join)&&(identical(other.computedValue, computedValue) || other.computedValue == computedValue)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.errorKind, errorKind) || other.errorKind == errorKind));
}


@override
int get hashCode => Object.hash(runtimeType,kind,rawExpression,comment,join,computedValue,isError,errorKind);

@override
String toString() {
  return 'LedgerLine(kind: $kind, rawExpression: $rawExpression, comment: $comment, join: $join, computedValue: $computedValue, isError: $isError, errorKind: $errorKind)';
}


}

/// @nodoc
abstract mixin class $LedgerLineCopyWith<$Res>  {
  factory $LedgerLineCopyWith(LedgerLine value, $Res Function(LedgerLine) _then) = _$LedgerLineCopyWithImpl;
@useResult
$Res call({
 LedgerLineKind kind, String rawExpression, String? comment, LedgerJoin join, Decimal computedValue, bool isError, ExpressionErrorKind? errorKind
});




}
/// @nodoc
class _$LedgerLineCopyWithImpl<$Res>
    implements $LedgerLineCopyWith<$Res> {
  _$LedgerLineCopyWithImpl(this._self, this._then);

  final LedgerLine _self;
  final $Res Function(LedgerLine) _then;

/// Create a copy of LedgerLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? rawExpression = null,Object? comment = freezed,Object? join = null,Object? computedValue = null,Object? isError = null,Object? errorKind = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LedgerLineKind,rawExpression: null == rawExpression ? _self.rawExpression : rawExpression // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,join: null == join ? _self.join : join // ignore: cast_nullable_to_non_nullable
as LedgerJoin,computedValue: null == computedValue ? _self.computedValue : computedValue // ignore: cast_nullable_to_non_nullable
as Decimal,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,errorKind: freezed == errorKind ? _self.errorKind : errorKind // ignore: cast_nullable_to_non_nullable
as ExpressionErrorKind?,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerLine].
extension LedgerLinePatterns on LedgerLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerLine value)  $default,){
final _that = this;
switch (_that) {
case _LedgerLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerLine value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LedgerLineKind kind,  String rawExpression,  String? comment,  LedgerJoin join,  Decimal computedValue,  bool isError,  ExpressionErrorKind? errorKind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerLine() when $default != null:
return $default(_that.kind,_that.rawExpression,_that.comment,_that.join,_that.computedValue,_that.isError,_that.errorKind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LedgerLineKind kind,  String rawExpression,  String? comment,  LedgerJoin join,  Decimal computedValue,  bool isError,  ExpressionErrorKind? errorKind)  $default,) {final _that = this;
switch (_that) {
case _LedgerLine():
return $default(_that.kind,_that.rawExpression,_that.comment,_that.join,_that.computedValue,_that.isError,_that.errorKind);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LedgerLineKind kind,  String rawExpression,  String? comment,  LedgerJoin join,  Decimal computedValue,  bool isError,  ExpressionErrorKind? errorKind)?  $default,) {final _that = this;
switch (_that) {
case _LedgerLine() when $default != null:
return $default(_that.kind,_that.rawExpression,_that.comment,_that.join,_that.computedValue,_that.isError,_that.errorKind);case _:
  return null;

}
}

}

/// @nodoc


class _LedgerLine extends LedgerLine {
  const _LedgerLine({this.kind = LedgerLineKind.expression, this.rawExpression = '', this.comment, this.join = LedgerJoin.add, required this.computedValue, this.isError = false, this.errorKind}): super._();
  

@override@JsonKey() final  LedgerLineKind kind;
@override@JsonKey() final  String rawExpression;
@override final  String? comment;
@override@JsonKey() final  LedgerJoin join;
@override final  Decimal computedValue;
@override@JsonKey() final  bool isError;
@override final  ExpressionErrorKind? errorKind;

/// Create a copy of LedgerLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerLineCopyWith<_LedgerLine> get copyWith => __$LedgerLineCopyWithImpl<_LedgerLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rawExpression, rawExpression) || other.rawExpression == rawExpression)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.join, join) || other.join == join)&&(identical(other.computedValue, computedValue) || other.computedValue == computedValue)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.errorKind, errorKind) || other.errorKind == errorKind));
}


@override
int get hashCode => Object.hash(runtimeType,kind,rawExpression,comment,join,computedValue,isError,errorKind);

@override
String toString() {
  return 'LedgerLine(kind: $kind, rawExpression: $rawExpression, comment: $comment, join: $join, computedValue: $computedValue, isError: $isError, errorKind: $errorKind)';
}


}

/// @nodoc
abstract mixin class _$LedgerLineCopyWith<$Res> implements $LedgerLineCopyWith<$Res> {
  factory _$LedgerLineCopyWith(_LedgerLine value, $Res Function(_LedgerLine) _then) = __$LedgerLineCopyWithImpl;
@override @useResult
$Res call({
 LedgerLineKind kind, String rawExpression, String? comment, LedgerJoin join, Decimal computedValue, bool isError, ExpressionErrorKind? errorKind
});




}
/// @nodoc
class __$LedgerLineCopyWithImpl<$Res>
    implements _$LedgerLineCopyWith<$Res> {
  __$LedgerLineCopyWithImpl(this._self, this._then);

  final _LedgerLine _self;
  final $Res Function(_LedgerLine) _then;

/// Create a copy of LedgerLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? rawExpression = null,Object? comment = freezed,Object? join = null,Object? computedValue = null,Object? isError = null,Object? errorKind = freezed,}) {
  return _then(_LedgerLine(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LedgerLineKind,rawExpression: null == rawExpression ? _self.rawExpression : rawExpression // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,join: null == join ? _self.join : join // ignore: cast_nullable_to_non_nullable
as LedgerJoin,computedValue: null == computedValue ? _self.computedValue : computedValue // ignore: cast_nullable_to_non_nullable
as Decimal,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,errorKind: freezed == errorKind ? _self.errorKind : errorKind // ignore: cast_nullable_to_non_nullable
as ExpressionErrorKind?,
  ));
}


}

// dart format on
