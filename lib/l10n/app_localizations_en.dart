// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Unisphere';

  @override
  String get home_menu => 'Home';

  @override
  String get schedule_menu => 'Schedule';

  @override
  String get events_menu => 'Event';

  @override
  String get groups_menu => 'Group';

  @override
  String get announce_menu => 'Announce';

  @override
  String get profile_menu => 'Me';

  @override
  String get map_search_hint => 'Search in campus';

  @override
  String get map_calculating_route => 'Calculating route...';

  @override
  String get map_location_permission_title => 'Location Permission';

  @override
  String get map_location_permission_message =>
      'The app needs location permission to show your current position on the map';

  @override
  String get close => 'Close';

  @override
  String get try_again => 'Try Again';
}
