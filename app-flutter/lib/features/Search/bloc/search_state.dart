part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

class SearchInitialState extends SearchState {}

class SearchRequestSuccessState extends SearchState {
  final Either<String, List<Aviz>> searchResult;

  SearchRequestSuccessState(this.searchResult);
} 