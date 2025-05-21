part of 'aviz_bloc.dart';


@immutable
sealed class AvizState {}

class AvizInitialState extends AvizState {}

class AvizLoadingState extends AvizState {}

class AvizResponseState extends AvizState {
  final Either<String, Aviz> aviz;

  AvizResponseState({required this.aviz});
}