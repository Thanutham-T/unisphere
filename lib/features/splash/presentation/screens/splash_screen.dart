import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_master/splash_master.dart';
import 'package:go_router/go_router.dart';

import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/injector.dart' as di;
import 'package:unisphere/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _handleNavigation(BuildContext context) async {
    context.read<FullscreenCubit>().exitFullscreen();
    
    // Check if user is already logged in
    final storageService = di.getIt<KeyValueStorageService>();
    final token = await storageService.getString('access_token');
    
    if (token != null && token.isNotEmpty) {
      // User is logged in, go to dashboard
      context.go('/');
    } else {
      // User not logged in, go to login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();

    return SplashMaster.video(
      source: AssetSource(Assets.animations.splashAnimation),
      backGroundColor: Colors.white,
      videoConfig: VideoConfig(videoVisibilityEnum: VisibilityEnum.none),
      customNavigation: () => _handleNavigation(context),
    );
  }
}
