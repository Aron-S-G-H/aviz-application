import 'package:aviz_project/features/Profile/data/model/profile.dart';
import 'package:aviz_project/features/Profile/data/source/profile_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';


@immutable
sealed class ProfileRepository {
  Future<Either<String, Profile>> getProfile();
}

class IProfileRepository extends ProfileRepository {
  final ProfileSource _profileSource;
  IProfileRepository(this._profileSource);

  @override
  Future<Either<String, Profile>> getProfile() async {
    try {
      final Profile response = await _profileSource.getProfile();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}