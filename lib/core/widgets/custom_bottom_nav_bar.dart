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
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ??
            theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: colorScheme.secondary,
          unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.5),
          selectedLabelStyle: theme.textTheme.labelLarge,
          unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.home.provider()),
              activeIcon: ImageIcon(Assets.icons.home.provider()),
              label: localizations.menu_home,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.schedule.provider()),
              activeIcon: ImageIcon(Assets.icons.schedule.provider()),
              label: localizations.menu_schedule,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.event.provider()),
              activeIcon: ImageIcon(Assets.icons.event.provider()),
              label: localizations.menu_schedule,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.group.provider()),
              activeIcon: ImageIcon(Assets.icons.group.provider()),
              label: localizations.menu_group,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.announcement.provider()),
              activeIcon: ImageIcon(Assets.icons.announcement.provider()),
              label: localizations.menu_announce,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(Assets.icons.user.provider()),
              activeIcon: ImageIcon(Assets.icons.user.provider()),
              label: localizations.menu_profile,
            ),
          ],
        ),
      ),
    );
  }
}
