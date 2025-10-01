// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchModel {

 int get branchId; int get facultyId; String get branchCode; String get status; DateTime? get archivedAt;
/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchModelCopyWith<BranchModel> get copyWith => _$BranchModelCopyWithImpl<BranchModel>(this as BranchModel, _$identity);

  /// Serializes this BranchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchModel&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.branchCode, branchCode) || other.branchCode == branchCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,branchId,facultyId,branchCode,status,archivedAt);

@override
String toString() {
  return 'BranchModel(branchId: $branchId, facultyId: $facultyId, branchCode: $branchCode, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $BranchModelCopyWith<$Res>  {
  factory $BranchModelCopyWith(BranchModel value, $Res Function(BranchModel) _then) = _$BranchModelCopyWithImpl;
@useResult
$Res call({
 int branchId, int facultyId, String branchCode, String status, DateTime? archivedAt
});




}
/// @nodoc
class _$BranchModelCopyWithImpl<$Res>
    implements $BranchModelCopyWith<$Res> {
  _$BranchModelCopyWithImpl(this._self, this._then);

  final BranchModel _self;
  final $Res Function(BranchModel) _then;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? facultyId = null,Object? branchCode = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,branchCode: null == branchCode ? _self.branchCode : branchCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchModel].
extension BranchModelPatterns on BranchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchModel value)  $default,){
final _that = this;
switch (_that) {
case _BranchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchModel value)?  $default,){
final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int branchId,  int facultyId,  String branchCode,  String status,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
return $default(_that.branchId,_that.facultyId,_that.branchCode,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int branchId,  int facultyId,  String branchCode,  String status,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _BranchModel():
return $default(_that.branchId,_that.facultyId,_that.branchCode,_that.status,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int branchId,  int facultyId,  String branchCode,  String status,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
return $default(_that.branchId,_that.facultyId,_that.branchCode,_that.status,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchModel implements BranchModel {
  const _BranchModel({required this.branchId, required this.facultyId, required this.branchCode, this.status = 'active', this.archivedAt});
  factory _BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);

@override final  int branchId;
@override final  int facultyId;
@override final  String branchCode;
@override@JsonKey() final  String status;
@override final  DateTime? archivedAt;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchModelCopyWith<_BranchModel> get copyWith => __$BranchModelCopyWithImpl<_BranchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchModel&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.branchCode, branchCode) || other.branchCode == branchCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,branchId,facultyId,branchCode,status,archivedAt);

@override
String toString() {
  return 'BranchModel(branchId: $branchId, facultyId: $facultyId, branchCode: $branchCode, status: $status, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$BranchModelCopyWith<$Res> implements $BranchModelCopyWith<$Res> {
  factory _$BranchModelCopyWith(_BranchModel value, $Res Function(_BranchModel) _then) = __$BranchModelCopyWithImpl;
@override @useResult
$Res call({
 int branchId, int facultyId, String branchCode, String status, DateTime? archivedAt
});




}
/// @nodoc
class __$BranchModelCopyWithImpl<$Res>
    implements _$BranchModelCopyWith<$Res> {
  __$BranchModelCopyWithImpl(this._self, this._then);

  final _BranchModel _self;
  final $Res Function(_BranchModel) _then;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? facultyId = null,Object? branchCode = null,Object? status = null,Object? archivedAt = freezed,}) {
  return _then(_BranchModel(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int,branchCode: null == branchCode ? _self.branchCode : branchCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
