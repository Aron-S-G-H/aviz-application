import 'package:aviz_project/features/Add/data/model/category.dart';
import 'package:aviz_project/features/Add/data/model/facility.dart';
import 'package:aviz_project/features/Add/data/model/sub_category.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dio/dio.dart';

abstract class CategorySource {
  Future<List<Category>> getGeneralCategories();
  Future<List<SubCategory>> getSubCategories(int categoryId);
  Future<List<Facility>> getFacilities();
}

class ICategorySource extends CategorySource {
  final Dio _dio;
  ICategorySource(this._dio);

  @override
  Future<List<Category>> getGeneralCategories() async {
    try {
      final Response response = await _dio.get('ad/category');
      return response.data
          .map<Category>((jsonObject) => Category.fromJsonObject(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(
        ex.response!.data['success'],
        ex.response!.data['error']['message'],
        ex.response!.data['error']['status'],
      );
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
  }

  @override
  Future<List<SubCategory>> getSubCategories(int categoryId) async {
    final Response response = await _dio.get(
      'ad/category/$categoryId/subcategory',
    );
    return response.data
        .map<SubCategory>(
            (jsonObject) => SubCategory.fromJsonObject(jsonObject))
        .toList();
  }
  
  @override
  Future<List<Facility>> getFacilities() async {
    try {
      final Response response = await _dio.get('ad/aviz/facility/');
      return response.data
          .map<Facility>((jsonObject) => Facility.fromJsonObject(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(
        ex.response!.data['success'],
        ex.response!.data['error']['message'],
        ex.response!.data['error']['status'],
      );
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
  }
}
