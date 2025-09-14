import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/splash_master.dart';
import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/gen/assets.gen.dart';

import 'package:unisphere/core/cubits/fullscreen_cubit.dart'; // adjust import path


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();

    return SplashMaster.video(
      source: AssetSource(Assets.animations.splashAnimation),
      customNavigation: () {
        context.read<FullscreenCubit>().exitFullscreen();
        DashboardRoute().go(context);
      },
    );
  }
}
