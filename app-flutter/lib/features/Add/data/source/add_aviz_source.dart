import 'package:aviz_project/Utils/formdata_builder.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AddAvizSource {
  Future<bool> addAviz(Map<String, dynamic> data);
}

class IAddAvizSource extends AddAvizSource {
  final Dio _dio;
  IAddAvizSource(this._dio);

  @override
  Future<bool> addAviz(Map<String, dynamic> data) async {
    try {
      FormData formData = await formDataBuilder(data);
      final Response response = await _dio.post(
        'ad/aviz/',
        data: formData,
        options: Options(
          extra: {
            'formDataPayload': data
          },
        ),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
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
