import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/model/user_model.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  Future<List<UserModel>> getAllTheUserInfofromList(List users) async {
    List<UserModel> usersModel = [];

    for (dynamic i in users) {
      String uid = i.toString();
      UserModel? user = await fetchUserProfileByUid(uid);
      if (user != null) {
        usersModel.add(user);
      }
    }

    return usersModel;
  }

  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> userData =
        await _store.collection("Users").get();

    List<UserModel> users = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in userData.docs) {
      UserModel user = UserModel.fromMap(i.data());
      users.add(user);
    }

    return users;
  }

  Future<UserModel?> fetchUserProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _store.collection("Users").doc(_auth.currentUser!.uid).get();
      Map<String, dynamic> userData = userDoc.data()!;
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateAboutForUser(String uid, String about) async {
    await _store
        .collection("Users")
        .doc(uid)
        .set({"about": about}, SetOptions(merge: true));
  }

  Future<bool> didGavePermissionOfContact() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<String>?> _getContactsList() async {
    if (await FlutterContacts.requestPermission()) {
      List<String> numbers = [];
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      for (int i = 0; i < contacts.length; i++) {
        // numbers.add(contacts[i].phones[0].number);
        if (contacts[i].phones.isNotEmpty) {
          String number = contacts[i].phones[0].normalizedNumber;
          numbers.add(number);
        }
      }

      return numbers;
    }

    return null;
  }

  Future<List<UserModel>?> getUserFromContact() async {
    List<String>? contacts = await _getContactsList();
    List<UserModel> users = [];

    if (contacts != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> suggestedPersons =
            await _store.collection("Users").get();
        for (int i = 0; i < suggestedPersons.docs.length; i++) {
          Map<String, dynamic> user = suggestedPersons.docs[i].data();
          if (contacts.contains(user["phone"]) &&
              user["uid"] != _auth.currentUser!.uid) {
            UserModel suggest = UserModel.fromMap(user);
            users.add(suggest);
          }
        }

        return users;
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<List<String>> userConnectedWithMe() async {
    QuerySnapshot<Map<String, dynamic>> docs = await _store
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .collection("connects")
        .get();
    List<String> users = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs.docs) {
      users.add(doc.id);
    }

    return users;
  }

  Future<List<String>> usersWhoRequestedMe() async {
    QuerySnapshot<Map<String, dynamic>> docs = await _store
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .collection("requests")
        .get();
    List<String> users = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs.docs) {
      users.add(doc.id);
    }

    return users;
  }

  Future<void> updateUserData(UserModel userModel) async {
    await _store
        .collection("Users")
        .doc(userModel.uid)
        .set(userModel.toMap(), SetOptions(merge: true));
  }

  Future verifyUserEmailIntoFirebase(String isEmailverfied) async {
    await _store
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .set({"isEmailVerified": true}, SetOptions(merge: true));
  }

  Future verifyUserPhoneIntoFirebase(String isPhoneVerfied) async {
    await _store
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .set({"isPhoneVerified": true}, SetOptions(merge: true));
  }

  Future<UserModel?> fetchUserProfileByUid(String userUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _store.collection("Users").doc(userUid).get();
      Map<String, dynamic> userData = userDoc.data()!;
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }
}
