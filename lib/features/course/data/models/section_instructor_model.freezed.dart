// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_instructor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SectionInstructorModel {

 int get sectionId; int get instructorId;
/// Create a copy of SectionInstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionInstructorModelCopyWith<SectionInstructorModel> get copyWith => _$SectionInstructorModelCopyWithImpl<SectionInstructorModel>(this as SectionInstructorModel, _$identity);

  /// Serializes this SectionInstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionInstructorModel&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,instructorId);

@override
String toString() {
  return 'SectionInstructorModel(sectionId: $sectionId, instructorId: $instructorId)';
}


}

/// @nodoc
abstract mixin class $SectionInstructorModelCopyWith<$Res>  {
  factory $SectionInstructorModelCopyWith(SectionInstructorModel value, $Res Function(SectionInstructorModel) _then) = _$SectionInstructorModelCopyWithImpl;
@useResult
$Res call({
 int sectionId, int instructorId
});




}
/// @nodoc
class _$SectionInstructorModelCopyWithImpl<$Res>
    implements $SectionInstructorModelCopyWith<$Res> {
  _$SectionInstructorModelCopyWithImpl(this._self, this._then);

  final SectionInstructorModel _self;
  final $Res Function(SectionInstructorModel) _then;

/// Create a copy of SectionInstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? instructorId = null,}) {
  return _then(_self.copyWith(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionInstructorModel].
extension SectionInstructorModelPatterns on SectionInstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionInstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionInstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionInstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _SectionInstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionInstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _SectionInstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sectionId,  int instructorId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionInstructorModel() when $default != null:
return $default(_that.sectionId,_that.instructorId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sectionId,  int instructorId)  $default,) {final _that = this;
switch (_that) {
case _SectionInstructorModel():
return $default(_that.sectionId,_that.instructorId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sectionId,  int instructorId)?  $default,) {final _that = this;
switch (_that) {
case _SectionInstructorModel() when $default != null:
return $default(_that.sectionId,_that.instructorId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionInstructorModel implements SectionInstructorModel {
  const _SectionInstructorModel({required this.sectionId, required this.instructorId});
  factory _SectionInstructorModel.fromJson(Map<String, dynamic> json) => _$SectionInstructorModelFromJson(json);

@override final  int sectionId;
@override final  int instructorId;

/// Create a copy of SectionInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionInstructorModelCopyWith<_SectionInstructorModel> get copyWith => __$SectionInstructorModelCopyWithImpl<_SectionInstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionInstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionInstructorModel&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,instructorId);

@override
String toString() {
  return 'SectionInstructorModel(sectionId: $sectionId, instructorId: $instructorId)';
}


}

/// @nodoc
abstract mixin class _$SectionInstructorModelCopyWith<$Res> implements $SectionInstructorModelCopyWith<$Res> {
  factory _$SectionInstructorModelCopyWith(_SectionInstructorModel value, $Res Function(_SectionInstructorModel) _then) = __$SectionInstructorModelCopyWithImpl;
@override @useResult
$Res call({
 int sectionId, int instructorId
});




}
/// @nodoc
class __$SectionInstructorModelCopyWithImpl<$Res>
    implements _$SectionInstructorModelCopyWith<$Res> {
  __$SectionInstructorModelCopyWithImpl(this._self, this._then);

  final _SectionInstructorModel _self;
  final $Res Function(_SectionInstructorModel) _then;

/// Create a copy of SectionInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? instructorId = null,}) {
  return _then(_SectionInstructorModel(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
