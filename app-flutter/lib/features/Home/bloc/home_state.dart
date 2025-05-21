part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeResponseState extends HomeState {
  final Either<String, List<Aviz>> hotAvizs;
  final Either<String, List<Aviz>> recentAvizs;

  HomeResponseState({required this.hotAvizs, required this.recentAvizs});
}
