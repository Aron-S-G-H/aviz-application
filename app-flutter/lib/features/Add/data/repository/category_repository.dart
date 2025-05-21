import 'package:aviz_project/features/Add/data/model/category.dart';
import 'package:aviz_project/features/Add/data/model/facility.dart';
import 'package:aviz_project/features/Add/data/model/sub_category.dart';
import 'package:aviz_project/features/Add/data/source/category_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<String, List<Category>>> getGeneralCategories();
  Future<Either<String, List<SubCategory>>> getSubCategories(int categoryId);
  Future<Either<String, List<Facility>>> getFacilities();
}

class ICategoryRepository extends CategoryRepository {
  final CategorySource _categorySource;
  ICategoryRepository(this._categorySource);

  @override
  Future<Either<String, List<Category>>> getGeneralCategories() async {
    try {
      List<Category> response = await _categorySource.getGeneralCategories();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }

  @override
  Future<Either<String, List<SubCategory>>> getSubCategories(
    int categoryId,
  ) async {
    try {
      List<SubCategory> response = await _categorySource.getSubCategories(categoryId);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
  
  @override
  Future<Either<String, List<Facility>>> getFacilities() async {
    try {
      List<Facility> response = await _categorySource.getFacilities();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}
