import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendCollectionService {
  final String baseUrl;
  final String? accessToken;

  const BackendCollectionService({
    required this.baseUrl,
    this.accessToken,
  });

  Future<Map<String, dynamic>?> savePlace({
    required String name,
    String? description,
    required double latitude,
    required double longitude,
    required String category,
    String? imageUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/user-places/');
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'image_url': imageUrl,
      'additional_info': additionalInfo,
    });

    final res = await http.post(uri, headers: headers, body: body);
    if (res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }
}
