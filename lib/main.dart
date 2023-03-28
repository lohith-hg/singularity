import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/app/constants/colors.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';
import 'control_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const Singularity(),
  );
}

class Singularity extends StatelessWidget {
  const Singularity({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.titilliumWeb().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
        title: "Singularity",
        routerDelegate: GetDelegate(
          backButtonPopMode: PopMode.Page,
          preventDuplicateHandlingMode:
              PreventDuplicateHandlingMode.PopUntilOriginalRoute,
        ),
        popGesture: Get.isPopGestureEnable,
        //initialRoute: AppPages.HOME,
        getPages: AppPages.routes,
        initialBinding: ControlBinding()
        // initialBinding: ControlBinding(),
        );
  }
}
