import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final User _firebaseUser;
  final String _name;
  final String? _phoneNumber;

  UserData(this._name, this._firebaseUser, this._phoneNumber);

  User get firebaseUser => _firebaseUser;

  String get name => _name;

  String? get phone => _phoneNumber;

  factory UserData.fromMapAndUser(Map<String, dynamic> json, User user) {
    return UserData(json['name'], user, json['phone']);
  }
}