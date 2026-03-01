import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/loaders/loader.dart';
import 'package:mobile/common/models/review_model.dart';

bool isNullOrEmpty(String? str) {
  if (str == null || str.isEmpty || str == 'null' || str == "") {
    return true;
  }
  return false;
}

void showLoadingOverlay(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Loader(color: Colors.white),
  );
}

double calculateRating(List<ReviewModel> reviews) {
  if (reviews.isEmpty) {
    return 0.0;
  }

  final ratings = reviews.map((r) => r.rating ?? 0).toList();

  final sum = ratings.reduce((a, b) => a + b);
  return double.parse((sum / ratings.length).toStringAsFixed(1));
}

Color hexToColor(String? hex) {
  if (hex == null) {
    return Colors.white;
  }
  final hexString = hex.replaceFirst('#', '');
  try {
    return Color(int.parse('FF$hexString', radix: 16));
  } catch (e) {
    return Colors.white;
  }
}

Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }
  return null;
}
