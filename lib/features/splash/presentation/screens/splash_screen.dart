import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/splash_master.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';

import 'package:unisphere/gen/assets.gen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();

    return SplashMaster.video(
      source: AssetSource(Assets.animations.splashAnimation),
      backGroundColor: Colors.white,
      videoConfig: VideoConfig(videoVisibilityEnum: VisibilityEnum.none),
      customNavigation: () {
        if (context.read<KeyValueStorageService>().isFirstTimeOnboarding()) {
          context.read<KeyValueStorageService>().setFirstTimeOnboarding(false);
          OnboardingRoute().go(context);
        } else {
          context.read<FullscreenCubit>().exitFullscreen();
          DashboardRoute().go(context);
        }
      },
    );
  }
}
