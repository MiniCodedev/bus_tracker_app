import 'package:bus_tracker_app/core/data/database_remote_datasources.dart';
import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:bus_tracker_app/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseRemoteDatasources databaseRemoteDatasources;

  AuthRemoteDataSource({required this.databaseRemoteDatasources});

  Future getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (_auth.currentUser != null) {
        if (user!.email == "admin@jpr.com") {
          return "admin";
        } else if (isGoogleUser(user)) {
          return UserModel.fromFirebaseUser(user);
        } else {
          DriverUserModel userModel =
              await databaseRemoteDatasources.getUserByUid(user.uid);
          return userModel;
        }
      }
      return null;
    } catch (e) {
      throw ServerException('Error getting current user: $e');
    }
  }

  /// **Check if the user signed in with Google**
  bool isGoogleUser(User user) {
    return user.providerData[0].providerId == "google.com";
  }

  /// Sign in with email and password
  Future<DriverUserModel> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw ServerException('Error signing in with email: User not found');
      }
      if (email != "admin@jpr.com") {
        DriverUserModel userModel =
            await databaseRemoteDatasources.getUserByUid(credential.user!.uid);
        return userModel;
      }
      return DriverUserModel(
          uid: credential.user!.uid,
          name: "admin",
          email: email,
          busNo: 0,
          phoneNo: "phoneNo",
          password: "");
    } on ServerException catch (e) {
      throw ServerException('Error signing in with email: ${e.message}');
    } catch (e) {
      throw ServerException('Error signing in with email: $e');
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw ServerException('Google sign in canceled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on ServerException catch (e) {
      throw ServerException('Error signing in with Google: ${e.message}');
    } catch (e) {
      throw ServerException('Error signing in with Google: $e');
    }
  }

  /// Sign out from Firebase and Google
  Future<String> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return "Successfully signed out!";
    } catch (e) {
      throw ServerException('Error signing out: $e');
    }
  }
}
