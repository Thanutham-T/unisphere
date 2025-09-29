// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseFilterState {

 String get searchQuery; String get selectedFilter;
/// Create a copy of CourseFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseFilterStateCopyWith<CourseFilterState> get copyWith => _$CourseFilterStateCopyWithImpl<CourseFilterState>(this as CourseFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseFilterState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedFilter, selectedFilter) || other.selectedFilter == selectedFilter));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,selectedFilter);

@override
String toString() {
  return 'CourseFilterState(searchQuery: $searchQuery, selectedFilter: $selectedFilter)';
}


}

/// @nodoc
abstract mixin class $CourseFilterStateCopyWith<$Res>  {
  factory $CourseFilterStateCopyWith(CourseFilterState value, $Res Function(CourseFilterState) _then) = _$CourseFilterStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, String selectedFilter
});




}
/// @nodoc
class _$CourseFilterStateCopyWithImpl<$Res>
    implements $CourseFilterStateCopyWith<$Res> {
  _$CourseFilterStateCopyWithImpl(this._self, this._then);

  final CourseFilterState _self;
  final $Res Function(CourseFilterState) _then;

/// Create a copy of CourseFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? selectedFilter = null,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedFilter: null == selectedFilter ? _self.selectedFilter : selectedFilter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseFilterState].
extension CourseFilterStatePatterns on CourseFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseFilterState value)  $default,){
final _that = this;
switch (_that) {
case _CourseFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  String selectedFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseFilterState() when $default != null:
return $default(_that.searchQuery,_that.selectedFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  String selectedFilter)  $default,) {final _that = this;
switch (_that) {
case _CourseFilterState():
return $default(_that.searchQuery,_that.selectedFilter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  String selectedFilter)?  $default,) {final _that = this;
switch (_that) {
case _CourseFilterState() when $default != null:
return $default(_that.searchQuery,_that.selectedFilter);case _:
  return null;

}
}

}

/// @nodoc


class _CourseFilterState implements CourseFilterState {
  const _CourseFilterState({this.searchQuery = '', this.selectedFilter = 'All'});
  

@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  String selectedFilter;

/// Create a copy of CourseFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseFilterStateCopyWith<_CourseFilterState> get copyWith => __$CourseFilterStateCopyWithImpl<_CourseFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseFilterState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedFilter, selectedFilter) || other.selectedFilter == selectedFilter));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,selectedFilter);

@override
String toString() {
  return 'CourseFilterState(searchQuery: $searchQuery, selectedFilter: $selectedFilter)';
}


}

/// @nodoc
abstract mixin class _$CourseFilterStateCopyWith<$Res> implements $CourseFilterStateCopyWith<$Res> {
  factory _$CourseFilterStateCopyWith(_CourseFilterState value, $Res Function(_CourseFilterState) _then) = __$CourseFilterStateCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, String selectedFilter
});




}
/// @nodoc
class __$CourseFilterStateCopyWithImpl<$Res>
    implements _$CourseFilterStateCopyWith<$Res> {
  __$CourseFilterStateCopyWithImpl(this._self, this._then);

  final _CourseFilterState _self;
  final $Res Function(_CourseFilterState) _then;

/// Create a copy of CourseFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? selectedFilter = null,}) {
  return _then(_CourseFilterState(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedFilter: null == selectedFilter ? _self.selectedFilter : selectedFilter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
