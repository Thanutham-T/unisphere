import 'package:injectable/injectable.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart' hide NetworkException;
import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements({
    String? category,
    String? priority,
    int? limit,
  });
  Future<AnnouncementModel> createAnnouncement(CreateAnnouncementRequest request);
  Future<AnnouncementModel> updateAnnouncement(int id, UpdateAnnouncementRequest request);
  Future<void> deleteAnnouncement(int id);
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category, {int? limit});
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority, {int? limit});
}

@LazySingleton(as: AnnouncementRemoteDataSource)
class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final NetworkClient _networkClient;

  AnnouncementRemoteDataSourceImpl(this._networkClient);

  @override
  Future<List<AnnouncementModel>> getAnnouncements({
    String? category,
    String? priority,
    int? limit,
  }) async {
    try {
      String endpoint = ApiConstants.announcementsEndpoint;
      
      // Build query parameters to match Backend API
      final queryParams = <String, String>{};
      queryParams['skip'] = '0'; // Start from beginning
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      } else {
        queryParams['limit'] = '100'; // Default limit
      }
      if (category != null) queryParams['category'] = category;
      if (priority != null) queryParams['priority'] = priority;
      
      // Add query parameters to endpoint if any
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      final response = await _networkClient.get(endpoint);
      
      if (response.isSuccess) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        return dataList.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        if (response.statusCode == 401) {
          throw const UnauthorizedException('Unauthorized access');
        }
        throw ServerException('Failed to fetch announcements: ${response.statusCode}');
      }
    } catch (e) {
      if (e is UnauthorizedException || e is ServerException) {
        rethrow;
      }
      
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<AnnouncementModel> createAnnouncement(CreateAnnouncementRequest request) async {
    try {
      final response = await _networkClient.post(
        ApiConstants.announcementsEndpoint,
        data: request.toJson(),
      );
      
      if (response.isSuccess) {
        return AnnouncementModel.fromJson(response.data);
      } else {
        if (response.statusCode == 401) {
          throw const UnauthorizedException('Unauthorized access');
        }
        throw ServerException('Failed to create announcement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is UnauthorizedException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AnnouncementModel> updateAnnouncement(int id, UpdateAnnouncementRequest request) async {
    try {
      final response = await _networkClient.put(
        ApiConstants.announcementByIdEndpoint(id.toString()),
        data: request.toJson(),
      );
      
      if (response.isSuccess) {
        return AnnouncementModel.fromJson(response.data);
      } else {
        if (response.statusCode == 401) {
          throw const UnauthorizedException('Unauthorized access');
        } else if (response.statusCode == 404) {
          throw const NotFoundException('Announcement not found');
        }
        throw ServerException('Failed to update announcement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is UnauthorizedException || e is NotFoundException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteAnnouncement(int id) async {
    try {
      final response = await _networkClient.delete(ApiConstants.announcementByIdEndpoint(id.toString()));
      
      if (!response.isSuccess) {
        if (response.statusCode == 401) {
          throw const UnauthorizedException('Unauthorized access');
        } else if (response.statusCode == 404) {
          throw const NotFoundException('Announcement not found');
        }
        throw ServerException('Failed to delete announcement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is UnauthorizedException || e is NotFoundException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category, {int? limit}) async {
    return getAnnouncements(category: category, limit: limit);
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority, {int? limit}) async {
    return getAnnouncements(priority: priority, limit: limit);
  }
}