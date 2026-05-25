import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:singularity/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
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
        theme: AppTheme.dark,
        title: 'Singularity',
        routerConfig: appRouter,
      ),
    );
  }
}
