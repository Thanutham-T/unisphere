import '../../../../core/logging/app_logger.dart';

/// Utility class สำหรับจัดการ compatibility ระหว่าง frontend และ backend API
/// ป้องกันปัญหาเมื่อ backend ยังไม่มี fields ใหม่
class EventApiCompatibility {
  
  /// ตรวจสอบและเพิ่ม fields ที่ขาดหายไปใน JSON response
  static Map<String, dynamic> ensureCompatibleFields(Map<String, dynamic> json) {
    final safeJson = Map<String, dynamic>.from(json);
    
    // ตรวจสอบและเพิ่ม capacity management fields
    if (!safeJson.containsKey('max_capacity')) {
      safeJson['max_capacity'] = null;
      AppLogger.debug('🔧 Added missing max_capacity field (null = unlimited)');
    }
    
    if (!safeJson.containsKey('registration_count')) {
      safeJson['registration_count'] = 0;
      AppLogger.debug('🔧 Added missing registration_count field (defaulted to 0)');
    }
    
    if (!safeJson.containsKey('is_full')) {
      // คำนวณ is_full จาก fields ที่มี
      final maxCapacity = safeJson['max_capacity'] as int?;
      final registrationCount = safeJson['registration_count'] as int? ?? 0;
      
      if (maxCapacity != null && registrationCount >= maxCapacity) {
        safeJson['is_full'] = true;
      } else {
        safeJson['is_full'] = false;
      }
      
      AppLogger.debug('🔧 Added missing is_full field (calculated: ${safeJson['is_full']})');
    }
    
    if (!safeJson.containsKey('is_registered')) {
      safeJson['is_registered'] = false;
      AppLogger.debug('🔧 Added missing is_registered field (defaulted to false)');
    }
    
    // ตรวจสอบ required fields
    _validateRequiredFields(safeJson);
    
    return safeJson;
  }
  
  /// ตรวจสอบว่า required fields ครบหรือไม่
  static void _validateRequiredFields(Map<String, dynamic> json) {
    final requiredFields = [
      'id', 'title', 'status', 'date', 
      'created_by', 'created_at', 'updated_at'
    ];
    
    for (final field in requiredFields) {
      if (!json.containsKey(field) || json[field] == null) {
        AppLogger.warning('⚠️ Missing required field: $field');
        
        // เพิ่ม fallback values สำหรับ required fields
        switch (field) {
          case 'id':
            json[field] = 0;
            break;
          case 'title':
            json[field] = 'Unknown Event';
            break;
          case 'status':
            json[field] = 'active';
            break;
          case 'date':
            json[field] = DateTime.now().toIso8601String();
            break;
          case 'created_by':
            json[field] = 1;
            break;
          case 'created_at':
          case 'updated_at':
            json[field] = DateTime.now().toIso8601String();
            break;
        }
      }
    }
  }

  /// ตรวจสอบว่า field ใดที่หายไปจาก API response
  static List<String> getMissingFields(Map<String, dynamic> json) {
    final requiredFields = [
      'id', 'title', 'status', 'date', 'created_by', 
      'created_at', 'updated_at'
    ];
    
    final capacityFields = [
      'max_capacity', 'registration_count', 'is_registered', 'is_full'
    ];
    
    final missingRequired = requiredFields.where((field) => !json.containsKey(field)).toList();
    final missingCapacity = capacityFields.where((field) => !json.containsKey(field)).toList();
    
    return [...missingRequired, ...missingCapacity];
  }

  /// สร้าง fallback EventModel จาก minimal API response
  static Map<String, dynamic> createFallbackEventData(Map<String, dynamic> json) {
    return {
      'id': json['id'] ?? 0,
      'title': json['title'] ?? 'Unknown Event',
      'description': json['description'],
      'category': json['category'],
      'image_url': json['image_url'],
      'location': json['location'],
      'status': json['status'] ?? 'active',
      'date': json['date'] ?? DateTime.now().toIso8601String(),
      'created_by': json['created_by'] ?? 0,
      'created_at': json['created_at'] ?? DateTime.now().toIso8601String(),
      'updated_at': json['updated_at'] ?? DateTime.now().toIso8601String(),
      'max_capacity': json['max_capacity'], // null = unlimited
      'registration_count': json['registration_count'] ?? 0,
      'is_registered': json['is_registered'] ?? false,
      'is_full': json['is_full'] ?? false,
    };
  }
}