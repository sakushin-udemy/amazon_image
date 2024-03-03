import 'dart:async';

import 'package:amazon_image/amazon_image.dart';
import 'package:flutter/material.dart';

class AmazonImageHolder {
  Map<String, NetworkImage> _holder = {};

  AmazonImageHolder(this.context);

  final BuildContext context;

  Future<void> load(List<String> asins,
      {ImageSize imageSize = ImageSize.Middle}) async {
    List<Future<void>> futures = [];
    for (String asin in asins) {
      AmazonImage image = AmazonImage(
        asin,
        imageSize: imageSize,
      );
      NetworkImage networkImage = NetworkImage(image.getImageUrl());
      var future = precacheImage(networkImage, context);
      futures.add(future);
      _holder[asin] = networkImage;
    }

    await Future.wait(futures);
  }

  NetworkImage? getImage(String asin) {
    return _holder[asin];
  }

  void clear() {
    _holder.clear();
  }
}
