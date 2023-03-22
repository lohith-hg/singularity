import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:singularity/controllers/auth_controller.dart';
import '../constants/colors.dart';
import '../widgets/auth_richtext.dart';
import '../widgets/custom_clipper.dart';
import '../widgets/text_field.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSignUp = controller.isSignUpScreen.value;
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/background.jpg"),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  (isSignUp) ? "Create Account" : "Log In",
                  style: const TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (isSignUp) ? "Sign Up" : "Log In",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          if (isSignUp)
                            formField(
                              title: 'Name',
                              hintText: "Enter name",
                              controller: controller.nameEditingController,
                              validator: (value) {
                                if (value.toString().trim().isEmpty) {
                                  return "Please enter your name";
                                }
                                return null;
                              },
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          formField(
                            title: 'Email',
                            hintText: "Enter email",
                            controller: controller.nameEditingController,
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          formField(
                            title: 'Password',
                            hintText: "Enter password",
                            controller: controller.phoneEditingController,
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                (isSignUp) ? "Sign Up" : "Log In",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 16),
                            child: Row(
                              children: const <Widget>[
                                Expanded(
                                    child: Divider(
                                  color: Colors.white,
                                  thickness: 1.4,
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 9),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await AuthController.authService
                                  .signInWithGoogle();
                            },
                            child: Container(
                              height: 45,
                              width: 145,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      child:
                                          SvgPicture.asset("assets/Google.svg"),
                                    ),
                                    const Text(
                                      "Google",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 22, bottom: 2),
                            child: AuthRichText(
                              normalText: (isSignUp)
                                  ? 'I already have an account '
                                  : 'I don\'t have an account ',
                              richText: (!isSignUp) ? "Sign Up" : "Log In",
                              ontap: () {
                                controller.isSignUpScreen.value =
                                    !controller.isSignUpScreen.value;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Photo by Ian Beckley",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 8),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  formField(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required dynamic validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 16, bottom: 8),
        //   child: Text(
        //     title,
        //     style: const TextStyle(color: Colors.white),
        //   ),
        // ),
        InputText(
          controller: controller,
          label: title,
          hintText: hintText,
          validator: validator,
        ),
      ],
    );
  }
}
