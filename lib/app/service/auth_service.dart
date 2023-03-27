import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:singularity/app/modules/auth/views/auth_view.dart';
import 'package:singularity/app/routes/app_pages.dart';

import '../model/app_user.dart';
import '../utils/utils.dart';

class AuthService extends GetxService {
  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromSnapshot(snapshot),
            toFirestore: (user, _) => user.toJson(),
          );
  static AuthService get to => Get.find();
  final isLoggedin = false.obs;

  @override
  void onInit() async {
    //authStateStatus();
    super.onInit();
  }

  bool get isAuthenticated {
    return authStateStatus();
  }

  Future<AppUser?> getUser({required String userId}) async {
    var querySnapshot = await usersRef.doc(userId).get();
    if (querySnapshot.exists) {
      var user = querySnapshot.data()!;
      return user;
    } else {}
    return null;
  }

  bool authStateStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedin.value = false;
      } else {
        isLoggedin.value = true;
      }
    });
    return isLoggedin.value;
  }

  void setUser(AppUser appUser) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(appUser.toJson());
  }

  void updateUser(AppUser appUser) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(appUser.toJson());
  }

  Future signInWithGoogle() async {
    GoogleSignInAccount? googleUser;
    User? googleWebUser;
    try {
      googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var data = await FirebaseAuth.instance.signInWithCredential(credential);

      if (data.additionalUserInfo!.isNewUser) {
        var user = AppUser();
        user.name = googleUser!.displayName;
        user.id = FirebaseAuth.instance.currentUser!.uid;
        user.email = googleUser.email;
        user.bio = "📸 Exploring the universe, one shot at a time!";
        user.createdAt = DateTime.now();
        setUser(user);
         Get.rootDelegate.offNamed(AppPages.HOME);
      } else {
         Get.rootDelegate.offNamed(AppPages.HOME);
      }
    } on FirebaseAuthException {
      Utils().showSnackBar("Something went wrong, please try again");
    } catch (e) {
      switch (e.toString()) {
        default:
          Utils().showSnackBar(e.toString());
      }
    }
  }

  createUserWithEmailAndPassword(
      {required String emailAddress, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  signInWithEmailAndPassword(
      {required String emailAddress, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils()
          .showSnackBar("Password reset email sent, please check yout email");
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
     Get.rootDelegate.offNamed(AppPages.AUTH);
  }
}
