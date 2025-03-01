import 'package:bus_tracker_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:bus_tracker_app/core/data/database_remote_datasources.dart';
import 'package:bus_tracker_app/features/admin_home/domain/admin_repository.dart';
import 'package:bus_tracker_app/features/admin_home/presentation/bloc/admin_bloc.dart';
import 'package:bus_tracker_app/features/admin_home/presentation/pages/admin_home_page.dart';
import 'package:bus_tracker_app/features/auth/data/auth_remote_datasources.dart';
import 'package:bus_tracker_app/features/auth/domain/auth_repository.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bus_tracker_app/features/auth/presentation/pages/auth_page.dart';
import 'package:bus_tracker_app/features/driver_home/presentation/pages/driver_home_page.dart';
import 'package:bus_tracker_app/features/user_home/presentation/pages/user_home_page.dart';
import 'package:bus_tracker_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final DatabaseRemoteDatasources databaseRemoteDatasources =
      DatabaseRemoteDatasources();
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(
      databaseRemoteDatasources: databaseRemoteDatasources);
  final AuthRepository authRepository =
      AuthRepository(authRemoteDataSource: authRemoteDataSource);
  final AdminRepository adminRepository =
      AdminRepository(databaseRemoteDatasources: databaseRemoteDatasources);
  final AppUserCubit appUserCubit = AppUserCubit();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AppUserCubit>(
        create: (context) => appUserCubit,
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
            authRepository: authRepository, appUserCubit: appUserCubit),
      ),
      BlocProvider<AdminBloc>(
        create: (context) => AdminBloc(adminRepository: adminRepository),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserLoginCheck());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AppUserAdminLoggedin) {
            return AdminHomePage();
          } else if (state is AppUserDriverUserLoggedin) {
            return DriverHomePage();
          } else if (state is AppUserOtherLoggedin) {
            return UserHomePage();
          }
          return AuthPage();
        },
      ),
      theme: AppTheme.lightTheme,
    );
  }
}
