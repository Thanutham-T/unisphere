// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseTranslationModel {

 int get courseId; String get languageCode; String get subjectName; String? get description;
/// Create a copy of CourseTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseTranslationModelCopyWith<CourseTranslationModel> get copyWith => _$CourseTranslationModelCopyWithImpl<CourseTranslationModel>(this as CourseTranslationModel, _$identity);

  /// Serializes this CourseTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseTranslationModel&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseId,languageCode,subjectName,description);

@override
String toString() {
  return 'CourseTranslationModel(courseId: $courseId, languageCode: $languageCode, subjectName: $subjectName, description: $description)';
}


}

/// @nodoc
abstract mixin class $CourseTranslationModelCopyWith<$Res>  {
  factory $CourseTranslationModelCopyWith(CourseTranslationModel value, $Res Function(CourseTranslationModel) _then) = _$CourseTranslationModelCopyWithImpl;
@useResult
$Res call({
 int courseId, String languageCode, String subjectName, String? description
});




}
/// @nodoc
class _$CourseTranslationModelCopyWithImpl<$Res>
    implements $CourseTranslationModelCopyWith<$Res> {
  _$CourseTranslationModelCopyWithImpl(this._self, this._then);

  final CourseTranslationModel _self;
  final $Res Function(CourseTranslationModel) _then;

/// Create a copy of CourseTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? languageCode = null,Object? subjectName = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseTranslationModel].
extension CourseTranslationModelPatterns on CourseTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int courseId,  String languageCode,  String subjectName,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseTranslationModel() when $default != null:
return $default(_that.courseId,_that.languageCode,_that.subjectName,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int courseId,  String languageCode,  String subjectName,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CourseTranslationModel():
return $default(_that.courseId,_that.languageCode,_that.subjectName,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int courseId,  String languageCode,  String subjectName,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CourseTranslationModel() when $default != null:
return $default(_that.courseId,_that.languageCode,_that.subjectName,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseTranslationModel implements CourseTranslationModel {
  const _CourseTranslationModel({required this.courseId, required this.languageCode, required this.subjectName, this.description});
  factory _CourseTranslationModel.fromJson(Map<String, dynamic> json) => _$CourseTranslationModelFromJson(json);

@override final  int courseId;
@override final  String languageCode;
@override final  String subjectName;
@override final  String? description;

/// Create a copy of CourseTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseTranslationModelCopyWith<_CourseTranslationModel> get copyWith => __$CourseTranslationModelCopyWithImpl<_CourseTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseTranslationModel&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseId,languageCode,subjectName,description);

@override
String toString() {
  return 'CourseTranslationModel(courseId: $courseId, languageCode: $languageCode, subjectName: $subjectName, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CourseTranslationModelCopyWith<$Res> implements $CourseTranslationModelCopyWith<$Res> {
  factory _$CourseTranslationModelCopyWith(_CourseTranslationModel value, $Res Function(_CourseTranslationModel) _then) = __$CourseTranslationModelCopyWithImpl;
@override @useResult
$Res call({
 int courseId, String languageCode, String subjectName, String? description
});




}
/// @nodoc
class __$CourseTranslationModelCopyWithImpl<$Res>
    implements _$CourseTranslationModelCopyWith<$Res> {
  __$CourseTranslationModelCopyWithImpl(this._self, this._then);

  final _CourseTranslationModel _self;
  final $Res Function(_CourseTranslationModel) _then;

/// Create a copy of CourseTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? languageCode = null,Object? subjectName = null,Object? description = freezed,}) {
  return _then(_CourseTranslationModel(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
