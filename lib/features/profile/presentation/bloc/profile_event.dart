part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  final String userId;
  const LoadProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final UserEntity user;
  const UpdateProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}
