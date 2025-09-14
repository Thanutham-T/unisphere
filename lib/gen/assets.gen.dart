// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

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

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');

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
    logo,
    schedule,
    unisphereIcon,
    unisphereLogo,
    user,
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
