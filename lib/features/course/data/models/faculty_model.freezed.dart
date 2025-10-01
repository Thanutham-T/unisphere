// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faculty_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacultyModel {

 int get facultyId; String get facultyCode; String get status; DateTime? get archivedAt;
/// Create a copy of FacultyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacultyModelCopyWith<FacultyModel> get copyWith => _$FacultyModelCopyWithImpl<FacultyModel>(this as FacultyModel, _$identity);

  /// Serializes this FacultyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacultyModel&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.facultyCode, facultyCode) || other.facultyCode == facultyCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facultyId,facultyCode,status,archivedAt);

@override
String toString() {
  return 'FacultyModel(facultyId: $facultyId, facultyCode: $facultyCode, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $FacultyModelCopyWith<$Res>  {
  factory $FacultyModelCopyWith(FacultyModel value, $Res Function(FacultyModel) _then) = _$FacultyModelCopyWithImpl;
@useResult
$Res call({
 int facultyId, String facultyCode, String status, DateTime? archivedAt
});




}
/// @nodoc
class _$FacultyModelCopyWithImpl<$Res>
    implements $FacultyModelCopyWith<$Res> {
  _$FacultyModelCopyWithImpl(this._self, this._then);

  final FacultyModel _self;
  final $Res Function(FacultyModel) _then;

/// Create a copy of FacultyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facultyId = null,Object? facultyCode = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,facultyCode: null == facultyCode ? _self.facultyCode : facultyCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FacultyModel].
extension FacultyModelPatterns on FacultyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacultyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacultyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacultyModel value)  $default,){
final _that = this;
switch (_that) {
case _FacultyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacultyModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacultyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int facultyId,  String facultyCode,  String status,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacultyModel() when $default != null:
return $default(_that.facultyId,_that.facultyCode,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int facultyId,  String facultyCode,  String status,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _FacultyModel():
return $default(_that.facultyId,_that.facultyCode,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int facultyId,  String facultyCode,  String status,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _FacultyModel() when $default != null:
return $default(_that.facultyId,_that.facultyCode,_that.status,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacultyModel implements FacultyModel {
  const _FacultyModel({required this.facultyId, required this.facultyCode, this.status = 'active', this.archivedAt});
  factory _FacultyModel.fromJson(Map<String, dynamic> json) => _$FacultyModelFromJson(json);

@override final  int facultyId;
@override final  String facultyCode;
@override@JsonKey() final  String status;
@override final  DateTime? archivedAt;

/// Create a copy of FacultyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacultyModelCopyWith<_FacultyModel> get copyWith => __$FacultyModelCopyWithImpl<_FacultyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacultyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacultyModel&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.facultyCode, facultyCode) || other.facultyCode == facultyCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facultyId,facultyCode,status,archivedAt);

@override
String toString() {
  return 'FacultyModel(facultyId: $facultyId, facultyCode: $facultyCode, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$FacultyModelCopyWith<$Res> implements $FacultyModelCopyWith<$Res> {
  factory _$FacultyModelCopyWith(_FacultyModel value, $Res Function(_FacultyModel) _then) = __$FacultyModelCopyWithImpl;
@override @useResult
$Res call({
 int facultyId, String facultyCode, String status, DateTime? archivedAt
});




}
/// @nodoc
class __$FacultyModelCopyWithImpl<$Res>
    implements _$FacultyModelCopyWith<$Res> {
  __$FacultyModelCopyWithImpl(this._self, this._then);

  final _FacultyModel _self;
  final $Res Function(_FacultyModel) _then;

/// Create a copy of FacultyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facultyId = null,Object? facultyCode = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_FacultyModel(
facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,facultyCode: null == facultyCode ? _self.facultyCode : facultyCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
