part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminLoading extends AdminState {}

final class AdminAddDriverSuccess extends AdminState {}

final class AdminFailure extends AdminState {
  final String message;

  AdminFailure(this.message);
}
