import 'package:bus_tracker_app/features/admin_home/presentation/pages/add_bus_driver_page.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin',
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthUserLogout());
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBusDriverPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
