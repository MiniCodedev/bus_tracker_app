import 'package:bus_tracker_app/core/common/widgets/basic_button.dart';
import 'package:bus_tracker_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(context.read<AppUserCubit>().user?.name ?? ''),
          ),
          BasicButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthUserLogout());
              },
              text: "Sign Out"),
        ],
      ),
    );
  }
}
