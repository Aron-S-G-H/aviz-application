part of 'add_bloc.dart';

@immutable
sealed class AddState {}

class CategoryInitialState extends AddState {}

class CategoryLoadingState extends AddState {}

class CategoryResponseState extends AddState {
  final Either<String, List<Category>> response;

  CategoryResponseState({required this.response});
}

class SubCategoryResponseState extends AddState {
  final Either<String, List<SubCategory>> response;

  SubCategoryResponseState({required this.response});
}

class CategoryErrorState extends AddState {
  final String message;

  CategoryErrorState({required this.message});
}

class FacilitiesResponseState extends AddState {
  final Either<String, List<Facility>> response;

  FacilitiesResponseState({required this.response});
}

class SubmitAvizResponseState extends AddState {
  final Either<String, bool> response;

  SubmitAvizResponseState({required this.response});
} 