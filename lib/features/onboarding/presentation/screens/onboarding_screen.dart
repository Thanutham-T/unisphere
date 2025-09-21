import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/gen/assets.gen.dart';
import 'package:unisphere/l10n/app_localizations.dart';

import '../widgets/custom_onboard_button.dart';
import '../widgets/custom_page_view.dart';
import '../bloc/page_index_cubit.dart';

class FixedPageController extends PageController {
  final int pageIndex;

  FixedPageController(this.pageIndex);

  @override
  double get page => pageIndex.toDouble();
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();
    final localizations = AppLocalizations.of(context)!;
    final assets = Assets.animations.lotties;

    final List<CustomPageView> pages = [
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
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_3,
        bodyParam: '"${localizations.onboarding_body_3}"',
      ),
      CustomPageView(
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_4,
        bodyParam: '"${localizations.onboarding_body_4}"',
      ),
      CustomPageView(
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_5,
        bodyParam: '"${localizations.onboarding_body_5}"',
      ),
      CustomPageView(
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_6,
        bodyParam: '"${localizations.onboarding_body_6}"',
      ),
      CustomPageView(
        assetPath: assets.scheduleAnimation.path,
        titleParam: localizations.onboarding_title_7,
        bodyParam: '"${localizations.onboarding_body_7}"',
      ),
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: IntroductionScreen(
            bodyPadding: EdgeInsets.only(top: 100),
            globalBackgroundColor: Colors.white,
            allowImplicitScrolling: true,
            autoScrollDuration: 3000,
            infiniteAutoScroll: true,
            showSkipButton: true,
            next: CustomOnboardButton(
              nameButton: localizations.onboarding_button_next,
            ),
            skip: Text(
              localizations.onboarding_button_skip,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            done: CustomOnboardButton(
              nameButton: localizations.onboarding_button_done,
              smallPadding: true,
            ),
            onDone: () {
              DashboardRoute().go(context);
              context.read<FullscreenCubit>().exitFullscreen();
            },
            onSkip: () {
              DashboardRoute().go(context);
              context.read<FullscreenCubit>().exitFullscreen();
            },
            onChange: (index) {
              context.read<PageIndexCubit>().updatePage(index);
            },
            pages: pages,
            dotsDecorator: const DotsDecorator(
              activeColor: Colors.transparent,
              color: Colors.transparent,
              size: Size.zero,
              activeSize: Size.zero,
            ),
          ),
        ),

        Positioned(
          bottom: 100,
          child: BlocBuilder<PageIndexCubit, int>(
            builder: (context, currentPageIndex) {
              return SmoothPageIndicator(
                count: pages.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                ),
                controller: FixedPageController(currentPageIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
