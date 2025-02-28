import 'package:bus_tracker_app/core/common/widgets/basic_button.dart';
import 'package:bus_tracker_app/core/common/widgets/basic_field.dart';
import 'package:bus_tracker_app/core/utils/loader.dart';
import 'package:bus_tracker_app/core/utils/show_snackbar.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bus_tracker_app/features/auth/presentation/widgets/google_button.dart';
import 'package:bus_tracker_app/features/auth/presentation/widgets/notify_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context: context, text: state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.2,
                    ),
                    Text(
                      'Welcome Back!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Get started with Jpr Bus Tracker',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NotifyMessageTile(
                        text:
                            "Only bus drivers and admin can log in using email and password. All other users must use Google login."),
                    SizedBox(
                      height: 10,
                    ),
                    BasicField(
                        hintText: "Email",
                        icon: Icons.email_rounded,
                        controller: emailController),
                    SizedBox(
                      height: 10,
                    ),
                    BasicField(
                      hintText: "Password",
                      icon: Icons.lock_rounded,
                      controller: passwordController,
                      isobscureText: true,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    BasicButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                AuthSignInWithEmailPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));
                          }
                        },
                        text: "Login"),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
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
                      height: 20,
                    ),
                    GoogleButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthSignInWithGoogle());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
