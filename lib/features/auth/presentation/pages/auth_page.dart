import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/app/constants/colors.dart';
import 'package:singularity/app/widgets/auth_richtext.dart';
import 'package:singularity/app/widgets/text_field.dart';
import '../bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignUp = true;
  bool _showPassword = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Inline field errors driven by AuthBloc error state.
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _showPassword = false;
      _emailError = null;
      _passwordError = null;
    });
  }

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  bool _isValidEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigation on AuthAuthenticated is handled by GoRouter's redirect
        // (Firebase authStateChanges triggers appRouter's refreshListenable).
        if (state is AuthLoading) {
          _clearErrors();
        }
        if (state is AuthError) {
          setState(() {
            if (state.field == 'email') {
              _emailError = state.message;
            } else if (state.field == 'password') {
              _passwordError = state.message;
            } else {
              _emailError = state.message;
            }
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final formKey = _isSignUp ? _signUpFormKey : _loginFormKey;
            formKey.currentState?.validate();
          });
        }
        if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Password reset email sent, please check your email')));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              _isSignUp ? 'Create Account' : 'Log In',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.titilliumWeb().fontFamily),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/signUp-bg.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _isSignUp ? _signUpFormKey : _loginFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isSignUp ? 'Sign Up' : 'Log In',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 32),
                              if (_isSignUp)
                                _formField(
                                  context: context,
                                  title: 'Name',
                                  hintText: 'Enter name',
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              const SizedBox(height: 12),
                              _formField(
                                context: context,
                                title: 'Email',
                                hintText: 'Enter email',
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!_isValidEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  if (_emailError != null) return _emailError;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              InputText(
                                w: MediaQuery.of(context).size.width,
                                label: 'Enter password',
                                hintText: 'Enter password',
                                fillColor: const Color(0xFFFEBA4F),
                                textColor: Colors.black,
                                controller: _passwordController,
                                ontapPasswordView: () => setState(
                                    () => _showPassword = !_showPassword),
                                isIcon: true,
                                obscureText: !_showPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (_passwordError != null) {
                                    return _passwordError;
                                  }
                                  return null;
                                },
                                textInputType: TextInputType.visiblePassword,
                              ),
                              if (!_isSignUp)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_isValidEmail(
                                          _emailController.text.trim())) {
                                        context.read<AuthBloc>().add(
                                            ResetPasswordEvent(
                                                _emailController.text.trim()));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Please enter a valid email')));
                                      }
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: GoogleFonts.titilliumWeb()
                                              .fontFamily),
                                    ),
                                  ),
                                ),
                              if (_isSignUp) const SizedBox(height: 18),
                              InkWell(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        _clearErrors();
                                        final formKey = _isSignUp
                                            ? _signUpFormKey
                                            : _loginFormKey;
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }
                                        if (_isSignUp) {
                                          context.read<AuthBloc>().add(
                                              SignUpWithEmailEvent(
                                                  name: _nameController.text
                                                      .trim(),
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim()));
                                        } else {
                                          context.read<AuthBloc>().add(
                                              SignInWithEmailEvent(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim()));
                                        }
                                      },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )
                                        : Text(
                                            _isSignUp ? 'Sign Up' : 'Log In',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                            color: Colors.black,
                                            thickness: 1.4)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 9),
                                      child: Text('OR',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)),
                                    ),
                                    Expanded(
                                        child: Divider(
                                            color: Colors.black,
                                            thickness: 1.4)),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: isLoading
                                    ? null
                                    : () => context
                                        .read<AuthBloc>()
                                        .add(const SignInWithGoogleEvent()),
                                child: Container(
                                  height: 45,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        child: SvgPicture.asset('assets/Google.svg'),
                                      ),
                                      const Text('Google',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 22, bottom: 2),
                                child: AuthRichText(
                                  normalText: _isSignUp
                                      ? 'I already have an account '
                                      : "I don't have an account ",
                                  richText: _isSignUp ? 'Log In' : 'Sign Up',
                                  ontap: () {
                                    _clearControllers();
                                    setState(
                                        () => _isSignUp = !_isSignUp);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _formField({
    required BuildContext context,
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType textInputType = TextInputType.emailAddress,
  }) {
    return InputText(
      w: MediaQuery.of(context).size.width,
      controller: controller,
      label: title,
      hintText: hintText,
      validator: validator,
      textInputType: textInputType,
      fillColor: const Color(0xFFFEBA4F),
      textColor: Colors.black,
    );
  }
}
