// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instructor_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstructorTranslationModel {

 int get instructorId; String get languageCode; String get instructorName;
/// Create a copy of InstructorTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructorTranslationModelCopyWith<InstructorTranslationModel> get copyWith => _$InstructorTranslationModelCopyWithImpl<InstructorTranslationModel>(this as InstructorTranslationModel, _$identity);

  /// Serializes this InstructorTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructorTranslationModel&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.instructorName, instructorName) || other.instructorName == instructorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructorId,languageCode,instructorName);

@override
String toString() {
  return 'InstructorTranslationModel(instructorId: $instructorId, languageCode: $languageCode, instructorName: $instructorName)';
}


}

/// @nodoc
abstract mixin class $InstructorTranslationModelCopyWith<$Res>  {
  factory $InstructorTranslationModelCopyWith(InstructorTranslationModel value, $Res Function(InstructorTranslationModel) _then) = _$InstructorTranslationModelCopyWithImpl;
@useResult
$Res call({
 int instructorId, String languageCode, String instructorName
});




}
/// @nodoc
class _$InstructorTranslationModelCopyWithImpl<$Res>
    implements $InstructorTranslationModelCopyWith<$Res> {
  _$InstructorTranslationModelCopyWithImpl(this._self, this._then);

  final InstructorTranslationModel _self;
  final $Res Function(InstructorTranslationModel) _then;

/// Create a copy of InstructorTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instructorId = null,Object? languageCode = null,Object? instructorName = null,}) {
  return _then(_self.copyWith(
instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,instructorName: null == instructorName ? _self.instructorName : instructorName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InstructorTranslationModel].
extension InstructorTranslationModelPatterns on InstructorTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstructorTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstructorTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstructorTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _InstructorTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstructorTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstructorTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int instructorId,  String languageCode,  String instructorName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstructorTranslationModel() when $default != null:
return $default(_that.instructorId,_that.languageCode,_that.instructorName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int instructorId,  String languageCode,  String instructorName)  $default,) {final _that = this;
switch (_that) {
case _InstructorTranslationModel():
return $default(_that.instructorId,_that.languageCode,_that.instructorName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int instructorId,  String languageCode,  String instructorName)?  $default,) {final _that = this;
switch (_that) {
case _InstructorTranslationModel() when $default != null:
return $default(_that.instructorId,_that.languageCode,_that.instructorName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstructorTranslationModel implements InstructorTranslationModel {
  const _InstructorTranslationModel({required this.instructorId, required this.languageCode, required this.instructorName});
  factory _InstructorTranslationModel.fromJson(Map<String, dynamic> json) => _$InstructorTranslationModelFromJson(json);

@override final  int instructorId;
@override final  String languageCode;
@override final  String instructorName;

/// Create a copy of InstructorTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructorTranslationModelCopyWith<_InstructorTranslationModel> get copyWith => __$InstructorTranslationModelCopyWithImpl<_InstructorTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstructorTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructorTranslationModel&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.instructorName, instructorName) || other.instructorName == instructorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructorId,languageCode,instructorName);

@override
String toString() {
  return 'InstructorTranslationModel(instructorId: $instructorId, languageCode: $languageCode, instructorName: $instructorName)';
}


}

/// @nodoc
abstract mixin class _$InstructorTranslationModelCopyWith<$Res> implements $InstructorTranslationModelCopyWith<$Res> {
  factory _$InstructorTranslationModelCopyWith(_InstructorTranslationModel value, $Res Function(_InstructorTranslationModel) _then) = __$InstructorTranslationModelCopyWithImpl;
@override @useResult
$Res call({
 int instructorId, String languageCode, String instructorName
});




}
/// @nodoc
class __$InstructorTranslationModelCopyWithImpl<$Res>
    implements _$InstructorTranslationModelCopyWith<$Res> {
  __$InstructorTranslationModelCopyWithImpl(this._self, this._then);

  final _InstructorTranslationModel _self;
  final $Res Function(_InstructorTranslationModel) _then;

/// Create a copy of InstructorTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instructorId = null,Object? languageCode = null,Object? instructorName = null,}) {
  return _then(_InstructorTranslationModel(
instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,instructorName: null == instructorName ? _self.instructorName : instructorName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
