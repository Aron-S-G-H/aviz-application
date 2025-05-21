import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Add/data/model/category.dart';
import 'package:aviz_project/features/Add/data/model/facility.dart';
import 'package:aviz_project/features/Add/data/model/sub_category.dart';
import 'package:aviz_project/features/Add/data/repository/add_aviz_repository.dart';
import 'package:aviz_project/features/Add/data/repository/category_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final CategoryRepository _categoryRepository = locator.get();
  final AddAvizRepository _addAvizRepository = locator.get();

  AddBloc() : super(CategoryInitialState()) {
    on<CategoryInitialEvent>(
      (event, emit) async {
        try {
          emit(CategoryLoadingState());
          var categories = await _categoryRepository.getGeneralCategories();
          emit(CategoryResponseState(response: categories));
        } catch (e) {
          emit(CategoryLoadingState());
        }
      },
    );

    on<GetSubCategoriesEvent>(
      (event, emit) async {
        emit(CategoryLoadingState());
        var subCategories = await _categoryRepository.getSubCategories(
          event.categoryId,
        );
        emit(SubCategoryResponseState(response: subCategories));
      },
    );

    on<GetFacilitiesEvent>(
      (event, emit) async {
        var facilities = await _categoryRepository.getFacilities();
        emit(FacilitiesResponseState(response: facilities));
      },
    );

    on<SubmitAizEvent>(
      (event, emit) async {
        emit(CategoryLoadingState());
        var response = await _addAvizRepository.addAviz(event.data);
        emit(SubmitAvizResponseState(response: response));
      },
    );
  }
}
