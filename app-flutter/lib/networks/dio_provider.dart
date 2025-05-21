import 'package:aviz_project/Utils/formdata_builder.dart';
import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:dio/dio.dart';

class DioProvider {
  static Dio createDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: Settings.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AuthManager.isUserLogedIn()) {
            options.headers['Authorization'] = 'Bearer ${AuthManager.getAccessToken()}';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshed = await AuthManager.refreshToken();
            if (refreshed) {
              e.requestOptions.headers['Authorization'] = 'Bearer ${AuthManager.getAccessToken()}';

              // بازسازی FormData از داده‌های اولیه
              if (e.requestOptions.data is FormData && e.requestOptions.extra['formDataPayload'] != null) {
                final data = e.requestOptions.extra['formDataPayload'] as Map<String, dynamic>;
                FormData newFormData = await formDataBuilder(data);
                e.requestOptions.data = newFormData; // جایگزینی FormData قدیمی با جدید
              }
              return handler.resolve(await dio.fetch(e.requestOptions));
            } else {
              AuthManager.logout();
            }
          }
          handler.next(e);
        },
      ),
    );
    return dio;
  }
}

