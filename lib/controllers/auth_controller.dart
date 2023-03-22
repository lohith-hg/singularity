import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/app_user.dart';
import '../service/auth_service.dart';
import '../utils/utils.dart';

class AuthController extends GetxController {
  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromSnapshot(snapshot),
            toFirestore: (user, _) => user.toJson(),
          );

  static AuthService authService = Get.put(AuthService());
  final isLoggedin = false.obs;

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController workEditingController = TextEditingController();
  final accountFormKey = GlobalKey<FormState>();
  final isLogInScreen = false.obs;

  var isSignUpScreen = true.obs;

  @override
  void onInit() {
    isSignUpScreen.value = true;
    super.onInit();
  }



}
