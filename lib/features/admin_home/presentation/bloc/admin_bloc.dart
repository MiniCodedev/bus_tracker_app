import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:bus_tracker_app/features/admin_home/domain/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository adminRepository;

  AdminBloc({required this.adminRepository}) : super(AdminInitial()) {
    on<AdminEvent>((event, emit) => emit(AdminLoading()));
    on<AdminAddDriver>(_onAdminAddDriver);
  }

  void _onAdminAddDriver(AdminAddDriver event, Emitter<AdminState> emit) async {
    final driverUserModel = event.driverUserModel;
    final result = await adminRepository.addDriver(driverUserModel);
    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (driverUserModel) => emit(AdminAddDriverSuccess()),
    );
  }
}
