// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_of_week_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayOfWeekModel {

 int get dayId; String get dayCode;
/// Create a copy of DayOfWeekModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayOfWeekModelCopyWith<DayOfWeekModel> get copyWith => _$DayOfWeekModelCopyWithImpl<DayOfWeekModel>(this as DayOfWeekModel, _$identity);

  /// Serializes this DayOfWeekModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayOfWeekModel&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.dayCode, dayCode) || other.dayCode == dayCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayId,dayCode);

@override
String toString() {
  return 'DayOfWeekModel(dayId: $dayId, dayCode: $dayCode)';
}


}

/// @nodoc
abstract mixin class $DayOfWeekModelCopyWith<$Res>  {
  factory $DayOfWeekModelCopyWith(DayOfWeekModel value, $Res Function(DayOfWeekModel) _then) = _$DayOfWeekModelCopyWithImpl;
@useResult
$Res call({
 int dayId, String dayCode
});




}
/// @nodoc
class _$DayOfWeekModelCopyWithImpl<$Res>
    implements $DayOfWeekModelCopyWith<$Res> {
  _$DayOfWeekModelCopyWithImpl(this._self, this._then);

  final DayOfWeekModel _self;
  final $Res Function(DayOfWeekModel) _then;

/// Create a copy of DayOfWeekModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayId = null,Object? dayCode = null,}) {
  return _then(_self.copyWith(
dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,dayCode: null == dayCode ? _self.dayCode : dayCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DayOfWeekModel].
extension DayOfWeekModelPatterns on DayOfWeekModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayOfWeekModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayOfWeekModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayOfWeekModel value)  $default,){
final _that = this;
switch (_that) {
case _DayOfWeekModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayOfWeekModel value)?  $default,){
final _that = this;
switch (_that) {
case _DayOfWeekModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayId,  String dayCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayOfWeekModel() when $default != null:
return $default(_that.dayId,_that.dayCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayId,  String dayCode)  $default,) {final _that = this;
switch (_that) {
case _DayOfWeekModel():
return $default(_that.dayId,_that.dayCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayId,  String dayCode)?  $default,) {final _that = this;
switch (_that) {
case _DayOfWeekModel() when $default != null:
return $default(_that.dayId,_that.dayCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayOfWeekModel implements DayOfWeekModel {
  const _DayOfWeekModel({required this.dayId, required this.dayCode});
  factory _DayOfWeekModel.fromJson(Map<String, dynamic> json) => _$DayOfWeekModelFromJson(json);

@override final  int dayId;
@override final  String dayCode;

/// Create a copy of DayOfWeekModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayOfWeekModelCopyWith<_DayOfWeekModel> get copyWith => __$DayOfWeekModelCopyWithImpl<_DayOfWeekModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayOfWeekModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayOfWeekModel&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.dayCode, dayCode) || other.dayCode == dayCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayId,dayCode);

@override
String toString() {
  return 'DayOfWeekModel(dayId: $dayId, dayCode: $dayCode)';
}


}

/// @nodoc
abstract mixin class _$DayOfWeekModelCopyWith<$Res> implements $DayOfWeekModelCopyWith<$Res> {
  factory _$DayOfWeekModelCopyWith(_DayOfWeekModel value, $Res Function(_DayOfWeekModel) _then) = __$DayOfWeekModelCopyWithImpl;
@override @useResult
$Res call({
 int dayId, String dayCode
});




}
/// @nodoc
class __$DayOfWeekModelCopyWithImpl<$Res>
    implements _$DayOfWeekModelCopyWith<$Res> {
  __$DayOfWeekModelCopyWithImpl(this._self, this._then);

  final _DayOfWeekModel _self;
  final $Res Function(_DayOfWeekModel) _then;

/// Create a copy of DayOfWeekModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayId = null,Object? dayCode = null,}) {
  return _then(_DayOfWeekModel(
dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,dayCode: null == dayCode ? _self.dayCode : dayCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
