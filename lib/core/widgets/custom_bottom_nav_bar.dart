import 'package:flutter/material.dart';

import 'package:unisphere/gen/assets.gen.dart';
import 'package:unisphere/l10n/app_localizations.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.home.provider(), color: Colors.grey, size: 20),
            activeIcon: ImageIcon(Assets.icons.home.provider(), color: Colors.white, size: 20),
            label: AppLocalizations.of(context)?.home_menu,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.schedule.provider(), color: Colors.grey, size: 25),
            activeIcon: ImageIcon(Assets.icons.schedule.provider(), color: Colors.white, size: 25),
            label: AppLocalizations.of(context)?.schedule_menu
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.event.provider(), color: Colors.grey, size: 25),
            activeIcon: ImageIcon(Assets.icons.event.provider(), color: Colors.white, size: 25),
            label: AppLocalizations.of(context)?.schedule_menu,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.group.provider(), color: Colors.grey, size: 25),
            activeIcon: ImageIcon(Assets.icons.group.provider(), color: Colors.white, size: 25),
            label: AppLocalizations.of(context)?.groups_menu,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.announcement.provider(), color: Colors.grey, size: 25),
            activeIcon: ImageIcon(Assets.icons.announcement.provider(), color: Colors.white, size: 25),
            label: AppLocalizations.of(context)?.announce_menu,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(Assets.icons.user.provider(), color: Colors.grey, size: 20),
            activeIcon: ImageIcon(Assets.icons.user.provider(), color: Colors.white, size: 20),
            label: AppLocalizations.of(context)?.profile_menu,
          ),
        ],
      ),
    );
  }
}
