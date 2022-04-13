import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/screens/solar_system_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.share),
              color: Colors.white,
              onPressed: () async {
                final image = await controller.capture();
                saveAndShare(image!);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                const Image(
                  height: 150,
                  width: 150,
                  image: AssetImage(
                    'assets/app_icon.png',
                  ),
                ),
                Text('Singulatity',
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 22,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily))
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ListTile(
              title: Text('Share',
                  style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              leading: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              onTap: () async {
                final image = await controller.capture();
                saveAndShare(image!);
              },
            ),
            ListTile(
              title: Text('Contact us',
                  style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              onTap: () {
                launchEmail(
                    toEmail: 'lohithhggjc@gmail.com',
                    subject: 'Hello developer,',
                    message: ' ');
              },
            ),
            ListTile(
              title: Text('Terms & conditions',
                  style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              onTap: () {
                launch(
                    'https://github.com/lohith-hg/singularity-privacy/blob/main/privacy-policy.md');
              },
            ),
            ListTile(
              title: Text('About us',
                  style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              onTap: () {
                launch(
                    'https://github.com/lohith-hg/singularity-privacy/blob/main/About-us.md');
              },
            ),
          ],
        ),
      ),
      body: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SolarSystemScreen(),
            ),
          );
        },
        child: Screenshot(
          controller: controller,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Image.asset(
                        'assets/solarSystem.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.orange
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0, 0.6, 1],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Explore Solar System',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                fontFamily:
                                    GoogleFonts.titilliumWeb().fontFamily)),
                        const SizedBox(
                          height: 3.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future launchEmail(
      {required String toEmail,
      required String subject,
      required String message}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future saveAndShare(Uint8List? bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/singularity.png');
    await image.writeAsBytes(bytes!);
    String text =
        'Hey,Check out this singularity app, singularity is an app where you can explore and learn about universe,stars,planets -';
    await Share.shareFiles([image.path], text: text);
  }
}
