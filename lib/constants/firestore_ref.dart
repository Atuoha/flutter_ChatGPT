import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRef {
  static var userRef = FirebaseFirestore.instance.collection('users');
}
