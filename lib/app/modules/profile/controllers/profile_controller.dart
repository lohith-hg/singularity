import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/app_user.dart';
import '../../../service/auth_service.dart';
import '../../../utils/utils.dart';

class ProfileController extends GetxController {
  AuthService authService = Get.find();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController workEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();
  TextEditingController bioEditingController = TextEditingController();
  TextEditingController countryEditingController = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();
  final editMode = false.obs;
  final appUser = AppUser().obs;

  @override
  void onInit() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await loadUser();
    }
    super.onInit();
  }

  loadUser() async {
    var user = await authService.getUser(
        userId: FirebaseAuth.instance.currentUser!.uid);
    if (user != null) {
      appUser.value = user;
      nameEditingController.text = user.name!;
      emailEditingController.text = user.email!;
      if (user.bio != null) {
        bioEditingController.text = user.bio!;
      }
      if (user.country != null) {
        countryEditingController.text = user.country!;
      }
      if (user.occupation != null && user.age != null) {
        workEditingController.text = user.occupation!;
        ageEditingController.text = user.age!;
      }
    }
  }

  updateUser() {
    appUser.value.name = nameEditingController.text;
    appUser.value.age = ageEditingController.text;
    appUser.value.occupation = workEditingController.text;
    appUser.value.bio = bioEditingController.text;
    appUser.value.country = countryEditingController.text;
    authService.updateUser(appUser.value);
    Utils().showSnackBar("Profile Updated");
  }
}