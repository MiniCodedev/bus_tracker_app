// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DriverUserModel {
  final String uid;
  final String name;
  final String email;
  final int busNo;
  final String phoneNo;
  final String password;

  DriverUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.busNo,
    required this.phoneNo,
    required this.password,
  });

  DriverUserModel copyWith({
    String? uid,
    String? name,
    String? email,
    int? busNo,
    String? phoneNo,
    String? password,
  }) {
    return DriverUserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      busNo: busNo ?? this.busNo,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'busNo': busNo,
      'phoneNo': phoneNo,
      'password': password,
    };
  }

  factory DriverUserModel.fromMap(Map<String, dynamic> map) {
    return DriverUserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      busNo: map['busNo'] as int,
      phoneNo: map['phoneNo'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverUserModel.fromJson(String source) =>
      DriverUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DriverUserModel(uid: $uid, name: $name, email: $email, busNo: $busNo, phoneNo: $phoneNo, password: $password)';
  }

  @override
  bool operator ==(covariant DriverUserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.busNo == busNo &&
        other.phoneNo == phoneNo &&
        other.password == password;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        busNo.hashCode ^
        phoneNo.hashCode ^
        password.hashCode;
  }
}
