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

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _termsAccepted = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _createAccount(BuildContext context) {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue.')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpWithEmailEvent(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        ),
      );
    }
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
            const StarfieldBackground(),
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
                        'Begin your\norbit.',
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
                        'Free, forever. No ads. Just space.',
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15,
                          color: AppColors.bone3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp40),
                      SInput(
                        label: 'Name',
                        controller: _nameCtrl,
                        hint: 'Ada Lovelace',
                        autofillHints: const [AutofillHints.name],
                        validator: (v) => v != null && v.isNotEmpty
                            ? null
                            : 'Enter your name',
                      ),
                      const SizedBox(height: AppSpacing.sp24),
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
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (v) => v != null && v.length >= 6
                            ? null
                            : 'Min 6 characters',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _createAccount(context),
                      ),
                      const SizedBox(height: AppSpacing.sp24),
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (v) =>
                                setState(() => _termsAccepted = v ?? true),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontSize: 13,
                                color: AppColors.bone3,
                              ),
                            ),
                          ),
                        ],
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
                              label: 'Create account →',
                              onPressed: () => _createAccount(context),
                            ),
                          );
                        },
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
