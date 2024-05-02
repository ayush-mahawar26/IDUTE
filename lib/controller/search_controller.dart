import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';

class CustomSearchController {
  final FirebaseFirestore _store = FirebaseConstants.store;

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> searchForUserProfile(
      String value) async {
    return _store
        .collection("Users")
        .orderBy("name")
        .startAt([value]).endAt(["$value\uf8ff"]).snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> searchGroup(
      String value) async {
    return _store
        .collection("Group")
        .orderBy("title")
        .startAt([value]).endAt(["$value\uf8ff"]).snapshots();
  }
}
