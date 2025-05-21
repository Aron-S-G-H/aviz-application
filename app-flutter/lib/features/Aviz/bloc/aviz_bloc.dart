import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Aviz/data/repository/aviz_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'aviz_event.dart';
part 'aviz_state.dart';

class AvizBloc extends Bloc<AvizEvent, AvizState> {
  final AvizRepository _avizRepository = locator.get();

  AvizBloc() : super(AvizInitialState()) {
    on<AvizInitialEvent>(
      (event, emit) async {
        emit(AvizLoadingState());
        final aviz = await _avizRepository.getAvizById(event.id);
        emit(AvizResponseState(aviz: aviz));
      },
    );
  }
}
