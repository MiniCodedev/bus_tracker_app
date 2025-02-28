import 'package:bus_tracker_app/core/common/widgets/basic_button.dart';
import 'package:bus_tracker_app/core/common/widgets/basic_field.dart';
import 'package:flutter/material.dart';

class AddBusDriverPage extends StatefulWidget {
  const AddBusDriverPage({super.key});

  @override
  State<AddBusDriverPage> createState() => _AddBusDriverPageState();
}

class _AddBusDriverPageState extends State<AddBusDriverPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController busNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Driver'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 10,
            children: [
              BasicField(
                controller: nameController,
                icon: Icons.person_rounded,
                hintText: 'Name',
              ),
              BasicField(
                controller: emailController,
                icon: Icons.email_rounded,
                hintText: 'Email',
              ),
              BasicField(
                controller: passwordController,
                icon: Icons.lock_rounded,
                hintText: 'Password',
              ),
              BasicField(
                controller: phoneController,
                icon: Icons.phone_rounded,
                hintText: 'Phone',
              ),
              BasicField(
                controller: busNumberController,
                icon: Icons.directions_bus_rounded,
                hintText: 'Bus Number',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BasicButton(
          onPressed: () {},
          text: 'Add Driver',
        ),
      ),
    );
  }
}
