import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// Shown on top of the screen.
  ///
  /// In en, this message translates to:
  /// **'Unisphere'**
  String get app_title;

  /// Label for the home menu item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get menu_home;

  /// Label for the schedule menu item
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get menu_schedule;

  /// Label for the events menu item
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get menu_event;

  /// Label for the groups menu item
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get menu_group;

  /// Label for the announcement menu item
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get menu_announce;

  /// Label for the profile menu item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menu_profile;

  /// Label for default button on onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get onboarding_button_default;

  /// Label for the next button on onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_button_next;

  /// Label for the skip button on onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_button_skip;

  /// Label for the done button to finish onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_button_done;

  /// Title for onboarding screen 1 - Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to UNISPHERE'**
  String get onboarding_title_1;

  /// Title for onboarding screen 2 - Carry schedule anywhere
  ///
  /// In en, this message translates to:
  /// **'Carry your Schedule\nAnywhere, Anytime'**
  String get onboarding_title_2;

  /// Title for onboarding screen 3 - Highlight events
  ///
  /// In en, this message translates to:
  /// **'Hot University Events\nYou Shouldn\'t Miss!'**
  String get onboarding_title_3;

  /// Title for onboarding screen 4 - Study groups
  ///
  /// In en, this message translates to:
  /// **'Go Far Together with\nthe Right Study Group!'**
  String get onboarding_title_4;

  /// Title for onboarding screen 5 - Campus map feature
  ///
  /// In en, this message translates to:
  /// **'No Worries if You Lost,\nCampus Map is Here!'**
  String get onboarding_title_5;

  /// Title for onboarding screen 6 - Announcements feature
  ///
  /// In en, this message translates to:
  /// **'Never Miss Important\nAnnouncements!'**
  String get onboarding_title_6;

  /// Title for onboarding screen 7 - Offline access
  ///
  /// In en, this message translates to:
  /// **'Always Ready,\nEven Offline'**
  String get onboarding_title_7;

  /// Body text for onboarding screen 1 explaining app features
  ///
  /// In en, this message translates to:
  /// **'Manage university life easily in one app\nschedules, events, study groups and more.'**
  String get onboarding_body_1;

  /// Body text for onboarding screen 2 about schedule management
  ///
  /// In en, this message translates to:
  /// **'Manage and view your daily or session schedules with reminders before classes.'**
  String get onboarding_body_2;

  /// Body text for onboarding screen 3 about events
  ///
  /// In en, this message translates to:
  /// **'Discover fun campus events and join must-attend activities for the full university experience.'**
  String get onboarding_body_3;

  /// Body text for onboarding screen 4 about study groups
  ///
  /// In en, this message translates to:
  /// **'Study together! Join or start groups to chat and prep with classmates from your course or faculty.'**
  String get onboarding_body_4;

  /// Body text for onboarding screen 5 about campus map
  ///
  /// In en, this message translates to:
  /// **'Lost on campus? Use interactive maps with paths, key buildings, and location info.'**
  String get onboarding_body_5;

  /// Body text for onboarding screen 6 about announcements
  ///
  /// In en, this message translates to:
  /// **'Get real-time news and announcements with notifications to never miss the most important university updates.'**
  String get onboarding_body_6;

  /// Body text for onboarding screen 7 about offline access
  ///
  /// In en, this message translates to:
  /// **'Download schedules, announcements or maps and access them anytime even offline.'**
  String get onboarding_body_7;

  /// Search hint text in campus map
  ///
  /// In en, this message translates to:
  /// **'Search in campus'**
  String get map_search_hint;

  /// Route calculating message
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get map_calculating_route;

  /// Location permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get map_location_permission_title;

  /// Location permission dialog message
  ///
  /// In en, this message translates to:
  /// **'The app needs location permission to show your current position on the map'**
  String get map_location_permission_message;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
