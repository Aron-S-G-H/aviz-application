import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Search/data/repository/search_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository = locator.get();

  SearchBloc() : super(SearchInitialState()) {
    on<SearchWithQueryEvent>(
      (event, emit) async {
        final searchResult = await _searchRepository.searchAviz(event.query);
        emit(SearchRequestSuccessState(searchResult));
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
  }
}
