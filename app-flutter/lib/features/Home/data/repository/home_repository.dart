import "package:aviz_project/features/Aviz/data/model/aviz.dart";
import "package:aviz_project/features/Home/data/source/home_source.dart";
import "package:aviz_project/networks/api_exeption.dart";
import "package:dartz/dartz.dart";
import "package:flutter/material.dart";

@immutable
sealed class HomeRepository {
  Future<Either<String, List<Aviz>>> getRecentAvizs();
  Future<Either<String, List<Aviz>>> getHotAvizs();
}

class IHomeRepository extends HomeRepository {
  final HomeSource _homeSource;
  IHomeRepository(this._homeSource);

  @override
  Future<Either<String, List<Aviz>>> getRecentAvizs() async {
    try {
      List<Aviz> recentAvizs = await _homeSource.getRecentAvizs();
      return right(recentAvizs);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }

  @override
  Future<Either<String, List<Aviz>>> getHotAvizs() async {
    try {
      List<Aviz> hotAvizs = await _homeSource.getHotAvizs();
      return right(hotAvizs);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}