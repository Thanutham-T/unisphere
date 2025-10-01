import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/get_events_use_case.dart';
import '../../domain/usecases/get_event_by_id_use_case.dart';
import '../../domain/usecases/create_event_use_case.dart';
import '../../domain/usecases/update_event_use_case.dart';
import '../../domain/usecases/delete_event_use_case.dart';
import '../../domain/usecases/register_for_event_use_case.dart';
import '../../domain/usecases/unregister_from_event_use_case.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/exceptions/event_exceptions.dart';
import 'event_event.dart';
import 'event_state.dart';

@injectable
class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase _getEventsUseCase;
  final GetEventByIdUseCase _getEventByIdUseCase;
  final CreateEventUseCase _createEventUseCase;
  final UpdateEventUseCase _updateEventUseCase;
  final DeleteEventUseCase _deleteEventUseCase;
  final RegisterForEventUseCase _registerForEventUseCase;
  final UnregisterFromEventUseCase _unregisterFromEventUseCase;

  EventBloc(
    this._getEventsUseCase,
    this._getEventByIdUseCase,
    this._createEventUseCase,
    this._updateEventUseCase,
    this._deleteEventUseCase,
    this._registerForEventUseCase,
    this._unregisterFromEventUseCase,
  ) : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadEventById>(_onLoadEventById);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<RegisterForEvent>(_onRegisterForEvent);
    on<UnregisterFromEvent>(_onUnregisterFromEvent);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    
    final result = await _getEventsUseCase.call();
    
    result.fold(
      (failure) {
        // ตรวจสอบว่าเป็น UnauthorizedException หรือไม่
        if (failure is UnauthorizedException) {
          emit(EventUnauthorized(failure.message));
        } else {
          emit(EventError(failure.toString()));
        }
      },
      (events) => emit(EventLoaded(events)),
    );
  }

  Future<void> _onLoadEventById(LoadEventById event, Emitter<EventState> emit) async {
    // Don't emit EventLoading to avoid disrupting the list state
    
    final result = await _getEventByIdUseCase.call(event.eventId);
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          emit(EventUnauthorized(failure.message));
        } else {
          emit(EventError(failure.toString()));
        }
      },
      (eventDetail) => emit(EventDetailLoaded(eventDetail)),
    );
  }

  Future<void> _onCreateEvent(CreateEvent event, Emitter<EventState> emit) async {
    emit(const EventActionLoading('', 'create'));
    
    final params = CreateEventParams(
      title: event.title,
      description: event.description,
      category: event.category,
      imageUrl: event.imageUrl,
      date: event.date,
      location: event.location,
      maxCapacity: event.maxCapacity,
    );
    
    final result = await _createEventUseCase.call(params);
    
    // Extract result first, then emit
    String? errorMessage;
    Event? newEvent;
    UnauthorizedException? unauthorizedException;
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        }
        errorMessage = failure.toString();
      },
      (event) {
        newEvent = event;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else {
      // Auto-reload events after successful creation
      await _refreshEventsList(emit);
      emit(EventActionSuccess('กิจกรรมถูกสร้างเรียบร้อยแล้ว', event: newEvent, shouldNavigate: true));
    }
  }

  Future<void> _onRegisterForEvent(RegisterForEvent event, Emitter<EventState> emit) async {
    emit(EventActionLoading(event.eventId, 'register'));
    
    final result = await _registerForEventUseCase.call(event.eventId);
    
    // Extract result first, then emit
    String? errorMessage;
    UnauthorizedException? unauthorizedException;
    EventFullException? eventFullException;
    AlreadyRegisteredException? alreadyRegisteredException;
    bool isSuccess = false;
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        } else if (failure is EventFullException) {
          eventFullException = failure;
        } else if (failure is AlreadyRegisteredException) {
          alreadyRegisteredException = failure;
        }
        errorMessage = failure.toString();
      },
      (_) {
        isSuccess = true;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else if (eventFullException != null) {
        emit(EventError(eventFullException!.message));
      } else if (alreadyRegisteredException != null) {
        emit(EventError(alreadyRegisteredException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else if (isSuccess) {
      // Auto-reload events after successful registration
      await _refreshEventsList(emit);
      emit(const EventActionSuccess('ลงทะเบียนกิจกรรมเรียบร้อยแล้ว'));
    }
  }

  Future<void> _onUnregisterFromEvent(UnregisterFromEvent event, Emitter<EventState> emit) async {
    emit(EventActionLoading(event.eventId, 'unregister'));
    
    final result = await _unregisterFromEventUseCase.call(event.eventId);
    
    // Extract result first, then emit
    String? errorMessage;
    UnauthorizedException? unauthorizedException;
    bool isSuccess = false;
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        }
        errorMessage = failure.toString();
      },
      (_) {
        isSuccess = true;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else if (isSuccess) {
      // Auto-reload events after successful unregistration  
      await _refreshEventsList(emit);
      emit(const EventActionSuccess('ยกเลิกการลงทะเบียนเรียบร้อยแล้ว'));
    }
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    emit(EventActionLoading(event.eventId, 'update'));
    
    final params = UpdateEventParams(
      eventId: event.eventId,
      title: event.title,
      description: event.description,
      category: event.category,
      imageUrl: event.imageUrl,
      location: event.location,
      status: event.status,
      date: event.date,
      maxCapacity: event.maxCapacity, // 🆕 เพิ่ม maxCapacity
    );
    
    final result = await _updateEventUseCase.call(params);
    
    // Extract result first, then emit
    String? errorMessage;
    Event? updatedEvent;
    UnauthorizedException? unauthorizedException;
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        }
        errorMessage = failure.toString();
      },
      (event) {
        updatedEvent = event;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else {
      // Auto-reload events after successful update
      await _refreshEventsList(emit);
      emit(EventActionSuccess('กิจกรรมถูกอัปเดตเรียบร้อยแล้ว', event: updatedEvent, shouldNavigate: true));
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    emit(EventActionLoading(event.eventId, 'delete'));
    
    final result = await _deleteEventUseCase.call(event.eventId);
    
    // Extract result first, then emit
    String? errorMessage;
    UnauthorizedException? unauthorizedException;
    bool isSuccess = false;
    
    result.fold(
      (failure) {
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        }
        errorMessage = failure.toString();
      },
      (_) {
        isSuccess = true;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else if (isSuccess) {
      // Auto-reload events after successful deletion
      await _refreshEventsList(emit);
      // Don't emit EventActionSuccess to avoid overriding EventLoaded
    }
  }

  Future<void> _onRefreshEvents(RefreshEvents event, Emitter<EventState> emit) async {
    // Don't show loading for refresh
    await _refreshEventsList(emit);
  }

  // Helper method to refresh events list
  Future<void> _refreshEventsList(Emitter<EventState> emit) async {
    print('🔄 EventBloc: Refreshing events list...');
    final result = await _getEventsUseCase.call();
    
    // Extract result first, then emit
    String? errorMessage;
    List<Event>? events;
    UnauthorizedException? unauthorizedException;
    
    result.fold(
      (failure) {
        print('❌ EventBloc: Failed to refresh events - ${failure.toString()}');
        if (failure is UnauthorizedException) {
          unauthorizedException = failure;
        }
        errorMessage = failure.toString();
      },
      (eventsList) {
        print('✅ EventBloc: Successfully refreshed ${eventsList.length} events');
        events = eventsList;
      },
    );
    
    // Emit based on extracted result
    if (errorMessage != null) {
      if (unauthorizedException != null) {
        emit(EventUnauthorized(unauthorizedException!.message));
      } else {
        emit(EventError(errorMessage!));
      }
    } else {
      emit(EventLoaded(events!));
    }
  }
}