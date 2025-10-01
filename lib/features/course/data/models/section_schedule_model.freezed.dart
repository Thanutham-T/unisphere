// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SectionScheduleModel {

 int get scheduleId; int get sectionId; int get dayId; String get startTime; String get endTime; String? get note;
/// Create a copy of SectionScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionScheduleModelCopyWith<SectionScheduleModel> get copyWith => _$SectionScheduleModelCopyWithImpl<SectionScheduleModel>(this as SectionScheduleModel, _$identity);

  /// Serializes this SectionScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionScheduleModel&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleId,sectionId,dayId,startTime,endTime,note);

@override
String toString() {
  return 'SectionScheduleModel(scheduleId: $scheduleId, sectionId: $sectionId, dayId: $dayId, startTime: $startTime, endTime: $endTime, note: $note)';
}


}

/// @nodoc
abstract mixin class $SectionScheduleModelCopyWith<$Res>  {
  factory $SectionScheduleModelCopyWith(SectionScheduleModel value, $Res Function(SectionScheduleModel) _then) = _$SectionScheduleModelCopyWithImpl;
@useResult
$Res call({
 int scheduleId, int sectionId, int dayId, String startTime, String endTime, String? note
});




}
/// @nodoc
class _$SectionScheduleModelCopyWithImpl<$Res>
    implements $SectionScheduleModelCopyWith<$Res> {
  _$SectionScheduleModelCopyWithImpl(this._self, this._then);

  final SectionScheduleModel _self;
  final $Res Function(SectionScheduleModel) _then;

/// Create a copy of SectionScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? sectionId = null,Object? dayId = null,Object? startTime = null,Object? endTime = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionScheduleModel].
extension SectionScheduleModelPatterns on SectionScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _SectionScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _SectionScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  int sectionId,  int dayId,  String startTime,  String endTime,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionScheduleModel() when $default != null:
return $default(_that.scheduleId,_that.sectionId,_that.dayId,_that.startTime,_that.endTime,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  int sectionId,  int dayId,  String startTime,  String endTime,  String? note)  $default,) {final _that = this;
switch (_that) {
case _SectionScheduleModel():
return $default(_that.scheduleId,_that.sectionId,_that.dayId,_that.startTime,_that.endTime,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  int sectionId,  int dayId,  String startTime,  String endTime,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _SectionScheduleModel() when $default != null:
return $default(_that.scheduleId,_that.sectionId,_that.dayId,_that.startTime,_that.endTime,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionScheduleModel implements SectionScheduleModel {
  const _SectionScheduleModel({required this.scheduleId, required this.sectionId, required this.dayId, required this.startTime, required this.endTime, this.note});
  factory _SectionScheduleModel.fromJson(Map<String, dynamic> json) => _$SectionScheduleModelFromJson(json);

@override final  int scheduleId;
@override final  int sectionId;
@override final  int dayId;
@override final  String startTime;
@override final  String endTime;
@override final  String? note;

/// Create a copy of SectionScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionScheduleModelCopyWith<_SectionScheduleModel> get copyWith => __$SectionScheduleModelCopyWithImpl<_SectionScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionScheduleModel&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleId,sectionId,dayId,startTime,endTime,note);

@override
String toString() {
  return 'SectionScheduleModel(scheduleId: $scheduleId, sectionId: $sectionId, dayId: $dayId, startTime: $startTime, endTime: $endTime, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SectionScheduleModelCopyWith<$Res> implements $SectionScheduleModelCopyWith<$Res> {
  factory _$SectionScheduleModelCopyWith(_SectionScheduleModel value, $Res Function(_SectionScheduleModel) _then) = __$SectionScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, int sectionId, int dayId, String startTime, String endTime, String? note
});




}
/// @nodoc
class __$SectionScheduleModelCopyWithImpl<$Res>
    implements _$SectionScheduleModelCopyWith<$Res> {
  __$SectionScheduleModelCopyWithImpl(this._self, this._then);

  final _SectionScheduleModel _self;
  final $Res Function(_SectionScheduleModel) _then;

/// Create a copy of SectionScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? sectionId = null,Object? dayId = null,Object? startTime = null,Object? endTime = null,Object? note = freezed,}) {
  return _then(_SectionScheduleModel(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
