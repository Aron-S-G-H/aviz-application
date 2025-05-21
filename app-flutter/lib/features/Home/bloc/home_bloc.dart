import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Home/data/repository/home_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository = locator.get();

  HomeBloc() : super(HomeInitState()) {
    on<HomeInitialEvent>((event, emit) async {
      emit(HomeLoadingState());
      final hotAvizs = await _homeRepository.getHotAvizs();
      final recentAvizs = await _homeRepository.getRecentAvizs();
      emit(HomeResponseState(hotAvizs: hotAvizs, recentAvizs: recentAvizs));
    }); 
  }
}