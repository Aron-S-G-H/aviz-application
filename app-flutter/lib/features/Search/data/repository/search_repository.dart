import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Search/data/source/search_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class SearchRepository {
  Future<Either<String, List<Aviz>>> searchAviz(String query);
}

class ISearchRepository extends SearchRepository {
  final SearchSource _searchSource;
  ISearchRepository(this._searchSource);
  
  @override
  Future<Either<String, List<Aviz>>> searchAviz(String query) async {
    try {
      List<Aviz> searchAvizs = await _searchSource.searchAviz(query);
      return right(searchAvizs);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}
