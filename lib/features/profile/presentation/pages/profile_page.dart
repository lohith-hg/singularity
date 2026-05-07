import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/app/widgets/text_field.dart';
import 'package:singularity/core/constants/colors.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _countryController = TextEditingController();
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<ProfileBloc>().add(LoadProfileEvent(uid));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _populateControllers(UserEntity user) {
    _nameController.text = user.name ?? '';
    _emailController.text = user.email ?? '';
    _bioController.text = user.bio ?? '';
    _ageController.text = user.age ?? '';
    _occupationController.text = user.occupation ?? '';
    _countryController.text = user.country ?? '';
  }

  void _onSavePressed(UserEntity currentUser) {
    if (!_formKey.currentState!.validate()) return;
    if (_editMode) {
      final updated = currentUser.copyWith(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        age: _ageController.text.trim(),
        occupation: _occupationController.text.trim(),
        country: _countryController.text.trim(),
      );
      context.read<ProfileBloc>().add(UpdateProfileEvent(updated));
    } else {
      setState(() => _editMode = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
          final user = state is ProfileLoaded
              ? state.user
              : (state as ProfileUpdateSuccess).user;
          _populateControllers(user);
          if (state is ProfileUpdateSuccess) {
            setState(() => _editMode = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated')),
            );
          }
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final currentUser = state is ProfileLoaded
            ? state.user
            : state is ProfileUpdating
                ? state.user
                : state is ProfileUpdateSuccess
                    ? state.user
                    : null;

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.black,
            actions: [
              if (currentUser != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
                  child: MaterialButton(
                    minWidth: 30,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: secondaryColor,
                    onPressed: state is ProfileUpdating
                        ? null
                        : () => _onSavePressed(currentUser),
                    child: Text(_editMode ? 'Save' : 'Edit'),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, state, currentUser),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, ProfileState state, UserEntity? currentUser) {
    if (state is ProfileLoading || state is ProfileInitial) {
      return const Center(
          child: CircularProgressIndicator(color: secondaryColor));
    }

    if (currentUser == null && state is ProfileError) {
      return Center(
        child: Text(state.message, style: const TextStyle(color: Colors.white)),
      );
    }

    if (currentUser == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
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
                        (currentUser.name ?? '?')
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
                _editMode
                    ? Column(
                        children: [
                          _formField(
                            context: context,
                            screenWidth: screenWidth,
                            title: 'Name',
                            hintText: 'Enter name',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          _formField(
                            context: context,
                            screenWidth: screenWidth,
                            title: 'Bio',
                            hintText: 'Enter bio',
                            controller: _bioController,
                            maxLines: 3,
                            validator: (_) => null,
                          ),
                          const SizedBox(height: 8),
                          _formField(
                            context: context,
                            screenWidth: screenWidth,
                            title: 'Age',
                            hintText: 'Enter age',
                            controller: _ageController,
                            validator: (_) => null,
                          ),
                          const SizedBox(height: 8),
                          _formField(
                            context: context,
                            screenWidth: screenWidth,
                            title: 'Occupation',
                            hintText: 'Enter occupation',
                            controller: _occupationController,
                            validator: (_) => null,
                          ),
                          const SizedBox(height: 8),
                          _formField(
                            context: context,
                            screenWidth: screenWidth,
                            title: 'Country',
                            hintText: 'Enter country',
                            controller: _countryController,
                            validator: (_) => null,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            _nameController.text,
                            style: _textStyle().copyWith(fontSize: 24),
                          ),
                          Text(
                            _emailController.text,
                            style: _textStyle(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bioController.text,
                            style: _textStyle().copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          MaterialButton(
                            onPressed: () => setState(() => _editMode = true),
                            color: secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: const Text('Update Bio'),
                          ),
                        ],
                      ),
                const SizedBox(height: 32),
                if (!_editMode)
                  TextButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const SignOutEvent());
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                        color: Colors.white,
                        fontSize: 18,
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

  Widget _formField({
    required BuildContext context,
    required double screenWidth,
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
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
          w: screenWidth,
          controller: controller,
          label: title,
          hintText: hintText,
          enabled: true,
          maxLines: maxLines,
          fillColor: Colors.white,
          textColor: Colors.white,
          validator: validator,
          showHint: true,
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }
}
