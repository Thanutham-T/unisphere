// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faculty_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacultyTranslationModel {

 int get facultyId; String get languageCode; String get name; String? get description;
/// Create a copy of FacultyTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacultyTranslationModelCopyWith<FacultyTranslationModel> get copyWith => _$FacultyTranslationModelCopyWithImpl<FacultyTranslationModel>(this as FacultyTranslationModel, _$identity);

  /// Serializes this FacultyTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacultyTranslationModel&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facultyId,languageCode,name,description);

@override
String toString() {
  return 'FacultyTranslationModel(facultyId: $facultyId, languageCode: $languageCode, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $FacultyTranslationModelCopyWith<$Res>  {
  factory $FacultyTranslationModelCopyWith(FacultyTranslationModel value, $Res Function(FacultyTranslationModel) _then) = _$FacultyTranslationModelCopyWithImpl;
@useResult
$Res call({
 int facultyId, String languageCode, String name, String? description
});




}
/// @nodoc
class _$FacultyTranslationModelCopyWithImpl<$Res>
    implements $FacultyTranslationModelCopyWith<$Res> {
  _$FacultyTranslationModelCopyWithImpl(this._self, this._then);

  final FacultyTranslationModel _self;
  final $Res Function(FacultyTranslationModel) _then;

/// Create a copy of FacultyTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facultyId = null,Object? languageCode = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FacultyTranslationModel].
extension FacultyTranslationModelPatterns on FacultyTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacultyTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacultyTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacultyTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _FacultyTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacultyTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacultyTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int facultyId,  String languageCode,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacultyTranslationModel() when $default != null:
return $default(_that.facultyId,_that.languageCode,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int facultyId,  String languageCode,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _FacultyTranslationModel():
return $default(_that.facultyId,_that.languageCode,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int facultyId,  String languageCode,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _FacultyTranslationModel() when $default != null:
return $default(_that.facultyId,_that.languageCode,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacultyTranslationModel implements FacultyTranslationModel {
  const _FacultyTranslationModel({required this.facultyId, required this.languageCode, required this.name, this.description});
  factory _FacultyTranslationModel.fromJson(Map<String, dynamic> json) => _$FacultyTranslationModelFromJson(json);

@override final  int facultyId;
@override final  String languageCode;
@override final  String name;
@override final  String? description;

/// Create a copy of FacultyTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacultyTranslationModelCopyWith<_FacultyTranslationModel> get copyWith => __$FacultyTranslationModelCopyWithImpl<_FacultyTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacultyTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacultyTranslationModel&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facultyId,languageCode,name,description);

@override
String toString() {
  return 'FacultyTranslationModel(facultyId: $facultyId, languageCode: $languageCode, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$FacultyTranslationModelCopyWith<$Res> implements $FacultyTranslationModelCopyWith<$Res> {
  factory _$FacultyTranslationModelCopyWith(_FacultyTranslationModel value, $Res Function(_FacultyTranslationModel) _then) = __$FacultyTranslationModelCopyWithImpl;
@override @useResult
$Res call({
 int facultyId, String languageCode, String name, String? description
});




}
/// @nodoc
class __$FacultyTranslationModelCopyWithImpl<$Res>
    implements _$FacultyTranslationModelCopyWith<$Res> {
  __$FacultyTranslationModelCopyWithImpl(this._self, this._then);

  final _FacultyTranslationModel _self;
  final $Res Function(_FacultyTranslationModel) _then;

/// Create a copy of FacultyTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facultyId = null,Object? languageCode = null,Object? name = null,Object? description = freezed,}) {
  return _then(_FacultyTranslationModel(
facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
