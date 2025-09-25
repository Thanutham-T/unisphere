import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class Routes {
  static const dashboard = '/';
  static const login = '/login';
  static const register = '/register';
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const profile = '/profile';
  static const schedule = '/schedule';
  static const event = '/event';
  static const studyGroup = '/studyGroup';
  static const map = '/map';
  static const announcement = '/announcement';
  static const course = '/course';
  static const setting = '/setting';
}

// Route methods for better navigation
abstract final class AppRoutes {
  static void dashboard() => (BuildContext context) => context.go(Routes.dashboard);
  static void login() => (BuildContext context) => context.go(Routes.login);
  static void register() => (BuildContext context) => context.go(Routes.register);
  static void splash() => (BuildContext context) => context.go(Routes.splash);
  static void onboarding() => (BuildContext context) => context.go(Routes.onboarding);
  static void profile() => (BuildContext context) => context.go(Routes.profile);
  static void schedule() => (BuildContext context) => context.go(Routes.schedule);
  static void event() => (BuildContext context) => context.go(Routes.event);
  static void studyGroup() => (BuildContext context) => context.go(Routes.studyGroup);
  static void map() => (BuildContext context) => context.go(Routes.map);
  static void announcement() => (BuildContext context) => context.go(Routes.announcement);
  static void course() => (BuildContext context) => context.go(Routes.course);
  static void setting() => (BuildContext context) => context.go(Routes.setting);
}

// Route navigation extensions
extension AppNavigator on BuildContext {
  void goToDashboard() => go(Routes.dashboard);
  void goToLogin() => go(Routes.login);
  void goToRegister() => go(Routes.register);
  void goToSplash() => go(Routes.splash);
  void goToOnboarding() => go(Routes.onboarding);
  void goToProfile() => go(Routes.profile);
  void goToSchedule() => go(Routes.schedule);
  void goToEvent() => go(Routes.event);
  void goToStudyGroup() => go(Routes.studyGroup);
  void goToMap() => go(Routes.map);
  void goToAnnouncement() => go(Routes.announcement);
  void goToCourse() => go(Routes.course);
  void goToSetting() => go(Routes.setting);
}