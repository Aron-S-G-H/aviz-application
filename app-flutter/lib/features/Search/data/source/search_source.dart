import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@immutable
sealed class SearchSource {
  Future<List<Aviz>> searchAviz(String query);
}

class ISearchSource extends SearchSource {
  final Dio _dio;
  ISearchSource(this._dio);

  @override
  Future<List<Aviz>> searchAviz(String query) async {
    try {
      final Response response = await _dio.get(
        'ad/aviz/search/',
        queryParameters: {'search': query.trim()},
      );
      return response.data
          .map<Aviz>((jsonObject) => Aviz.fromJsonObject(jsonObject))
          .toList();
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionError ||
          ex.type == DioExceptionType.connectionTimeout) {
        throw ApiExeption(false, 'اتصال به اینترنت برقرار نیست', 503);
      } else if (ex.response != null) {
        throw ApiExeption(
          ex.response!.data['success'],
          ex.response!.data['error']['message'],
          ex.response!.data['error']['status'],
        );
      }
      throw ApiExeption(false, 'خطا در ارتباط با سرور', 500);
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
  }
}
