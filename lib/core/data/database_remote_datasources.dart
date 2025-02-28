import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRemoteDatasources {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DriverUserModel> getUserByUid(String uid) async {
    try {
      Map<String, dynamic>? userDoc =
          (await _firestore.collection('users').doc(uid).get()).data();
      return DriverUserModel.fromMap(userDoc!);
    } catch (e) {
      throw ServerException('Error fetching user details from Firestore: $e');
    }
  }
}
