import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@immutable
sealed class HomeSource {
  Future<List<Aviz>> getRecentAvizs();
  Future<List<Aviz>> getHotAvizs();
}

class IHomeSource extends HomeSource {
  final Dio _dio;
  IHomeSource(this._dio);

  @override
  Future<List<Aviz>> getRecentAvizs() async {
    try {
      final Response response = await _dio.get(
      'ad/aviz/',
      queryParameters: {'recent': true},
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

  @override
  Future<List<Aviz>> getHotAvizs() async {
    try {
      final Response response = await _dio.get(
        'ad/aviz/',
        queryParameters: {'hot': true},
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
