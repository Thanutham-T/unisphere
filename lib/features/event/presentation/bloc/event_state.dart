import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;

  const EventLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventDetailLoaded extends EventState {
  final Event event;

  const EventDetailLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventActionLoading extends EventState {
  final String eventId;
  final String action; // 'register', 'unregister', 'create'

  const EventActionLoading(this.eventId, this.action);

  @override
  List<Object?> get props => [eventId, action];
}

class EventActionSuccess extends EventState {
  final String message;
  final Event? event; // For create event success
  final bool shouldNavigate; // Whether to navigate back

  const EventActionSuccess(this.message, {this.event, this.shouldNavigate = false});

  @override
  List<Object?> get props => [message, event, shouldNavigate];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventUnauthorized extends EventState {
  final String message;

  const EventUnauthorized(this.message);

  @override
  List<Object?> get props => [message];
}