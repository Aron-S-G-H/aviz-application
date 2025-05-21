part of 'profile_bloc.dart';


@immutable
sealed class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}
class ProfileResponseState extends ProfileState {
  final Either<String, Profile> response;

  ProfileResponseState({required this.response});
}