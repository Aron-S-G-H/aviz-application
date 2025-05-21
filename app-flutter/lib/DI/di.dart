import 'package:aviz_project/features/Add/data/repository/add_aviz_repository.dart';
import 'package:aviz_project/features/Add/data/repository/category_repository.dart';
import 'package:aviz_project/features/Add/data/source/add_aviz_source.dart';
import 'package:aviz_project/features/Add/data/source/category_source.dart';
import 'package:aviz_project/features/Authentication/data/repository/authentication_repository.dart';
import 'package:aviz_project/features/Authentication/data/source/authentication_source.dart';
import 'package:aviz_project/features/Aviz/data/repository/aviz_repository.dart';
import 'package:aviz_project/features/Aviz/data/source/aviz_source.dart';
import 'package:aviz_project/features/Home/data/repository/home_repository.dart';
import 'package:aviz_project/features/Home/data/source/home_source.dart';
import 'package:aviz_project/features/Profile/data/repository/profile_repository.dart';
import 'package:aviz_project/features/Profile/data/source/profile_source.dart';
import 'package:aviz_project/features/Search/data/repository/search_repository.dart';
import 'package:aviz_project/features/Search/data/source/search_source.dart';
import 'package:aviz_project/networks/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> getItInit() async {
  locator.registerSingleton<Dio>(DioProvider.createDio());

  _initSources();
  _initRepositories();
}

void _initSources() {
  locator.registerFactory<AuthenticationSource>(
    () => IAuthSource(locator.get()),
  );
  locator.registerFactory<HomeSource>(
    () => IHomeSource(locator.get()),
  );
  locator.registerFactory<CategorySource>(
    () => ICategorySource(locator.get()),
  );
  locator.registerFactory<AvizSource>(
    () => IAvizSource(locator.get()),
  );
  locator.registerFactory<SearchSource>(
    () => ISearchSource(locator.get()),
  );
  locator.registerFactory<ProfileSource>(
    () => IProfileSource(locator.get()),
  );
  locator.registerFactory<AddAvizSource>(
    () => IAddAvizSource(locator.get()),
  );
}

void _initRepositories() {
  locator.registerFactory<AuthenticationRepository>(
    () => IAuthRepository(locator.get()),
  );

  locator.registerFactory<HomeRepository>(
    () => IHomeRepository(locator.get()),
  );

  locator.registerFactory<CategoryRepository>(
    () => ICategoryRepository(locator.get()),
  );
  locator.registerFactory<AvizRepository>(
    () => IAvizRepository(locator.get()),
  );
  locator.registerFactory<SearchRepository>(
    () => ISearchRepository(locator.get()),
  );
  locator.registerFactory<ProfileRepository>(
    () => IProfileRepository(locator.get()),
  );
  locator.registerFactory<AddAvizRepository>(
    () => IAddAvizRepository(locator.get()),
  );
}
