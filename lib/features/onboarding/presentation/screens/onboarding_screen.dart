import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/gen/assets.gen.dart';
import 'package:unisphere/l10n/app_localizations.dart';

import '../widgets/custom_onboard_button.dart';
import '../widgets/custom_page_view.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  void _startAutoScroll() {
    final pages = _pages;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _goToLogin() {
    context.read<FullscreenCubit>().exitFullscreen();
    LoginRoute().go(context);
  }

  void _nextPage() {
    final pages = _pages;
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  List<Widget> get _pages {
    final localizations = AppLocalizations.of(context)!;
    final assets = Assets.animations.lotties;

    return [
      CustomPageView(
        assetPath: assets.logoAnimation.path,
        titleParam: localizations.onboarding_title_1,
        bodyParam: '"${localizations.onboarding_body_1}"',
      ),
      CustomPageView(
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_2,
        bodyParam: '"${localizations.onboarding_body_2}"',
      ),
      CustomPageView(
        assetPath: assets.eventAnimation.path,
        titleParam: localizations.onboarding_title_3,
        bodyParam: '"${localizations.onboarding_body_3}"',
      ),
      CustomPageView(
        assetPath: assets.groupAnmation.path,
        titleParam: localizations.onboarding_title_4,
        bodyParam: '"${localizations.onboarding_body_4}"',
      ),
      CustomPageView(
        assetPath: assets.mapAnimation.path,
        titleParam: localizations.onboarding_title_5,
        bodyParam: '"${localizations.onboarding_body_5}"',
      ),
      CustomPageView(
        assetPath: assets.annouceAnimation.path,
        titleParam: localizations.onboarding_title_6,
        bodyParam: '"${localizations.onboarding_body_6}"',
      ),
      CustomPageView(
        assetPath: assets.offlineAnimation.path,
        titleParam: localizations.onboarding_title_7,
        bodyParam: '"${localizations.onboarding_body_7}"',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final pages = _pages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView inside Expanded to take available space
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _autoScrollTimer?.cancel();
                  _startAutoScroll();
                },
                itemBuilder: (context, index) => pages[index],
              ),
            ),

            const SizedBox(height: 20),

            // Smooth Page Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                activeDotColor: Colors.black,
                dotColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // Bottom Buttons (Skip and Next/Done)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  if (_currentPage != pages.length - 1)
                    TextButton(
                      onPressed: _goToLogin,
                      child: Text(
                        localizations.onboarding_button_skip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  // Next/Done Button
                  CustomOnboardButton(
                    nameButton: _currentPage == pages.length - 1
                        ? localizations.onboarding_button_done
                        : localizations.onboarding_button_next,
                    onTap: _nextPage,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
