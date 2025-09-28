import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/splash_master.dart';

import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';
import '../../../../config/routes/app_routes.dart';

import 'package:unisphere/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _handleNavigation(BuildContext context) async {
    // Check if user is already logged in using encrypted storage
    final token = await context.read<KeyValueStorageService>().getEncryptedString('access_token');
    context.read<FullscreenCubit>().exitFullscreen();
    if (token != null && token.isNotEmpty) {
      // User is logged in, go to dashboard
      context.goToDashboard();
    } else {
      // User not logged in, go to login
      context.goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();

    return SplashMaster.video(
      source: AssetSource(Assets.animations.splashAnimation),
      backGroundColor: Colors.white,
      videoConfig: VideoConfig(videoVisibilityEnum: VisibilityEnum.none),
      customNavigation: () async {
        // รวม logic ทั้งสอง: onboarding check + auth check
        if (context.read<KeyValueStorageService>().isFirstTimeOnboarding()) {
          context.read<KeyValueStorageService>().setFirstTimeOnboarding(false);

          context.goToOnboarding();
        } else {
          // ใช้ _handleNavigation เพื่อ check authentication
          await _handleNavigation(context);
        }
      },
    );
  }
}
