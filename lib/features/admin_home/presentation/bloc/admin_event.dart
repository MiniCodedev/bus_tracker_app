part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

final class AdminAddDriver extends AdminEvent {
  final DriverUserModel driverUserModel;

  AdminAddDriver({required this.driverUserModel});
}
