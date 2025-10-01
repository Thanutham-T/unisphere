import 'package:injectable/injectable.dart';
import '../models/event_model.dart';
import '../../../../core/network/network_client.dart' as network;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/exceptions/event_exceptions.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents();
  Future<EventModel> getEventById(String eventId);
  Future<EventModel> createEvent(CreateEventRequest request);
  Future<EventModel> updateEvent(String eventId, UpdateEventRequest request);
  Future<void> deleteEvent(String eventId);
  Future<void> registerForEvent(String eventId, {String? notes});
  Future<void> unregisterFromEvent(String eventId);
  Future<List<EventModel>> getUserRegisteredEvents();
}

@LazySingleton(as: EventRemoteDataSource)
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final network.NetworkClient _networkClient;

  EventRemoteDataSourceImpl(this._networkClient);

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      AppLogger.debug('🎉 Fetching events from API');
      
      final response = await _networkClient.get(ApiConstants.eventsEndpoint);
      AppLogger.debug('✅ Got events response: ${response.statusCode}');
      
      final List<dynamic> eventsJson = response.data;
      final events = eventsJson.map((json) {
        return EventModel.fromJson(json);
      }).toList();
      
      AppLogger.debug('✅ Successfully parsed ${events.length} events with capacity data');
      return events;
      
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      AppLogger.error('❌ Error fetching events: $e');
      throw NetworkException('Failed to fetch events: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> getEventById(String eventId) async {
    try {
      final endpoint = ApiConstants.eventByIdEndpoint(eventId);
      AppLogger.debug('🎯 Fetching event by ID: $eventId');
      
      final response = await _networkClient.get(endpoint);
      AppLogger.debug('✅ Got event response: ${response.statusCode}');
      
      return EventModel.fromJson(response.data);
      
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      AppLogger.error('❌ Error fetching event $eventId: $e');
      throw NetworkException('Failed to fetch event: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> createEvent(CreateEventRequest request) async {
    try {
      final response = await _networkClient.post(
        ApiConstants.eventsEndpoint,
        data: request.toJson(),
      );
      return EventModel.fromJson(response.data);
    } on UnauthorizedException {
      rethrow;
    } on network.NetworkException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<EventModel> updateEvent(String eventId, UpdateEventRequest request) async {
    try {
      final endpoint = ApiConstants.eventByIdEndpoint(eventId);
      final response = await _networkClient.put(
        endpoint,
        data: request.toJson(),
      );
      return EventModel.fromJson(response.data);
    } on UnauthorizedException {
      rethrow;
    } on network.NetworkException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      final endpoint = ApiConstants.eventByIdEndpoint(eventId);
      await _networkClient.delete(endpoint);
    } on UnauthorizedException {
      rethrow;
    } on network.NetworkException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> registerForEvent(String eventId, {String? notes}) async {
    try {
      final endpoint = '${ApiConstants.eventByIdEndpoint(eventId)}/register';
      AppLogger.debug('🎫 Registering for event: $eventId');
      
      // ส่ง request body ที่ Backend ต้องการ
      final request = EventRegistrationRequest(notes: notes);
      await _networkClient.post(endpoint, data: request.toJson());
      AppLogger.debug('✅ Successfully registered for event: $eventId');
      
    } on UnauthorizedException {
      rethrow;
    } on network.NetworkException catch (e) {
      AppLogger.warning('⚠️ Registration failed: ${e.message}');
      
      if (e.statusCode == 400) {
        if (e.message.contains('Event is full') || e.message.contains('full')) {
          throw EventFullException('กิจกรรมนี้เต็มแล้ว ไม่สามารถลงทะเบียนได้');
        } else if (e.message.contains('Already registered') || e.message.contains('already')) {
          throw AlreadyRegisteredException('คุณได้ลงทะเบียนกิจกรรมนี้แล้ว');
        }
      }
      throw EventRegistrationException(e.message);
    } catch (e) {
      AppLogger.error('❌ Registration error: $e');
      throw EventRegistrationException('เกิดข้อผิดพลาดในการลงทะเบียน: ${e.toString()}');
    }
  }

  @override
  Future<void> unregisterFromEvent(String eventId) async {
    try {
      final endpoint = '${ApiConstants.eventByIdEndpoint(eventId)}/register';
      AppLogger.debug('🚫 Unregistering from event: $eventId');
      
      await _networkClient.delete(endpoint);
      AppLogger.debug('✅ Successfully unregistered from event: $eventId');
      
    } on UnauthorizedException {
      rethrow;
    } on network.NetworkException catch (e) {
      AppLogger.error('❌ Unregistration failed: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      AppLogger.error('❌ Unregistration error: $e');
      throw Exception('เกิดข้อผิดพลาดในการยกเลิกการลงทะเบียน: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getUserRegisteredEvents() async {
    try {
      AppLogger.debug('📋 Fetching user registered events');
      
      final response = await _networkClient.get(ApiConstants.userRegisteredEventsEndpoint);
      final List<dynamic> eventsJson = response.data;
      final events = eventsJson.map((json) => EventModel.fromJson(json)).toList();
      
      AppLogger.debug('✅ Successfully fetched ${events.length} registered events');
      return events;
      
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      AppLogger.error('❌ Error fetching user registered events: $e');
      throw NetworkException('Failed to fetch registered events: ${e.toString()}');
    }
  }
}
