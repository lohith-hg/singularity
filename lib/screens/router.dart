import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:singularity/controllers/auth_controller.dart';
import 'package:singularity/screens/auth_screen.dart';
import 'package:upgrader/upgrader.dart';

import '../service/auth_service.dart';
import 'bottom_nav_bar.dart';

// ignore: must_be_immutable
class ScreenRouter extends StatelessWidget {
  static AuthService authService = Get.put(AuthService());
  final authController = Get.put(AuthController());

  ScreenRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return AuthScreen();
    } else {
      return UpgradeAlert(
        upgrader: Upgrader(showReleaseNotes: false),
        child: const BottomNavigation(),
      );
    }
  }
}
