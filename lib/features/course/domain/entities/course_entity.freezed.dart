// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseEntity {

 int get courseId; String get courseCode; String get subjectName; String? get description; int get branchId; String get semester; DateTime get startDate; DateTime get endDate; int? get selectedSectionId; bool get isEnrolled; List<SectionEntity>? get sections; String get status;
/// Create a copy of CourseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseEntityCopyWith<CourseEntity> get copyWith => _$CourseEntityCopyWithImpl<CourseEntity>(this as CourseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseEntity&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.description, description) || other.description == description)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,courseId,courseCode,subjectName,description,branchId,semester,startDate,endDate,selectedSectionId,isEnrolled,const DeepCollectionEquality().hash(sections),status);

@override
String toString() {
  return 'CourseEntity(courseId: $courseId, courseCode: $courseCode, subjectName: $subjectName, description: $description, branchId: $branchId, semester: $semester, startDate: $startDate, endDate: $endDate, selectedSectionId: $selectedSectionId, isEnrolled: $isEnrolled, sections: $sections, status: $status)';
}


}

/// @nodoc
abstract mixin class $CourseEntityCopyWith<$Res>  {
  factory $CourseEntityCopyWith(CourseEntity value, $Res Function(CourseEntity) _then) = _$CourseEntityCopyWithImpl;
@useResult
$Res call({
 int courseId, String courseCode, String subjectName, String? description, int branchId, String semester, DateTime startDate, DateTime endDate, int? selectedSectionId, bool isEnrolled, List<SectionEntity>? sections, String status
});




}
/// @nodoc
class _$CourseEntityCopyWithImpl<$Res>
    implements $CourseEntityCopyWith<$Res> {
  _$CourseEntityCopyWithImpl(this._self, this._then);

  final CourseEntity _self;
  final $Res Function(CourseEntity) _then;

/// Create a copy of CourseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? courseCode = null,Object? subjectName = null,Object? description = freezed,Object? branchId = null,Object? semester = null,Object? startDate = null,Object? endDate = null,Object? selectedSectionId = freezed,Object? isEnrolled = null,Object? sections = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as int?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,sections: freezed == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionEntity>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseEntity].
extension CourseEntityPatterns on CourseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseEntity value)  $default,){
final _that = this;
switch (_that) {
case _CourseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CourseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int courseId,  String courseCode,  String subjectName,  String? description,  int branchId,  String semester,  DateTime startDate,  DateTime endDate,  int? selectedSectionId,  bool isEnrolled,  List<SectionEntity>? sections,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseEntity() when $default != null:
return $default(_that.courseId,_that.courseCode,_that.subjectName,_that.description,_that.branchId,_that.semester,_that.startDate,_that.endDate,_that.selectedSectionId,_that.isEnrolled,_that.sections,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int courseId,  String courseCode,  String subjectName,  String? description,  int branchId,  String semester,  DateTime startDate,  DateTime endDate,  int? selectedSectionId,  bool isEnrolled,  List<SectionEntity>? sections,  String status)  $default,) {final _that = this;
switch (_that) {
case _CourseEntity():
return $default(_that.courseId,_that.courseCode,_that.subjectName,_that.description,_that.branchId,_that.semester,_that.startDate,_that.endDate,_that.selectedSectionId,_that.isEnrolled,_that.sections,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int courseId,  String courseCode,  String subjectName,  String? description,  int branchId,  String semester,  DateTime startDate,  DateTime endDate,  int? selectedSectionId,  bool isEnrolled,  List<SectionEntity>? sections,  String status)?  $default,) {final _that = this;
switch (_that) {
case _CourseEntity() when $default != null:
return $default(_that.courseId,_that.courseCode,_that.subjectName,_that.description,_that.branchId,_that.semester,_that.startDate,_that.endDate,_that.selectedSectionId,_that.isEnrolled,_that.sections,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _CourseEntity implements CourseEntity {
  const _CourseEntity({required this.courseId, required this.courseCode, required this.subjectName, this.description, required this.branchId, required this.semester, required this.startDate, required this.endDate, this.selectedSectionId, this.isEnrolled = false, final  List<SectionEntity>? sections = const [], required this.status}): _sections = sections;
  

@override final  int courseId;
@override final  String courseCode;
@override final  String subjectName;
@override final  String? description;
@override final  int branchId;
@override final  String semester;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int? selectedSectionId;
@override@JsonKey() final  bool isEnrolled;
 final  List<SectionEntity>? _sections;
@override@JsonKey() List<SectionEntity>? get sections {
  final value = _sections;
  if (value == null) return null;
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String status;

/// Create a copy of CourseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseEntityCopyWith<_CourseEntity> get copyWith => __$CourseEntityCopyWithImpl<_CourseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseEntity&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.description, description) || other.description == description)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,courseId,courseCode,subjectName,description,branchId,semester,startDate,endDate,selectedSectionId,isEnrolled,const DeepCollectionEquality().hash(_sections),status);

@override
String toString() {
  return 'CourseEntity(courseId: $courseId, courseCode: $courseCode, subjectName: $subjectName, description: $description, branchId: $branchId, semester: $semester, startDate: $startDate, endDate: $endDate, selectedSectionId: $selectedSectionId, isEnrolled: $isEnrolled, sections: $sections, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CourseEntityCopyWith<$Res> implements $CourseEntityCopyWith<$Res> {
  factory _$CourseEntityCopyWith(_CourseEntity value, $Res Function(_CourseEntity) _then) = __$CourseEntityCopyWithImpl;
@override @useResult
$Res call({
 int courseId, String courseCode, String subjectName, String? description, int branchId, String semester, DateTime startDate, DateTime endDate, int? selectedSectionId, bool isEnrolled, List<SectionEntity>? sections, String status
});




}
/// @nodoc
class __$CourseEntityCopyWithImpl<$Res>
    implements _$CourseEntityCopyWith<$Res> {
  __$CourseEntityCopyWithImpl(this._self, this._then);

  final _CourseEntity _self;
  final $Res Function(_CourseEntity) _then;

/// Create a copy of CourseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? courseCode = null,Object? subjectName = null,Object? description = freezed,Object? branchId = null,Object? semester = null,Object? startDate = null,Object? endDate = null,Object? selectedSectionId = freezed,Object? isEnrolled = null,Object? sections = freezed,Object? status = null,}) {
  return _then(_CourseEntity(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as int?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,sections: freezed == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionEntity>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
