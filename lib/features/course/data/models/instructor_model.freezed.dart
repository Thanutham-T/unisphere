// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instructor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstructorModel {

 int get instructorId; String get status; DateTime? get archivedAt;
/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<InstructorModel> get copyWith => _$InstructorModelCopyWithImpl<InstructorModel>(this as InstructorModel, _$identity);

  /// Serializes this InstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructorModel&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructorId,status,archivedAt);

@override
String toString() {
  return 'InstructorModel(instructorId: $instructorId, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $InstructorModelCopyWith<$Res>  {
  factory $InstructorModelCopyWith(InstructorModel value, $Res Function(InstructorModel) _then) = _$InstructorModelCopyWithImpl;
@useResult
$Res call({
 int instructorId, String status, DateTime? archivedAt
});




}
/// @nodoc
class _$InstructorModelCopyWithImpl<$Res>
    implements $InstructorModelCopyWith<$Res> {
  _$InstructorModelCopyWithImpl(this._self, this._then);

  final InstructorModel _self;
  final $Res Function(InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instructorId = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstructorModel].
extension InstructorModelPatterns on InstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _InstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int instructorId,  String status,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.instructorId,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int instructorId,  String status,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _InstructorModel():
return $default(_that.instructorId,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int instructorId,  String status,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.instructorId,_that.status,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstructorModel implements InstructorModel {
  const _InstructorModel({required this.instructorId, this.status = 'active', this.archivedAt});
  factory _InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);

@override final  int instructorId;
@override@JsonKey() final  String status;
@override final  DateTime? archivedAt;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructorModelCopyWith<_InstructorModel> get copyWith => __$InstructorModelCopyWithImpl<_InstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructorModel&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructorId,status,archivedAt);

@override
String toString() {
  return 'InstructorModel(instructorId: $instructorId, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$InstructorModelCopyWith<$Res> implements $InstructorModelCopyWith<$Res> {
  factory _$InstructorModelCopyWith(_InstructorModel value, $Res Function(_InstructorModel) _then) = __$InstructorModelCopyWithImpl;
@override @useResult
$Res call({
 int instructorId, String status, DateTime? archivedAt
});




}
/// @nodoc
class __$InstructorModelCopyWithImpl<$Res>
    implements _$InstructorModelCopyWith<$Res> {
  __$InstructorModelCopyWithImpl(this._self, this._then);

  final _InstructorModel _self;
  final $Res Function(_InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instructorId = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_InstructorModel(
instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
