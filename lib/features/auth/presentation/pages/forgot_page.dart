import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../app/widgets/s_button.dart';
import '../../../../../../app/widgets/s_input.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../bloc/auth_bloc.dart';
import 'widgets/starfield.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recovery link sent — check your inbox.'),
              backgroundColor: AppColors.good,
            ),
          );
          context.pop();
        }
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
            const StarfieldBackground(opacity: 0.5),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sp24),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.bone,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.sp32),
                      Text(
                        'Lost in\nthe dark?',
                        style: GoogleFonts.newsreader(
                          fontSize: 40,
                          height: 1.05,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppColors.bone,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp8),
                      const Text(
                        "We'll send a recovery link to your email.",
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15,
                          color: AppColors.bone3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp40),
                      SInput(
                        label: 'Email',
                        controller: _emailCtrl,
                        hint: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v != null && v.contains('@')
                            ? null
                            : 'Enter a valid email',
                        textInputAction: TextInputAction.done,
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
                              label: 'Send link →',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    ResetPasswordEvent(_emailCtrl.text.trim()),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: const Text(
                            'Remembered? Sign in',
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
