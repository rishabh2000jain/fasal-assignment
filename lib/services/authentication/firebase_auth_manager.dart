import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/app/models/user_data.dart';
import 'package:movie_library_app/services/authentication/auth_manager.dart';

@Injectable(as: AuthManager<User>)
class FirebaseAuthManager extends AuthManager<UserData> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseAuthManager(this._firebaseAuth, this._firebaseFirestore);

  @override
  Future<UserData?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        Map<String, dynamic>? _doc = await _getUserFromCollection(user.uid);
        if (_doc != null) {
          return UserData.fromMapAndUser(_doc, user);
        }
      }
      return null;
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  Future<UserData?> loginUser(String email, String password) async {
    try {
      UserCredential _userCred = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCred.user != null) {
        Map<String, dynamic>? _doc = await _getUserFromCollection(_userCred.user!.uid);
        if (_doc != null) {
          return UserData.fromMapAndUser(_doc, _userCred.user!);
        }
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String ,dynamic>?> _getUserFromCollection(String userId)async{
    DocumentSnapshot<Map<String, dynamic>> _doc = await _firebaseFirestore
        .collection('Users')
        .doc(userId)
        .get();
    return  _doc.data();
  }

  @override
  Future<void> logoutCurrentUser() async {
    try {
      _firebaseAuth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserData?> registerUser(
      String email, String password, Map<String, dynamic> extraParams) async {
    try {
      Map<String, dynamic> _userDataMap = {
        'email': email,
        'phone': extraParams['phone'],
        'name': extraParams['name']
      };
      UserCredential _userCred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_userCred.user != null) {
        DocumentReference _doc =
            _firebaseFirestore.collection('Users').doc(_userCred.user!.uid);
        await _doc.set(_userDataMap);
        return UserData.fromMapAndUser(_userDataMap, _userCred.user!);
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> isRegistered() async {
    return _firebaseAuth.currentUser != null;
  }
}


