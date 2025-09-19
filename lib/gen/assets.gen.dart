// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart' as _lottie;

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// Directory path: assets/animations/lotties
  $AssetsAnimationsLottiesGen get lotties =>
      const $AssetsAnimationsLottiesGen();

  /// File path: assets/animations/splash_animation.mp4
  String get splashAnimation => 'assets/animations/splash_animation.mp4';

  /// List of all assets
  List<String> get values => [splashAnimation];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/announcement.png
  AssetGenImage get announcement =>
      const AssetGenImage('assets/icons/announcement.png');

  /// File path: assets/icons/event.png
  AssetGenImage get event => const AssetGenImage('assets/icons/event.png');

  /// File path: assets/icons/group.png
  AssetGenImage get group => const AssetGenImage('assets/icons/group.png');

  /// File path: assets/icons/home.png
  AssetGenImage get home => const AssetGenImage('assets/icons/home.png');

  /// File path: assets/icons/schedule.png
  AssetGenImage get schedule =>
      const AssetGenImage('assets/icons/schedule.png');

  /// File path: assets/icons/unisphere_icon.png
  AssetGenImage get unisphereIcon =>
      const AssetGenImage('assets/icons/unisphere_icon.png');

  /// File path: assets/icons/unisphere_logo.png
  AssetGenImage get unisphereLogo =>
      const AssetGenImage('assets/icons/unisphere_logo.png');

  /// File path: assets/icons/user.png
  AssetGenImage get user => const AssetGenImage('assets/icons/user.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    announcement,
    event,
    group,
    home,
    schedule,
    unisphereIcon,
    unisphereLogo,
    user,
  ];
}

class $AssetsAnimationsLottiesGen {
  const $AssetsAnimationsLottiesGen();

  /// File path: assets/animations/lotties/annouce_animation.json
  LottieGenImage get annouceAnimation =>
      const LottieGenImage('assets/animations/lotties/annouce_animation.json');

  /// File path: assets/animations/lotties/event_animation.json
  LottieGenImage get eventAnimation =>
      const LottieGenImage('assets/animations/lotties/event_animation.json');

  /// File path: assets/animations/lotties/group_anmation.json
  LottieGenImage get groupAnmation =>
      const LottieGenImage('assets/animations/lotties/group_anmation.json');

  /// File path: assets/animations/lotties/logo_animation.json
  LottieGenImage get logoAnimation =>
      const LottieGenImage('assets/animations/lotties/logo_animation.json');

  /// File path: assets/animations/lotties/map_animation.json
  LottieGenImage get mapAnimation =>
      const LottieGenImage('assets/animations/lotties/map_animation.json');

  /// File path: assets/animations/lotties/offline_animation.json
  LottieGenImage get offlineAnimation =>
      const LottieGenImage('assets/animations/lotties/offline_animation.json');

  /// File path: assets/animations/lotties/schedule_animation.json
  LottieGenImage get scheduleAnimation =>
      const LottieGenImage('assets/animations/lotties/schedule_animation.json');

  /// List of all assets
  List<LottieGenImage> get values => [
    annouceAnimation,
    eventAnimation,
    groupAnmation,
    logoAnimation,
    mapAnimation,
    offlineAnimation,
    scheduleAnimation,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
