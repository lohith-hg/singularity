import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/screens/bottom_nav_bar.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primaryColor,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Paint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      home: UpgradeAlert(
          upgrader: Upgrader(showReleaseNotes: false),
          child: const BottomNavigation()),
    );
  }
}
