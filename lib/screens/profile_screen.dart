import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/controllers/profile_controller.dart';
import 'package:singularity/service/auth_service.dart';
import 'package:singularity/widgets/profile_rich_text.dart';

import '../widgets/text_field.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final AuthService authService = Get.find();
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: GoogleFonts.titilliumWeb().fontFamily,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4, top: 10, bottom: 10),
              child: MaterialButton(
                minWidth: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  if (controller.profileFormKey.currentState!.validate()) {
                    if (controller.editMode.value) {
                      controller.updateUser();
                    }
                    controller.editMode.value = !controller.editMode.value;
                  }
                },
                child: Text(
                  (!controller.editMode.value) ? "Edit" : "Save",
                  style: TextStyle(
                      fontFamily: 'dity', fontSize: 18, color: primaryColor),
                ),
                color: secondaryColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: controller.profileFormKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 18),
                      child: CircleAvatar(
                        backgroundColor: secondaryColor,
                        radius: 50,
                        child: Transform.scale(
                          scale: 3,
                          child: Text(
                            controller.appUser.value.name
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'dity',
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    (controller.editMode.value)
                        ? Column(
                            children: [
                              formField(
                                title: 'Name',
                                hintText: "Enter name",
                                textController:
                                    controller.nameEditingController,
                                enabled: controller.editMode.value,
                                validator: (value) {
                                  if (value.toString().trim().isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // formField(
                              //   title: 'Email',
                              //   hintText: "Enter Email",
                              //   enabled: false,
                              //   textController: controller.emailEditingController,
                              //   validator: (value) {
                              //     return null;
                              //   },
                              // ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              formField(
                                title: 'Bio',
                                hintText: "Enter Bio",
                                enabled: controller.editMode.value,
                                textController: controller.bioEditingController,
                                maxLines: 3,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              formField(
                                title: 'Age',
                                hintText: "Enter age",
                                textController: controller.ageEditingController,
                                enabled: controller.editMode.value,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              formField(
                                title: 'Occupation',
                                hintText: "Enter occupation",
                                textController:
                                    controller.workEditingController,
                                enabled: controller.editMode.value,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              formField(
                                title: 'Country',
                                hintText: "Enter country",
                                textController:
                                    controller.countryEditingController,
                                enabled: controller.editMode.value,
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                controller.nameEditingController.text,
                                style: testStyle().copyWith(fontSize: 24),
                              ),
                              Text(
                                controller.emailEditingController.text,
                                style: testStyle(),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                controller.bioEditingController.text,
                                style: testStyle().copyWith(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  controller.editMode.value =
                                      !controller.editMode.value;
                                },
                                color: secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text("Update Bio"),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         "Other Details",
                              //         style: testStyle().copyWith(
                              //             fontWeight: FontWeight.w600,
                              //             color: secondaryColor),
                              //       ),
                              //       const SizedBox(
                              //         height: 6,
                              //       ),
                              //       RichText(
                              //         text: TextSpan(
                              //           text: 'Age : ',
                              //           style: testStyle().copyWith(
                              //               fontSize: 16,
                              //               color: secondaryColor),
                              //           children: <TextSpan>[
                              //             TextSpan(
                              //               text: controller
                              //                   .ageEditingController.text,
                              //               style: testStyle().copyWith(
                              //                   fontSize: 16,
                              //                   color: Colors.white),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       RichText(
                              //         text: TextSpan(
                              //           text: 'Occupation : ',
                              //           style: testStyle().copyWith(
                              //               fontSize: 16,
                              //               color: secondaryColor),
                              //           children: <TextSpan>[
                              //             TextSpan(
                              //               text: controller
                              //                   .workEditingController.text,
                              //               style: testStyle().copyWith(
                              //                   fontSize: 16,
                              //                   color: Colors.white),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       ProfileRichText(
                              //           title: "Country",
                              //           text: controller
                              //               .countryEditingController.text)
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                    const SizedBox(
                      height: 32,
                    ),
                    if (!controller.editMode.value)
                      TextButton.icon(
                        onPressed: () async {
                          await authService.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Sign Out",
                          style: TextStyle(
                            fontFamily: 'dity',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  TextStyle testStyle() {
    return TextStyle(
      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }
}

formField(
    {required String title,
    required String hintText,
    required TextEditingController textController,
    required dynamic validator,
    required bool enabled,
    int maxLines = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: GoogleFonts.titilliumWeb().fontFamily,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      InputText(
        w: Get.width,
        controller: textController,
        label: title,
        hintText: hintText,
        enabled: enabled,
        maxLines: maxLines,
        fillColor: (enabled) ? Colors.white : const Color(0xFFFEBA4F),
        textColor: Colors.white,
        validator: validator,
        showHint: true,
      ),
    ],
  );
}
