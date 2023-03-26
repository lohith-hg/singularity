import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:singularity/controllers/profile_controller.dart';
import '../data/app_user.dart';
import '../screens/bottom_nav_bar.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  static AuthService authService = Get.find();
  var auth = FirebaseAuth.instance;
  final isLoggedin = false.obs;
  final isLoading = false.obs;

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final accountFormKey = GlobalKey<FormState>();
  final isLogInScreen = false.obs;

  var isSignUpScreen = true.obs;
  final showPassword = false.obs;
  final signUpFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final emailErrorText = ''.obs;
  final passwordErrorText = ''.obs;

  @override
  void onInit() {
    isSignUpScreen.value = true;
    super.onInit();
  }

  createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      isLoading.value = true;
      await authService.createUserWithEmailAndPassword(
          emailAddress: email, password: password);
      if (auth.currentUser != null) {
        Get.offAll(() => const BottomNavigation());
        isLoading.value = false;
      }
      if (auth.currentUser != null) {
        var user = AppUser();
        user.name = nameEditingController.text;
        user.id = auth.currentUser!.uid;
        user.email = auth.currentUser!.email;
        user.bio = "📸 Exploring the universe, one shot at a time!";
        user.createdAt = DateTime.now();
        authService.setUser(user);
        Get.offAll(() => const BottomNavigation());
        clearControllers();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        passwordErrorText.value = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        emailErrorText.value = 'The account already exists for that email.';
      }
      signUpFormKey.currentState!.validate();
    } catch (e) {
      emailErrorText.value = e.toString();
    }
  }

  signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      isLoading.value = true;
      await authService.signInWithEmailAndPassword(
          emailAddress: email, password: password);
      if (auth.currentUser != null) {
        Get.offAll(() => const BottomNavigation());
        isLoading.value = false;
        clearControllers();
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        emailErrorText.value = 'User not found';
      } else if (e.code == 'wrong-password') {
        passwordErrorText.value = "Please enter the correct password";
      }
      loginFormKey.currentState!.validate();
    }
  }

  clearControllers() {
    nameEditingController.clear();
    emailEditingController.clear();
    passwordEditingController.clear();
    showPassword.value = false;
    emailErrorText.value = '';
    passwordErrorText.value = '';
  }
}
