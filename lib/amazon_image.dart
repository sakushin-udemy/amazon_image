// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLancher;

import 'amazon_image_setting.dart' as setting;

typedef FunctionBeforeLaunch = Future<bool> Function(BuildContext context);
typedef FunctionAfterLaunch = void Function();

enum ImageSize { Small, Middle, Large }

class AmazonImage extends StatelessWidget {
  //Type of image
  /// key for small image
  static const String kSmallKey = 'TZZZZZZZ';
  static const String kMiddleKey = 'MZZZZZZZ';
  static const String kLargeKey = 'LZZZZZZZ';

  // 画像のサイズ
  static const double kSmallSize = 110.0;
  static const double kMiddleSize = 160.0;
  static const double kLargeSize = 500.0;

  late final String _linkUrl;
  final BoxFit? boxFit;
  final FractionalOffset offset;
  final BuildContext? context;
  final ImageSize imageSize;
  late final String countryCode;
  late final String domain;

  final String asin;
  final Function? onTap;
  final Function? onDoubleTap;
  final Function? onLongTap;
  final FunctionBeforeLaunch? functionBeforeLaunch;
  final FunctionAfterLaunch? functionAfterLaunch;

  final bool isLaunchAfterTap;
  final bool isLaunchAfterDoubleTap;
  final bool isLaunchAfterLongTap;

  final bool prechache;

  late final Image _image;
  late final Future<void>? _futurePrechache;
  Future<void>? get future => _futurePrechache;

  /// AmazonImage is a widget to display an image from amazon.
  ///
  /// [asin] is a amazon's key to specify product.
  /// Let's go to amazon's product page and check the url.
  /// (Example)
  /// https://www.amazon.com/gp/product/B003O2SHKG?pf_rd_r ..................
  ///  asin must be "B003O2SHKG"
  AmazonImage(
    this.asin, {
    Key? key,
    this.imageSize = ImageSize.Middle,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.functionBeforeLaunch,
    this.functionAfterLaunch,
    this.boxFit,
    this.context,
    String? linkUrl,
    this.offset = FractionalOffset.center,
    this.isLaunchAfterTap = false,
    this.isLaunchAfterDoubleTap = true,
    this.isLaunchAfterLongTap = false,
    this.prechache = false,
  }) : super(key: key) {
    assert(onTap == null || !isLaunchAfterTap,
        'onTap must be null when isLaunchAfterTap is true');
    assert(onDoubleTap == null || !isLaunchAfterDoubleTap,
        'onDoubleTap must be null when isLaunchAfterDoubleTap is true');
    assert(onLongTap == null || !isLaunchAfterLongTap,
        'onLongTap must be null when isLaunchAfterLongTap is true');
    assert(!prechache || context != null,
        'When prechache is ture, contect must not be null');

    setting.CountryKey countryKey =
        setting.countryLocale[setting.AmazonImageSetting().defaultCountry] ??
            setting.CountryKey.USA;
    countryCode = setting.codes[countryKey]!;
    domain = setting.domains[countryKey]!;

    if (linkUrl == null) {
      _linkUrl = getLinkUrl();
    } else {
      _linkUrl = linkUrl;
    }

    _image = Image.network(
      getImageUrl(),
      fit: boxFit,
      alignment: offset,
    );

    if (prechache) {
      _futurePrechache = precacheImage(_image.image, context!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _image,
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (isLaunchAfterTap) {
          onLaunch();
        }
      },
      onDoubleTap: () {
        if (onDoubleTap != null) {
          onDoubleTap!();
        }
        if (isLaunchAfterDoubleTap) {
          onLaunch();
        }
      },
      onLongPress: () {
        if (onLongTap != null) {
          onLongTap!();
        } else if (isLaunchAfterLongTap) {
          onLaunch();
        }
      },
    );
  }

  /// Method for lanching to amazon web page.
  void onLaunch() {
    _launchURL();
  }

  /// Get amazon's image url.
  String getImageUrl() {
    String imageSizeKey = imageSize == ImageSize.Large
        ? kLargeKey
        : imageSize == ImageSize.Small
            ? kSmallKey
            : kMiddleKey;
    return 'https://images-na.ssl-images-amazon.com/images/P/$asin.$countryCode.$imageSizeKey.jpg';
  }

  /// Get amazon's product url.
  String getLinkUrl() {
    var trackingId = setting.AmazonImageSetting().trackingId;
    // https://www.amazon.co.jp/gp/product/B00N8JJCNQ?tag=flutter_amazon_image-22
    return 'https://www.$domain/gp/product/$asin?tag=$trackingId';
  }

  _launchURL() async {
    assert(functionBeforeLaunch == null || this.context != null,
        'context must be not null when function is called before lanuch');

    if (await urlLancher.canLaunch(_linkUrl)) {
      if (functionBeforeLaunch != null) {
        var result = await functionBeforeLaunch!(context!);
        if (!result) {
          return;
        }
      }

      if (await urlLancher.launch(_linkUrl)) {
        if (functionAfterLaunch != null) {
          functionAfterLaunch!();
        }
      }
    } else {
      throw 'Could not Launch $_linkUrl';
    }
  }
}
