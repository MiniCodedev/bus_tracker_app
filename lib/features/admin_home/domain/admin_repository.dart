import 'package:bus_tracker_app/core/data/database_remote_datasources.dart';
import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/error/failure.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:fpdart/fpdart.dart';

class AdminRepository {
  final DatabaseRemoteDatasources databaseRemoteDatasources;
  AdminRepository({required this.databaseRemoteDatasources});

  Future<Either<Failure, DriverUserModel>> addDriver(
      DriverUserModel driverUserModel) async {
    try {
      await databaseRemoteDatasources.updateDriverUser(driverUserModel);
      return right(driverUserModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
