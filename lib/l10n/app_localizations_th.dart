// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get app_title => 'Unisphere';

  @override
  String get home_menu => 'หน้าแรก';

  @override
  String get schedule_menu => 'ตารางเรียน';

  @override
  String get events_menu => 'กิจกรรม';

  @override
  String get groups_menu => 'กลุ่ม';

  @override
  String get announce_menu => 'ประกาศ';

  @override
  String get profile_menu => 'ฉัน';

  @override
  String get map_search_hint => 'ค้นหาในแคมปัส';

  @override
  String get map_calculating_route => 'กำลังคำนวณเส้นทาง...';

  @override
  String get map_location_permission_title => 'การอนุญาตตำแหน่ง';

  @override
  String get map_location_permission_message =>
      'แอปต้องการการอนุญาตในการเข้าถึงตำแหน่งของคุณเพื่อแสดงตำแหน่งปัจจุบันบนแผนที่';

  @override
  String get close => 'ปิด';

  @override
  String get try_again => 'ลองอีกครั้ง';
}
