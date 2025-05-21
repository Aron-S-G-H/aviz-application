part of 'aviz_bloc.dart';


@immutable
sealed class AvizEvent {}

class AvizInitialEvent extends AvizEvent {
  final int id;
  AvizInitialEvent(this.id);
}