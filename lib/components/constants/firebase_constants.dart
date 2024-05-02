import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConstants {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore store = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static const String users = "Users";
  static const String posts = "posts";
  static const String comment = "comment";
  static const String reply = "reply";
  static const String chats = "chat";
  static final FirebaseDynamicLinks dynamicLink = FirebaseDynamicLinks.instance;
}
