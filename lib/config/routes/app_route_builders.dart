import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injector.dart' as di;
import '../../core/cubits/fullscreen_cubit.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/bloc/page_index_cubit.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/course/presentation/screens/course_screen.dart';
import '../../features/schedule/presentation/screens/schedule_screen.dart';
import '../../features/event/presentation/screens/event_screen.dart';
import '../../features/study_group/presentation/screens/study_group_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/announcement/presentation/screens/announcement_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/setting/presentation/screens/setting_screen.dart';


class RouteBuilders {
  static Widget buildSplashScreen() {
    return BlocProvider(
      create: (_) => FullscreenCubit(),
      child: const SplashScreen(),
    );
  }

  static Widget buildOnboardingScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FullscreenCubit()),
        BlocProvider(create: (_) => PageIndexCubit()),
      ],
      child: const OnboardingScreen(),
    );
  }

  static Widget buildDashboardScreen() {
    return const DashboardScreen();
  }

  static Widget buildProfileScreen() {
    return const ProfileScreen();
  }

  static Widget buildCourseScreen() {
    return const CourseScreen();
  }

  static Widget buildScheduleScreen() {
    return const ScheduleScreen();
  }

  static Widget buildEventScreen() {
    return const EventScreen();
  }

  static Widget buildStudyGroupScreen() {
    return const StudyGroupScreen();
  }

  static Widget buildMapScreen() {
    return const MapScreen();
  }

  static Widget buildAnnouncementScreen() {
    return const AnnouncementScreen();
  }

  static Widget buildLoginScreen() {
    return const LoginScreen();
  }

  static Widget buildRegisterScreen() {
    return const RegisterScreen();
  }

  static Widget buildSettingsScreen() {
    return const SettingScreen();
  }
}
