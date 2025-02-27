import 'package:bus_tracker_app/features/auth/presentation/pages/auth_page.dart';
import 'package:bus_tracker_app/features/driver_home/presentation/pages/driver_home_page.dart';
import 'package:bus_tracker_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: AppTheme.lightTheme,
    );
  }
}
