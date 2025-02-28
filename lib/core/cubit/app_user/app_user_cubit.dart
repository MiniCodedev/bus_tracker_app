import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:bus_tracker_app/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  UserModel? user;
  DriverUserModel? driverUser;
  AppUserCubit() : super(AppUserInitial());

  void setUser(UserModel? user, DriverUserModel? driverUser,
      {bool isAdmin = false}) {
    if (isAdmin) {
      emit(AppUserAdminLoggedin());
    } else if (driverUser != null) {
      emit(AppUserDriverUserLoggedin());
    } else if (user != null) {
      emit(AppUserOtherLoggedin());
    } else {
      emit(AppUserInitial());
    }
    this.user = user;
    this.driverUser = driverUser;
  }
}
