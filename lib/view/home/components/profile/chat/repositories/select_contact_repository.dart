// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_clone/components/snackbar.dart';
// import 'package:whatsapp_clone/constants/routes.dart';
// import 'package:whatsapp_clone/models/user_model.dart';

// import '../../../../../../model/user_model.dart';

// final selectContactRepositoryProvider = Provider(
//   (ref) => SelectContactRepository(
//     firestore: FirebaseFirestore.instance,
//   ),
// );

// class SelectContactRepository {
//   final FirebaseFirestore firestore;
//   SelectContactRepository({
//     required this.firestore,
//   });

//   Future<List<Contact>> getContacts() async {
//     List<Contact> contacts = [];
//     try {
//       if (await FlutterContacts.requestPermission()) {
//         contacts = await FlutterContacts.getContacts(
//           withProperties: true,
//         );
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return contacts;
//   }

//   void selectContact(Contact selectedContact, BuildContext context) async {
//     try {
//       var userCollection = await firestore.collection('users').get();
//       bool isFound = false;

//       for (var document in userCollection.docs) {
//         UserModel? userData;
//         userData = UserModel.fromMap(document.data());

//         var selectedPhoneNumber = selectedContact.phones[0].normalizedNumber;

//         if (selectedPhoneNumber == userData.phoneNumber) {
//           isFound = true;
//           Navigator.of(context).pushNamed(
//             chatRoute,
//             arguments: {
//               "name": userData.name,
//               "uid": userData.uid,
//             },
//           );
//         }
//       }
//       if (!isFound) {
//         showSnackBar(
//           context: context,
//           content: "This number doesn't exist in app",
//         );
//       }
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }
// }
