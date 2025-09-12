import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/custom_bottom_nav_bar.dart';

import '../routes/router_export.dart';


class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    final int currentIndex = _calculateIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
        ),
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith(Routes.schedule)) return 1;
    if (location.startsWith(Routes.event)) return 2;
    if (location.startsWith(Routes.studyGroup)) return 3;
    if (location.startsWith(Routes.announcement)) return 4;
    if (location.startsWith(Routes.profile)) return 5;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        DashboardRoute().go(context);
        break;
      case 1:
        ScheduleRoute().go(context);
        break;
      case 2:
        EventRoute().go(context);
        break;
      case 3:
        StudyGroupRoute().go(context);
        break;
      case 4:
        AnnouncementsRoute().go(context);
        break;
      case 5:
        ProfileRoute().go(context);
        break;
      default:
        DashboardRoute().go(context);
    }
  }
}
