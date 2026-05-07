import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/profile/domain/usecases/get_user_profile.dart';
import 'package:singularity/features/profile/domain/usecases/update_user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  ProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final user = await getUserProfile(event.userId);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    final currentUser = current is ProfileLoaded
        ? current.user
        : current is ProfileUpdateSuccess
            ? current.user
            : null;

    if (currentUser == null) return;

    emit(ProfileUpdating(currentUser));
    try {
      await updateUserProfile(event.user);
      emit(ProfileUpdateSuccess(event.user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
