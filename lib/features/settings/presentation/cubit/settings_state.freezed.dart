// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 ThemeMode get themeMode; bool get soundEnabled; bool get hapticEnabled; int get decimalPlaces; String? get currencyCode;/// App language code; null = follow the device language.
 String? get languageCode;/// Real app version from the platform bundle (empty until loaded).
 String get appVersion;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,soundEnabled,hapticEnabled,decimalPlaces,currencyCode,languageCode,appVersion);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, decimalPlaces: $decimalPlaces, currencyCode: $currencyCode, languageCode: $languageCode, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, bool soundEnabled, bool hapticEnabled, int decimalPlaces, String? currencyCode, String? languageCode, String appVersion
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? soundEnabled = null,Object? hapticEnabled = null,Object? decimalPlaces = null,Object? currencyCode = freezed,Object? languageCode = freezed,Object? appVersion = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,decimalPlaces: null == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  bool soundEnabled,  bool hapticEnabled,  int decimalPlaces,  String? currencyCode,  String? languageCode,  String appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.soundEnabled,_that.hapticEnabled,_that.decimalPlaces,_that.currencyCode,_that.languageCode,_that.appVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  bool soundEnabled,  bool hapticEnabled,  int decimalPlaces,  String? currencyCode,  String? languageCode,  String appVersion)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.themeMode,_that.soundEnabled,_that.hapticEnabled,_that.decimalPlaces,_that.currencyCode,_that.languageCode,_that.appVersion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  bool soundEnabled,  bool hapticEnabled,  int decimalPlaces,  String? currencyCode,  String? languageCode,  String appVersion)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.soundEnabled,_that.hapticEnabled,_that.decimalPlaces,_that.currencyCode,_that.languageCode,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.themeMode = ThemeMode.system, this.soundEnabled = true, this.hapticEnabled = true, this.decimalPlaces = 2, this.currencyCode, this.languageCode, this.appVersion = ''});
  

@override@JsonKey() final  ThemeMode themeMode;
@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool hapticEnabled;
@override@JsonKey() final  int decimalPlaces;
@override final  String? currencyCode;
/// App language code; null = follow the device language.
@override final  String? languageCode;
/// Real app version from the platform bundle (empty until loaded).
@override@JsonKey() final  String appVersion;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,soundEnabled,hapticEnabled,decimalPlaces,currencyCode,languageCode,appVersion);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled, decimalPlaces: $decimalPlaces, currencyCode: $currencyCode, languageCode: $languageCode, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, bool soundEnabled, bool hapticEnabled, int decimalPlaces, String? currencyCode, String? languageCode, String appVersion
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? soundEnabled = null,Object? hapticEnabled = null,Object? decimalPlaces = null,Object? currencyCode = freezed,Object? languageCode = freezed,Object? appVersion = null,}) {
  return _then(_SettingsState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,decimalPlaces: null == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
