import 'dart:convert';
import 'dart:io' as io;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:local/auth_gate.dart';
import 'package:local/login.dart';

class root {

  static final isWeb = kIsWeb;
  static final debug = false;
  static const firebase = true;
  static late var userId;

  /*=
  debug ?
      firebase
      ? "firebase"
      : "NAME" // Replace with actual UID from Firebase Auth
  : FirebaseAuth.instance.currentUser!.uid ;
    // Replace with actual UID from Firebase Auth
*/
  static final initialRoute = !debug ? AuthGate.routName : login.routName;

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

  static Future<String> getUserRole(String id) async {
    try {
      final response = await http.get(Uri.parse(domain() + 'getRole?uid=$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];
        if (data.isNotEmpty) {
          userId = data['id'];
          return data['role'];
        }
      }
      print('Failed to fetch user role: ${response.statusCode}');
    } catch (e) {
      print('Error fetching user role: $e');
    }

    return 'user';
  }
}