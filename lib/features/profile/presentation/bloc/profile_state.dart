part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

// Emitted while the update request is in-flight; includes the current user
// so the page can keep displaying existing data without a loading spinner.
class ProfileUpdating extends ProfileState {
  final UserEntity user;
  const ProfileUpdating(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;
  const ProfileUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
