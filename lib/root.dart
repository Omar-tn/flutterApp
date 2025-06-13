import 'dart:io' as io;

import 'package:flutter/foundation.dart';

class root {

  static final isWeb = kIsWeb;


  static String domain() {
    if (kIsWeb) {
      return "http://localhost:3000/";
    } else if (io.Platform.isAndroid) {
      return "http://10.0.2.2:3000/"; // Android emulator
    } else if (io.Platform.isIOS) {
      return "http://localhost:3000/"; // iOS simulator
    } else {
      return "http://192.168.x.x:3000/"; // Replace with your actual local IP for real devices
    }
  }
}