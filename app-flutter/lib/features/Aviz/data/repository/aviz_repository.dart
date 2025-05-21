import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Aviz/data/source/aviz_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AvizRepository {
  Future<Either<String, Aviz>> getAvizById(int id);
}

class IAvizRepository extends AvizRepository {
  final AvizSource _avizSource;
  IAvizRepository(this._avizSource);

  @override
  Future<Either<String, Aviz>> getAvizById(int id) async {
    try {
      final Aviz aviz = await _avizSource.getAvizById(id);
      return right(aviz);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}
