part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserDriverUserLoggedin extends AppUserState {}

final class AppUserOtherLoggedin extends AppUserState {}

final class AppUserAdminLoggedin extends AppUserState {}
