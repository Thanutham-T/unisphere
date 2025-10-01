import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../network/network_client.dart';
import '../constants/api_constants.dart';

@lazySingleton
class ImageUploadService {
  final NetworkClient _networkClient;

  ImageUploadService(this._networkClient);

  Future<String> uploadEventImage(File imageFile) async {
    print('🖼️ Starting event image upload...');
    
    try {
      // Try to upload to server first
      final serverUrl = await _uploadToServer(imageFile, 'event');
      if (serverUrl != null) {
        print('✅ Event image uploaded to server: $serverUrl');
        return serverUrl;
      }
      
      print('⚠️ Server upload failed, using local storage fallback');
      // Fallback to local storage if server upload fails
      return await _saveImageLocally(imageFile, 'events');
    } catch (e) {
      print('❌ Upload error: $e');
      // If everything fails, use local storage
      return await _saveImageLocally(imageFile, 'events');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    print('👤 Starting profile image upload...');
    
    try {
      // Try to upload to server first
      final serverUrl = await _uploadToServer(imageFile, 'profile');
      if (serverUrl != null) {
        print('✅ Profile image uploaded to server: $serverUrl');
        return serverUrl;
      }
      
      print('⚠️ Server upload failed, using local storage fallback');
      // Fallback to local storage if server upload fails
      return await _saveImageLocally(imageFile, 'profiles');
    } catch (e) {
      print('❌ Upload error: $e');
      // If everything fails, use local storage
      return await _saveImageLocally(imageFile, 'profiles');
    }
  }

  Future<String?> _uploadToServer(File imageFile, String type) async {
    try {
      print('🌐 Uploading $type image to: ${ApiConstants.uploadImageEndpoint}');
      print('📁 File path: ${imageFile.path}');
      print('📏 File size: ${await imageFile.length()} bytes');
      print('📋 File exists: ${await imageFile.exists()}');
      
      // Check if file is a valid image
      final extension = path.extension(imageFile.path).toLowerCase();
      print('🔍 File extension: $extension');
      
      if (!['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension)) {
        print('❌ Invalid image extension: $extension');
        return null;
      }
      
      // Use the confirmed upload endpoint
      final response = await _networkClient.uploadFile(
        ApiConstants.uploadImageEndpoint,
        imageFile.path,
        fieldName: 'file',
      );
      
      print('📡 Upload response status: ${response.statusCode}');
      print('📡 Upload response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse different possible response formats
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          
          // Try different possible field names for the uploaded file URL/filename
          final possibleFields = ['url', 'file_url', 'path', 'filename', 'name'];
          
          for (final field in possibleFields) {
            if (data[field] != null) {
              final value = data[field] as String;
              
              // Check if it's already a full URL (starts with http)
              if (value.startsWith('http://') || value.startsWith('https://')) {
                print('✅ Got full image URL from $field: $value');
                return value;
              }
              
              // If it's just a filename or relative path, construct the full URL
              final fullUrl = '${ApiConstants.baseUrl}${ApiConstants.uploadedImageEndpoint(value)}';
              print('✅ Constructed image URL from $field: $fullUrl');
              return fullUrl;
            }
          }
        } else if (response.data is String) {
          final value = response.data as String;
          
          // Check if it's already a full URL
          if (value.startsWith('http://') || value.startsWith('https://')) {
            print('✅ Got full image URL from string: $value');
            return value;
          }
          
          // Otherwise construct the full URL
          final fullUrl = '${ApiConstants.baseUrl}${ApiConstants.uploadedImageEndpoint(value)}';
          print('✅ Constructed image URL from string: $fullUrl');
          return fullUrl;
        }
      }
      
      print('❌ Upload failed with status: ${response.statusCode}');
      return null; // Upload failed or unexpected response format
    } catch (e) {
      // Log the error for debugging
      print('❌ Upload to server failed: $e');
      return null; // Upload failed
    }
  }

  Future<String> _saveImageLocally(File imageFile, String category) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = Directory(path.join(appDir.path, 'images', category));
      
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final newPath = path.join(imageDir.path, fileName);
      
      await imageFile.copy(newPath);
      
      // Return a file URL that can be used to display the image
      return 'file://$newPath';
    } catch (e) {
      throw Exception('Failed to save image locally: $e');
    }
  }

  // Method to convert local file URL back to File for display
  File? getFileFromUrl(String url) {
    if (url.startsWith('file://')) {
      final filePath = url.substring(7); // Remove 'file://' prefix
      final file = File(filePath);
      if (file.existsSync()) {
        return file;
      }
    }
    return null;
  }
}