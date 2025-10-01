// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchTranslationModel {

 int get branchId; String get languageCode; String get name; String? get description;
/// Create a copy of BranchTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchTranslationModelCopyWith<BranchTranslationModel> get copyWith => _$BranchTranslationModelCopyWithImpl<BranchTranslationModel>(this as BranchTranslationModel, _$identity);

  /// Serializes this BranchTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchTranslationModel&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,branchId,languageCode,name,description);

@override
String toString() {
  return 'BranchTranslationModel(branchId: $branchId, languageCode: $languageCode, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $BranchTranslationModelCopyWith<$Res>  {
  factory $BranchTranslationModelCopyWith(BranchTranslationModel value, $Res Function(BranchTranslationModel) _then) = _$BranchTranslationModelCopyWithImpl;
@useResult
$Res call({
 int branchId, String languageCode, String name, String? description
});




}
/// @nodoc
class _$BranchTranslationModelCopyWithImpl<$Res>
    implements $BranchTranslationModelCopyWith<$Res> {
  _$BranchTranslationModelCopyWithImpl(this._self, this._then);

  final BranchTranslationModel _self;
  final $Res Function(BranchTranslationModel) _then;

/// Create a copy of BranchTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? languageCode = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchTranslationModel].
extension BranchTranslationModelPatterns on BranchTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _BranchTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _BranchTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int branchId,  String languageCode,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchTranslationModel() when $default != null:
return $default(_that.branchId,_that.languageCode,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int branchId,  String languageCode,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _BranchTranslationModel():
return $default(_that.branchId,_that.languageCode,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int branchId,  String languageCode,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _BranchTranslationModel() when $default != null:
return $default(_that.branchId,_that.languageCode,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchTranslationModel implements BranchTranslationModel {
  const _BranchTranslationModel({required this.branchId, required this.languageCode, required this.name, this.description});
  factory _BranchTranslationModel.fromJson(Map<String, dynamic> json) => _$BranchTranslationModelFromJson(json);

@override final  int branchId;
@override final  String languageCode;
@override final  String name;
@override final  String? description;

/// Create a copy of BranchTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchTranslationModelCopyWith<_BranchTranslationModel> get copyWith => __$BranchTranslationModelCopyWithImpl<_BranchTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchTranslationModel&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,branchId,languageCode,name,description);

@override
String toString() {
  return 'BranchTranslationModel(branchId: $branchId, languageCode: $languageCode, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$BranchTranslationModelCopyWith<$Res> implements $BranchTranslationModelCopyWith<$Res> {
  factory _$BranchTranslationModelCopyWith(_BranchTranslationModel value, $Res Function(_BranchTranslationModel) _then) = __$BranchTranslationModelCopyWithImpl;
@override @useResult
$Res call({
 int branchId, String languageCode, String name, String? description
});




}
/// @nodoc
class __$BranchTranslationModelCopyWithImpl<$Res>
    implements _$BranchTranslationModelCopyWith<$Res> {
  __$BranchTranslationModelCopyWithImpl(this._self, this._then);

  final _BranchTranslationModel _self;
  final $Res Function(_BranchTranslationModel) _then;

/// Create a copy of BranchTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? languageCode = null,Object? name = null,Object? description = freezed,}) {
  return _then(_BranchTranslationModel(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
