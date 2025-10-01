import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/usecases/get_announcements_use_case.dart';
import '../../domain/usecases/create_announcement_use_case.dart';
import '../../domain/usecases/update_announcement_use_case.dart';
import '../../domain/usecases/delete_announcement_use_case.dart';

part 'announcement_event.dart';
part 'announcement_state.dart';

@injectable
class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase _getAnnouncements;
  final CreateAnnouncementUseCase _createAnnouncement;
  final UpdateAnnouncementUseCase _updateAnnouncement;
  final DeleteAnnouncementUseCase _deleteAnnouncement;

  AnnouncementBloc(
    this._getAnnouncements,
    this._createAnnouncement,
    this._updateAnnouncement,
    this._deleteAnnouncement,
  ) : super(AnnouncementInitial()) {
    on<GetAnnouncementsEvent>(_onGetAnnouncements);
    on<GetAnnouncementsByPriorityEvent>(_onGetAnnouncementsByPriority);
    on<GetAnnouncementsByCategoryEvent>(_onGetAnnouncementsByCategory);
    on<CreateAnnouncementEvent>(_onCreateAnnouncement);
    on<UpdateAnnouncementEvent>(_onUpdateAnnouncement);
    on<DeleteAnnouncementEvent>(_onDeleteAnnouncement);
  }

  Future<void> _onGetAnnouncements(
    GetAnnouncementsEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final result = await _getAnnouncements(
      category: event.category,
      priority: event.priority,
      limit: event.limit ?? 100,
    );
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (announcements) => emit(AnnouncementLoaded(announcements)),
    );
  }

  Future<void> _onGetAnnouncementsByPriority(
    GetAnnouncementsByPriorityEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final result = await _getAnnouncements(
      priority: event.priority,
      limit: event.limit,
    );
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (announcements) => emit(AnnouncementLoaded(announcements)),
    );
  }

  Future<void> _onGetAnnouncementsByCategory(
    GetAnnouncementsByCategoryEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final result = await _getAnnouncements(
      category: event.category,
      limit: event.limit,
    );
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (announcements) => emit(AnnouncementLoaded(announcements)),
    );
  }

  Future<void> _onCreateAnnouncement(
    CreateAnnouncementEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final params = CreateAnnouncementParams(
      title: event.title,
      content: event.content,
      category: event.category,
      priority: event.priority,
      date: event.date,
    );
    
    final result = await _createAnnouncement(params);
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (announcement) {
        emit(AnnouncementActionSuccess('Announcement created successfully'));
        // Refresh announcements
        add(const GetAnnouncementsEvent());
      },
    );
  }

  Future<void> _onUpdateAnnouncement(
    UpdateAnnouncementEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final params = UpdateAnnouncementParams(
      announcementId: event.announcementId,
      title: event.title,
      content: event.content,
      category: event.category,
      priority: event.priority,
      date: event.date,
    );
    
    final result = await _updateAnnouncement(params);
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (announcement) {
        emit(AnnouncementActionSuccess('Announcement updated successfully'));
        // Refresh announcements
        add(const GetAnnouncementsEvent());
      },
    );
  }

  Future<void> _onDeleteAnnouncement(
    DeleteAnnouncementEvent event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    final result = await _deleteAnnouncement(event.announcementId);
    
    result.fold(
      (failure) => emit(AnnouncementError(failure.toString())),
      (_) {
        emit(AnnouncementActionSuccess('Announcement deleted successfully'));
        // Refresh announcements
        add(const GetAnnouncementsEvent());
      },
    );
  }
}