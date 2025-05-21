import 'package:aviz_project/features/Add/data/source/add_aviz_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AddAvizRepository {
  Future<Either<String, bool>> addAviz(Map<String, dynamic> data);
}

class IAddAvizRepository extends AddAvizRepository {
  final AddAvizSource _addAvizSource;
  IAddAvizRepository(this._addAvizSource);

  @override
  Future<Either<String, bool>> addAviz(Map<String, dynamic> data) async {
    try {
      final bool response = await _addAvizSource.addAviz(data);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}