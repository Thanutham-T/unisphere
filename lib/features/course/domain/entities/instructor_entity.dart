import 'package:freezed_annotation/freezed_annotation.dart';

part 'instructor_entity.freezed.dart';


@freezed
abstract class InstructorEntity with _$InstructorEntity {
  const factory InstructorEntity({
    required int instructorId,
    required String instructorName,
  }) = _InstructorEntity;
}
