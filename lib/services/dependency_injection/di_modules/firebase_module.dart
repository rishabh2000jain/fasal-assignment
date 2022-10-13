import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/services/firebase_services.dart';

@module
abstract class FirebaseModule {
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @preResolve
  Future<FirebaseService> get firebaseService => FirebaseService.init();
}

