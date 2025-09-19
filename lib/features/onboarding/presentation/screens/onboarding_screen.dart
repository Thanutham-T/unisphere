import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/l10n/app_localizations.dart';

import '../widgets/custom_onboard_button.dart';
import '../bloc/page_index_cubit.dart'; // Import your cubit


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

    final pages = [
      PageViewModel(
        title: "Page 1",
        body: "describe 1",
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "Page 2",
        body: "describe 2",
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "Page 3",
        body: "describe 3",
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IntroductionScreen(
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 3000,
          infiniteAutoScroll: true,
          showSkipButton: true,
          next: CustomOnboardButton(
            nameButton: localizations.onboarding_name_button_next,
          ),
          skip: Text(
            localizations.onboarding_name_button_skip,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          done: CustomOnboardButton(
            nameButton: localizations.onboarding_name_button_done,
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

        Positioned(
          bottom: 100,
          child: BlocBuilder<PageIndexCubit, int>(
            builder: (context, currentPageIndex) {
              return SmoothPageIndicator(
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Colors.deepPurple,
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
