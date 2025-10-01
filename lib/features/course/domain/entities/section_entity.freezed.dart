// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SectionEntity {

 int get sectionId; String get sectionCode; int get studentLimit; String get status; List<ScheduleEntity>? get schedules; List<InstructorEntity>? get instructors; bool get isSelected;
/// Create a copy of SectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionEntityCopyWith<SectionEntity> get copyWith => _$SectionEntityCopyWithImpl<SectionEntity>(this as SectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionEntity&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionCode, sectionCode) || other.sectionCode == sectionCode)&&(identical(other.studentLimit, studentLimit) || other.studentLimit == studentLimit)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&const DeepCollectionEquality().equals(other.instructors, instructors)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionCode,studentLimit,status,const DeepCollectionEquality().hash(schedules),const DeepCollectionEquality().hash(instructors),isSelected);

@override
String toString() {
  return 'SectionEntity(sectionId: $sectionId, sectionCode: $sectionCode, studentLimit: $studentLimit, status: $status, schedules: $schedules, instructors: $instructors, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $SectionEntityCopyWith<$Res>  {
  factory $SectionEntityCopyWith(SectionEntity value, $Res Function(SectionEntity) _then) = _$SectionEntityCopyWithImpl;
@useResult
$Res call({
 int sectionId, String sectionCode, int studentLimit, String status, List<ScheduleEntity>? schedules, List<InstructorEntity>? instructors, bool isSelected
});




}
/// @nodoc
class _$SectionEntityCopyWithImpl<$Res>
    implements $SectionEntityCopyWith<$Res> {
  _$SectionEntityCopyWithImpl(this._self, this._then);

  final SectionEntity _self;
  final $Res Function(SectionEntity) _then;

/// Create a copy of SectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? sectionCode = null,Object? studentLimit = null,Object? status = null,Object? schedules = freezed,Object? instructors = freezed,Object? isSelected = null,}) {
  return _then(_self.copyWith(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,sectionCode: null == sectionCode ? _self.sectionCode : sectionCode // ignore: cast_nullable_to_non_nullable
as String,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,schedules: freezed == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ScheduleEntity>?,instructors: freezed == instructors ? _self.instructors : instructors // ignore: cast_nullable_to_non_nullable
as List<InstructorEntity>?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionEntity].
extension SectionEntityPatterns on SectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sectionId,  String sectionCode,  int studentLimit,  String status,  List<ScheduleEntity>? schedules,  List<InstructorEntity>? instructors,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionEntity() when $default != null:
return $default(_that.sectionId,_that.sectionCode,_that.studentLimit,_that.status,_that.schedules,_that.instructors,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sectionId,  String sectionCode,  int studentLimit,  String status,  List<ScheduleEntity>? schedules,  List<InstructorEntity>? instructors,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _SectionEntity():
return $default(_that.sectionId,_that.sectionCode,_that.studentLimit,_that.status,_that.schedules,_that.instructors,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sectionId,  String sectionCode,  int studentLimit,  String status,  List<ScheduleEntity>? schedules,  List<InstructorEntity>? instructors,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _SectionEntity() when $default != null:
return $default(_that.sectionId,_that.sectionCode,_that.studentLimit,_that.status,_that.schedules,_that.instructors,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc


class _SectionEntity implements SectionEntity {
  const _SectionEntity({required this.sectionId, required this.sectionCode, required this.studentLimit, this.status = 'active', final  List<ScheduleEntity>? schedules = const [], final  List<InstructorEntity>? instructors = const [], this.isSelected = false}): _schedules = schedules,_instructors = instructors;
  

@override final  int sectionId;
@override final  String sectionCode;
@override final  int studentLimit;
@override@JsonKey() final  String status;
 final  List<ScheduleEntity>? _schedules;
@override@JsonKey() List<ScheduleEntity>? get schedules {
  final value = _schedules;
  if (value == null) return null;
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<InstructorEntity>? _instructors;
@override@JsonKey() List<InstructorEntity>? get instructors {
  final value = _instructors;
  if (value == null) return null;
  if (_instructors is EqualUnmodifiableListView) return _instructors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isSelected;

/// Create a copy of SectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionEntityCopyWith<_SectionEntity> get copyWith => __$SectionEntityCopyWithImpl<_SectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionEntity&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionCode, sectionCode) || other.sectionCode == sectionCode)&&(identical(other.studentLimit, studentLimit) || other.studentLimit == studentLimit)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&const DeepCollectionEquality().equals(other._instructors, _instructors)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionCode,studentLimit,status,const DeepCollectionEquality().hash(_schedules),const DeepCollectionEquality().hash(_instructors),isSelected);

@override
String toString() {
  return 'SectionEntity(sectionId: $sectionId, sectionCode: $sectionCode, studentLimit: $studentLimit, status: $status, schedules: $schedules, instructors: $instructors, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$SectionEntityCopyWith<$Res> implements $SectionEntityCopyWith<$Res> {
  factory _$SectionEntityCopyWith(_SectionEntity value, $Res Function(_SectionEntity) _then) = __$SectionEntityCopyWithImpl;
@override @useResult
$Res call({
 int sectionId, String sectionCode, int studentLimit, String status, List<ScheduleEntity>? schedules, List<InstructorEntity>? instructors, bool isSelected
});




}
/// @nodoc
class __$SectionEntityCopyWithImpl<$Res>
    implements _$SectionEntityCopyWith<$Res> {
  __$SectionEntityCopyWithImpl(this._self, this._then);

  final _SectionEntity _self;
  final $Res Function(_SectionEntity) _then;

/// Create a copy of SectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? sectionCode = null,Object? studentLimit = null,Object? status = null,Object? schedules = freezed,Object? instructors = freezed,Object? isSelected = null,}) {
  return _then(_SectionEntity(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,sectionCode: null == sectionCode ? _self.sectionCode : sectionCode // ignore: cast_nullable_to_non_nullable
as String,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,schedules: freezed == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ScheduleEntity>?,instructors: freezed == instructors ? _self._instructors : instructors // ignore: cast_nullable_to_non_nullable
as List<InstructorEntity>?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
