import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../app/widgets/s_button.dart';
import '../../../../../../app/widgets/s_input.dart';
import '../../../../../../app/widgets/singularity_logo.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../bloc/auth_bloc.dart';
import 'widgets/starfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _signIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInWithEmailEvent(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        ),
      );
    }
  }

  void _signInGoogle(BuildContext context) {
    context.read<AuthBloc>().add(const SignInWithGoogleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) context.go('/home');
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.void_,
        body: Stack(
          children: [
            const StarfieldBackground(opacity: 0.7),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sp56),
                      const SingularityMark(size: 36),
                      const SizedBox(height: AppSpacing.sp40),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome ',
                              style: GoogleFonts.newsreader(
                                fontSize: 40,
                                height: 1.05,
                                fontWeight: FontWeight.w300,
                                color: AppColors.bone,
                              ),
                            ),
                            TextSpan(
                              text: 'back.',
                              style: GoogleFonts.newsreader(
                                fontSize: 40,
                                height: 1.05,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                color: AppColors.bone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp8),
                      const Text(
                        'Sign in to continue your orbit.',
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.bone3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp40),
                      SInput(
                        label: 'Email',
                        controller: _emailCtrl,
                        hint: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (v) => v != null && v.contains('@')
                            ? null
                            : 'Enter a valid email',
                      ),
                      const SizedBox(height: AppSpacing.sp24),
                      SInput(
                        label: 'Password',
                        controller: _passCtrl,
                        isPassword: true,
                        autofillHints: const [AutofillHints.password],
                        validator: (v) => v != null && v.length >= 6
                            ? null
                            : 'Password too short',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _signIn(context),
                      ),
                      const SizedBox(height: AppSpacing.sp12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.push('/forgot'),
                          child: const Text(
                            'Forgot?',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              color: AppColors.bone3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.bone,
                                strokeWidth: 1.5,
                              ),
                            );
                          }
                          return SizedBox(
                            width: double.infinity,
                            child: SButton(
                              label: 'Sign in →',
                              onPressed: () => _signIn(context),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sp24),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(color: AppColors.hairlineStrong),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontSize: 12,
                                color: AppColors.bone4,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AppColors.hairlineStrong),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sp24),
                      SizedBox(
                        width: double.infinity,
                        child: SButton.ghost(
                          label: 'Continue with Google',
                          onPressed: () => _signInGoogle(context),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp32),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.push('/signup'),
                          child: const Text(
                            'New here? Create account',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              color: AppColors.bone3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
