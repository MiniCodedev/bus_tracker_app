import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      name: firebaseUser.displayName!,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
