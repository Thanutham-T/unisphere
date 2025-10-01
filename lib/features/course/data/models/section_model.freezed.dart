// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SectionModel {

 int get sectionId; int get courseId; String get sectionCode; int get studentLimit; String get status; DateTime? get archivedAt;
/// Create a copy of SectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionModelCopyWith<SectionModel> get copyWith => _$SectionModelCopyWithImpl<SectionModel>(this as SectionModel, _$identity);

  /// Serializes this SectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionModel&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.sectionCode, sectionCode) || other.sectionCode == sectionCode)&&(identical(other.studentLimit, studentLimit) || other.studentLimit == studentLimit)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,courseId,sectionCode,studentLimit,status,archivedAt);

@override
String toString() {
  return 'SectionModel(sectionId: $sectionId, courseId: $courseId, sectionCode: $sectionCode, studentLimit: $studentLimit, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $SectionModelCopyWith<$Res>  {
  factory $SectionModelCopyWith(SectionModel value, $Res Function(SectionModel) _then) = _$SectionModelCopyWithImpl;
@useResult
$Res call({
 int sectionId, int courseId, String sectionCode, int studentLimit, String status, DateTime? archivedAt
});




}
/// @nodoc
class _$SectionModelCopyWithImpl<$Res>
    implements $SectionModelCopyWith<$Res> {
  _$SectionModelCopyWithImpl(this._self, this._then);

  final SectionModel _self;
  final $Res Function(SectionModel) _then;

/// Create a copy of SectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? courseId = null,Object? sectionCode = null,Object? studentLimit = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,sectionCode: null == sectionCode ? _self.sectionCode : sectionCode // ignore: cast_nullable_to_non_nullable
as String,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionModel].
extension SectionModelPatterns on SectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionModel value)  $default,){
final _that = this;
switch (_that) {
case _SectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sectionId,  int courseId,  String sectionCode,  int studentLimit,  String status,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionModel() when $default != null:
return $default(_that.sectionId,_that.courseId,_that.sectionCode,_that.studentLimit,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sectionId,  int courseId,  String sectionCode,  int studentLimit,  String status,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _SectionModel():
return $default(_that.sectionId,_that.courseId,_that.sectionCode,_that.studentLimit,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sectionId,  int courseId,  String sectionCode,  int studentLimit,  String status,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _SectionModel() when $default != null:
return $default(_that.sectionId,_that.courseId,_that.sectionCode,_that.studentLimit,_that.status,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionModel implements SectionModel {
  const _SectionModel({required this.sectionId, required this.courseId, required this.sectionCode, required this.studentLimit, this.status = 'active', this.archivedAt});
  factory _SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);

@override final  int sectionId;
@override final  int courseId;
@override final  String sectionCode;
@override final  int studentLimit;
@override@JsonKey() final  String status;
@override final  DateTime? archivedAt;

/// Create a copy of SectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionModelCopyWith<_SectionModel> get copyWith => __$SectionModelCopyWithImpl<_SectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionModel&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.sectionCode, sectionCode) || other.sectionCode == sectionCode)&&(identical(other.studentLimit, studentLimit) || other.studentLimit == studentLimit)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,courseId,sectionCode,studentLimit,status,archivedAt);

@override
String toString() {
  return 'SectionModel(sectionId: $sectionId, courseId: $courseId, sectionCode: $sectionCode, studentLimit: $studentLimit, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$SectionModelCopyWith<$Res> implements $SectionModelCopyWith<$Res> {
  factory _$SectionModelCopyWith(_SectionModel value, $Res Function(_SectionModel) _then) = __$SectionModelCopyWithImpl;
@override @useResult
$Res call({
 int sectionId, int courseId, String sectionCode, int studentLimit, String status, DateTime? archivedAt
});




}
/// @nodoc
class __$SectionModelCopyWithImpl<$Res>
    implements _$SectionModelCopyWith<$Res> {
  __$SectionModelCopyWithImpl(this._self, this._then);

  final _SectionModel _self;
  final $Res Function(_SectionModel) _then;

/// Create a copy of SectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? courseId = null,Object? sectionCode = null,Object? studentLimit = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_SectionModel(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,sectionCode: null == sectionCode ? _self.sectionCode : sectionCode // ignore: cast_nullable_to_non_nullable
as String,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
