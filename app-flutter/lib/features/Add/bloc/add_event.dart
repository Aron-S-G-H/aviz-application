part of 'add_bloc.dart';

@immutable
sealed class AddEvent {}

class CategoryInitialEvent extends AddEvent {}

class GetSubCategoriesEvent extends AddEvent {
  final int categoryId;
  GetSubCategoriesEvent(this.categoryId);
}

class GetFacilitiesEvent extends AddEvent {}

class SubmitAizEvent extends AddEvent {
  final Map<String, dynamic> data;
  SubmitAizEvent(this.data);
}