// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_registration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRegistrationModel {

 int get registrationId; int get studentId; int get courseId; int get sectionId; DateTime? get createdAt;
/// Create a copy of UserRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRegistrationModelCopyWith<UserRegistrationModel> get copyWith => _$UserRegistrationModelCopyWithImpl<UserRegistrationModel>(this as UserRegistrationModel, _$identity);

  /// Serializes this UserRegistrationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRegistrationModel&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,studentId,courseId,sectionId,createdAt);

@override
String toString() {
  return 'UserRegistrationModel(registrationId: $registrationId, studentId: $studentId, courseId: $courseId, sectionId: $sectionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserRegistrationModelCopyWith<$Res>  {
  factory $UserRegistrationModelCopyWith(UserRegistrationModel value, $Res Function(UserRegistrationModel) _then) = _$UserRegistrationModelCopyWithImpl;
@useResult
$Res call({
 int registrationId, int studentId, int courseId, int sectionId, DateTime? createdAt
});




}
/// @nodoc
class _$UserRegistrationModelCopyWithImpl<$Res>
    implements $UserRegistrationModelCopyWith<$Res> {
  _$UserRegistrationModelCopyWithImpl(this._self, this._then);

  final UserRegistrationModel _self;
  final $Res Function(UserRegistrationModel) _then;

/// Create a copy of UserRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationId = null,Object? studentId = null,Object? courseId = null,Object? sectionId = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRegistrationModel].
extension UserRegistrationModelPatterns on UserRegistrationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRegistrationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRegistrationModel value)  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRegistrationModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int registrationId,  int studentId,  int courseId,  int sectionId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRegistrationModel() when $default != null:
return $default(_that.registrationId,_that.studentId,_that.courseId,_that.sectionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int registrationId,  int studentId,  int courseId,  int sectionId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationModel():
return $default(_that.registrationId,_that.studentId,_that.courseId,_that.sectionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int registrationId,  int studentId,  int courseId,  int sectionId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationModel() when $default != null:
return $default(_that.registrationId,_that.studentId,_that.courseId,_that.sectionId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRegistrationModel implements UserRegistrationModel {
  const _UserRegistrationModel({required this.registrationId, required this.studentId, required this.courseId, required this.sectionId, this.createdAt});
  factory _UserRegistrationModel.fromJson(Map<String, dynamic> json) => _$UserRegistrationModelFromJson(json);

@override final  int registrationId;
@override final  int studentId;
@override final  int courseId;
@override final  int sectionId;
@override final  DateTime? createdAt;

/// Create a copy of UserRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRegistrationModelCopyWith<_UserRegistrationModel> get copyWith => __$UserRegistrationModelCopyWithImpl<_UserRegistrationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRegistrationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRegistrationModel&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,studentId,courseId,sectionId,createdAt);

@override
String toString() {
  return 'UserRegistrationModel(registrationId: $registrationId, studentId: $studentId, courseId: $courseId, sectionId: $sectionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserRegistrationModelCopyWith<$Res> implements $UserRegistrationModelCopyWith<$Res> {
  factory _$UserRegistrationModelCopyWith(_UserRegistrationModel value, $Res Function(_UserRegistrationModel) _then) = __$UserRegistrationModelCopyWithImpl;
@override @useResult
$Res call({
 int registrationId, int studentId, int courseId, int sectionId, DateTime? createdAt
});




}
/// @nodoc
class __$UserRegistrationModelCopyWithImpl<$Res>
    implements _$UserRegistrationModelCopyWith<$Res> {
  __$UserRegistrationModelCopyWithImpl(this._self, this._then);

  final _UserRegistrationModel _self;
  final $Res Function(_UserRegistrationModel) _then;

/// Create a copy of UserRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationId = null,Object? studentId = null,Object? courseId = null,Object? sectionId = null,Object? createdAt = freezed,}) {
  return _then(_UserRegistrationModel(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
