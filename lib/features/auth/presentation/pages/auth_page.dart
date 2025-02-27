import 'package:bus_tracker_app/core/common/widgets/basic_button.dart';
import 'package:bus_tracker_app/core/common/widgets/basic_field.dart';
import 'package:bus_tracker_app/features/auth/presentation/widgets/google_button.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.2,
              ),
              Text(
                'Welcome Back!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Get started with Jpr Bus Tracker',
              ),
              SizedBox(
                height: 40,
              ),
              BasicField(
                  hintText: "Email",
                  icon: Icons.email_rounded,
                  controller: TextEditingController()),
              SizedBox(
                height: 10,
              ),
              BasicField(
                hintText: "Password",
                icon: Icons.password_rounded,
                controller: TextEditingController(),
                isobscureText: true,
              ),
              SizedBox(
                height: 40,
              ),
              BasicButton(onPressed: () {}, text: "Login"),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      width: 100,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GoogleButton(
                onPressed: () {},
              ),
              SizedBox(
                height: height * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
