import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseRemoteDatasources {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DriverUserModel> getUserByUid(String uid) async {
    try {
      Map<String, dynamic>? userDoc =
          (await _firestore.collection('users').doc(uid).get()).data();
      return DriverUserModel.fromMap(userDoc!);
    } catch (e) {
      throw ServerException('Error fetching user details from Firestore: $e');
    }
  }

  Future<DriverUserModel> updateDriverUser(DriverUserModel driverModel) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: driverModel.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw ServerException('Bus number already exists');
      }

      final uid = (await _auth.createUserWithEmailAndPassword(
              email: driverModel.email, password: driverModel.password))
          .user!
          .uid;

      driverModel = driverModel.copyWith(uid: uid);

      await _firestore
          .collection('users')
          .doc(driverModel.uid)
          .set(driverModel.toMap());
      return driverModel;
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Error updating user details in Firestore: $e');
    }
  }
}
