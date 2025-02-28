import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/error/failure.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:bus_tracker_app/core/models/user_model.dart';
import 'package:bus_tracker_app/features/auth/data/auth_remote_datasources.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepository({required this.authRemoteDataSource});

  Future<Either<Failure, DriverUserModel>> signInWithEmailPassword(
      String email, String password) async {
    try {
      final DriverUserModel driverUserModel =
          await authRemoteDataSource.signInWithEmail(email, password);
      return right(driverUserModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final UserModel userModel = await authRemoteDataSource.signInWithGoogle();
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future getCurrentUser() async {
    return await authRemoteDataSource.getCurrentUser();
  }

  Future<Either<Failure, String>> signOut() async {
    try {
      final res = await authRemoteDataSource.signOut();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> checkUserLoginStatus() async {
    try {
      final userType = await authRemoteDataSource.getCurrentUser();
      return userType != null
          ? right(userType)
          : left(Failure('User type is null'));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
