import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/app/constants/colors.dart';
import 'package:singularity/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(const Singularity());
}

class Singularity extends StatelessWidget {
  const Singularity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.titilliumWeb().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: GoogleFonts.titilliumWeb().fontFamily,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
        title: 'Singularity',
        routerConfig: appRouter,
      ),
    );
  }
}
