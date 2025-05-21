import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Profile/data/model/profile.dart';
import 'package:aviz_project/features/Profile/data/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository = locator.get();

  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileInitialEvent>(
      (event, emit) async {
        emit(ProfileLoadingState());
        final response = await _profileRepository.getProfile();
        emit(ProfileResponseState(response: response));
      },
    );
  }
}
