part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchWithQueryEvent extends SearchEvent {
  final String query;

  SearchWithQueryEvent(this.query);
}