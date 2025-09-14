import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../layouts/main_layout.dart';

import '../routes/app_routes.dart';
import '../routes/app_route_builders.dart';
import '../routes/middleware.dart';

part 'app_router.g.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    final redirectPath = await Middleware().routeMiddleware(state);
    return redirectPath;
  },
  routes: $appRoutes,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('ไม่พบหน้าที่ต้องการ: ${state.matchedLocation}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => DashboardRoute().go(context),
            child: const Text('กลับไปหน้าแรก'),
          ),
        ],
      ),
    ),
  ),
);

/// ------------------ Routes ------------------

@TypedGoRoute<SplashRoute>(path: Routes.splash)
class SplashRoute extends GoRouteData with $SplashRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildSplashScreen();
}

@TypedGoRoute<OnboardingRoute>(path: Routes.onboarding)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildOnboardingScreen();
}

@TypedGoRoute<LoginRoute>(path: Routes.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildLoginScreen();
}

@TypedGoRoute<RegisterRoute>(path: Routes.register)
class RegisterRoute extends GoRouteData with $RegisterRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildRegisterScreen();
}

@TypedGoRoute<CourseRoute>(path: Routes.course)
class CourseRoute extends GoRouteData with $CourseRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildCourseScreen();
}

@TypedGoRoute<MapRoute>(path: Routes.map)
class MapRoute extends GoRouteData with $MapRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildMapScreen();
}

@TypedGoRoute<SettingRoute>(path: Routes.setting)
class SettingRoute extends GoRouteData with $SettingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildSettingsScreen();
}

/// ------------------ Shell Route ------------------

@TypedShellRoute<MainShellRoute>(
  routes: [
    TypedGoRoute<DashboardRoute>(path: Routes.dashboard),
    TypedGoRoute<ProfileRoute>(path: Routes.profile),
    TypedGoRoute<ScheduleRoute>(path: Routes.schedule),
    TypedGoRoute<EventRoute>(path: Routes.event),
    TypedGoRoute<StudyGroupRoute>(path: Routes.studyGroup),
    TypedGoRoute<AnnouncementsRoute>(path: Routes.announcement),
  ],
)
class MainShellRoute extends ShellRouteData {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return MainLayout(child: navigator);
  }
}

/// ------------------ Child Routes ------------------

class DashboardRoute extends GoRouteData with $DashboardRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildDashboardScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildProfileScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}

class ScheduleRoute extends GoRouteData with $ScheduleRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildScheduleScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}

class EventRoute extends GoRouteData with $EventRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildEventScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}

class StudyGroupRoute extends GoRouteData with $StudyGroupRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildStudyGroupScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}

class AnnouncementsRoute extends GoRouteData with $AnnouncementsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteBuilders.buildAnnouncementScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: build(context, state));
}
