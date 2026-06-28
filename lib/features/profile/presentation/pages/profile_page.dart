import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/widgets/s_button.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../saved/presentation/bloc/saved_bloc.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When a guest signs in, the ProfileBloc created in HomeView never loaded
    // (uid was null at init). Kick off the load on the auth transition so the
    // tab swaps from the guest card to the real profile.
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => curr is AuthAuthenticated,
      listener: (context, authState) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          context.read<ProfileBloc>().add(LoadProfileEvent(uid));
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final user = _extractUser(state);
          final uid = FirebaseAuth.instance.currentUser?.uid;

          return Scaffold(
            backgroundColor: AppColors.ink,
            body: SafeArea(
              child: uid == null
                  ? const _GuestProfile()
                  : user == null
                  ? _ProfileFallback(
                      state: state,
                      onRetry: () => context.read<ProfileBloc>().add(
                        LoadProfileEvent(uid),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp24,
                        vertical: AppSpacing.sp24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(
                            user: user,
                            onEditTap: () => _showEditProfile(context, user),
                          ),
                          const SizedBox(height: AppSpacing.sp32),
                          ProfileStatsRow(user: user),
                          const SizedBox(height: AppSpacing.sp32),
                          const Divider(color: AppColors.hairline),
                          const SizedBox(height: AppSpacing.sp24),
                          _AccountSection(
                            onEditProfile: () =>
                                _showEditProfile(context, user),
                            onPrivacy: () => context.push('/privacy'),
                            onAbout: () => _showAbout(context),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  UserEntity? _extractUser(ProfileState state) {
    if (state is ProfileLoaded) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.user;
    return null;
  }

  void _showEditProfile(BuildContext context, UserEntity user) {
    final nameCtrl = TextEditingController(text: user.name ?? '');
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF16161D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Edit profile',
          style: GoogleFonts.newsreader(
            fontSize: 22,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: AppColors.bone,
          ),
        ),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          style: const TextStyle(
            fontFamily: 'Geist',
            fontSize: 15,
            color: AppColors.bone,
          ),
          decoration: const InputDecoration(
            labelText: 'Display name',
            labelStyle: TextStyle(
              fontFamily: 'Geist',
              fontSize: 12,
              color: AppColors.bone4,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.hairlineStrong),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.bone, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Geist', color: AppColors.bone3),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.bone,
              foregroundColor: AppColors.ink,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                context.read<ProfileBloc>().add(
                  UpdateProfileEvent(user.copyWith(name: name)),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Save',
              style: TextStyle(fontFamily: 'Geist', fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16161D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Singularity',
          style: GoogleFonts.newsreader(
            fontSize: 22,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: AppColors.bone,
          ),
        ),
        content: const Text(
          'A window on the universe.\n\nData sourced from NASA APIs, ESA Open Notify, and the NASA Exoplanet Archive. Built with Flutter.',
          style: TextStyle(
            fontFamily: 'Geist',
            fontSize: 13,
            color: AppColors.bone3,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Geist', color: AppColors.bone3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileFallback extends StatelessWidget {
  const _ProfileFallback({required this.state, required this.onRetry});

  final ProfileState state;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (state is ProfileInitial || state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.bone,
          strokeWidth: 1.5,
        ),
      );
    }

    final message = state is ProfileError
        ? (state as ProfileError).message
        : 'Profile is unavailable.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              color: AppColors.bone4,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.sp16),
            Text(
              'Profile unavailable',
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: AppColors.bone,
              ),
            ),
            const SizedBox(height: AppSpacing.sp8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geist',
                fontSize: 13,
                height: 1.5,
                color: AppColors.bone3,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.sp20),
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Try again',
                  style: TextStyle(fontFamily: 'Geist', color: AppColors.bone),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown on the Profile tab when browsing as a guest (no signed-in account).
/// Invites the user to sign in / create an account.
class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨', style: TextStyle(fontSize: 36)),
            const SizedBox(height: AppSpacing.sp16),
            Text(
              "You're exploring as a guest",
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: AppColors.bone,
              ),
            ),
            const SizedBox(height: AppSpacing.sp8),
            const Text(
              'Sign in to edit your profile, sync saves, and track wallpapers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Geist',
                fontSize: 13,
                height: 1.5,
                color: AppColors.bone3,
              ),
            ),
            const SizedBox(height: AppSpacing.sp24),
            SizedBox(
              width: double.infinity,
              child: SButton(
                label: 'Sign in / Create account',
                onPressed: () => context.push('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user, required this.onEditTap});
  final UserEntity user;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final initial =
        (user.name?.isNotEmpty == true ? user.name![0] : user.email?[0] ?? '?')
            .toUpperCase();

    final nameParts = (user.name ?? '').trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return Row(
      children: [
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.ink2, AppColors.ink3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.hairlineStrong),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.newsreader(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: AppColors.bone,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sp16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$firstName ',
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bone,
                      ),
                    ),
                    if (lastName.isNotEmpty)
                      TextSpan(
                        text: lastName,
                        style: GoogleFonts.newsreader(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppColors.bone,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.email ?? '',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.bone3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.user, this.savedCount});

  final UserEntity user;
  final int? savedCount;

  @override
  Widget build(BuildContext context) {
    if (savedCount != null) {
      return _buildRow(savedCount.toString());
    }

    return BlocBuilder<SavedBloc, SavedState>(
      builder: (context, state) {
        final count = state is SavedLoaded
            ? state.items.length.toString()
            : '—';
        return _buildRow(count);
      },
    );
  }

  Widget _buildRow(String savedCount) {
    return Row(
      children: [
        _StatCell(value: savedCount, label: 'SAVED'),
        _Hairline(),
        _StatCell(value: user.wallpaperCount.toString(), label: 'WALLPAPERS'),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.newsreader(
              fontSize: 32,
              height: 1,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: AppColors.bone4,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.hairlineStrong);
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({
    required this.onEditProfile,
    required this.onPrivacy,
    required this.onAbout,
  });
  final VoidCallback onEditProfile;
  final VoidCallback onPrivacy;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.bone4,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.sp16),
        _AccountRow(label: 'Saved photos', onTap: () => context.push('/saved')),
        _AccountRow(label: 'Edit profile', onTap: onEditProfile),
        _AccountRow(label: 'Privacy', onTap: onPrivacy),
        _AccountRow(label: 'About Singularity', onTap: onAbout),
        const SizedBox(height: AppSpacing.sp8),
        GestureDetector(
          onTap: () => context.read<AuthBloc>().add(const SignOutEvent()),
          child: const Text(
            'Sign out',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 15,
              color: AppColors.danger,
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 15,
                  color: AppColors.bone2,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.bone4, size: 18),
          ],
        ),
      ),
    );
  }
}
