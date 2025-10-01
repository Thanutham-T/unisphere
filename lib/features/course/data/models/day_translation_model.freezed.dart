// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayTranslationModel {

 int get dayId; String get languageCode; String get dayName;
/// Create a copy of DayTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayTranslationModelCopyWith<DayTranslationModel> get copyWith => _$DayTranslationModelCopyWithImpl<DayTranslationModel>(this as DayTranslationModel, _$identity);

  /// Serializes this DayTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayTranslationModel&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.dayName, dayName) || other.dayName == dayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayId,languageCode,dayName);

@override
String toString() {
  return 'DayTranslationModel(dayId: $dayId, languageCode: $languageCode, dayName: $dayName)';
}


}

/// @nodoc
abstract mixin class $DayTranslationModelCopyWith<$Res>  {
  factory $DayTranslationModelCopyWith(DayTranslationModel value, $Res Function(DayTranslationModel) _then) = _$DayTranslationModelCopyWithImpl;
@useResult
$Res call({
 int dayId, String languageCode, String dayName
});




}
/// @nodoc
class _$DayTranslationModelCopyWithImpl<$Res>
    implements $DayTranslationModelCopyWith<$Res> {
  _$DayTranslationModelCopyWithImpl(this._self, this._then);

  final DayTranslationModel _self;
  final $Res Function(DayTranslationModel) _then;

/// Create a copy of DayTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayId = null,Object? languageCode = null,Object? dayName = null,}) {
  return _then(_self.copyWith(
dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,dayName: null == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DayTranslationModel].
extension DayTranslationModelPatterns on DayTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _DayTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DayTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayId,  String languageCode,  String dayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayTranslationModel() when $default != null:
return $default(_that.dayId,_that.languageCode,_that.dayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayId,  String languageCode,  String dayName)  $default,) {final _that = this;
switch (_that) {
case _DayTranslationModel():
return $default(_that.dayId,_that.languageCode,_that.dayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayId,  String languageCode,  String dayName)?  $default,) {final _that = this;
switch (_that) {
case _DayTranslationModel() when $default != null:
return $default(_that.dayId,_that.languageCode,_that.dayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayTranslationModel implements DayTranslationModel {
  const _DayTranslationModel({required this.dayId, required this.languageCode, required this.dayName});
  factory _DayTranslationModel.fromJson(Map<String, dynamic> json) => _$DayTranslationModelFromJson(json);

@override final  int dayId;
@override final  String languageCode;
@override final  String dayName;

/// Create a copy of DayTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayTranslationModelCopyWith<_DayTranslationModel> get copyWith => __$DayTranslationModelCopyWithImpl<_DayTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayTranslationModel&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.dayName, dayName) || other.dayName == dayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayId,languageCode,dayName);

@override
String toString() {
  return 'DayTranslationModel(dayId: $dayId, languageCode: $languageCode, dayName: $dayName)';
}


}

/// @nodoc
abstract mixin class _$DayTranslationModelCopyWith<$Res> implements $DayTranslationModelCopyWith<$Res> {
  factory _$DayTranslationModelCopyWith(_DayTranslationModel value, $Res Function(_DayTranslationModel) _then) = __$DayTranslationModelCopyWithImpl;
@override @useResult
$Res call({
 int dayId, String languageCode, String dayName
});




}
/// @nodoc
class __$DayTranslationModelCopyWithImpl<$Res>
    implements _$DayTranslationModelCopyWith<$Res> {
  __$DayTranslationModelCopyWithImpl(this._self, this._then);

  final _DayTranslationModel _self;
  final $Res Function(_DayTranslationModel) _then;

/// Create a copy of DayTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayId = null,Object? languageCode = null,Object? dayName = null,}) {
  return _then(_DayTranslationModel(
dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,dayName: null == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
