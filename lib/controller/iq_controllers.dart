import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/iq_algo.dart';

class IqControllers {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  createIqIfNotExist(String useruid) async {
    IqModel iq = IqModel(
        postCount: 0,
        validationCount: 0,
        commentCount: 0,
        replyCount: 0,
        likeOnCommentCount: 0,
        likeOnReplyCount: 0,
        connectionCount: 0,
        connectionWithHigherIq: 0);

    await _store
        .collection("iq")
        .doc(useruid)
        .set(iq.toMap(), SetOptions(merge: true));
  }

  calculateUserIq(UserModel user) async {
    int countPost = await _countPost(user.uid!);
    int countComments = await _countComments(user.uid!);
    int validationCount = await _countValidation(user.uid!);

    IqModel iq = IqModel(
        postCount: countPost,
        validationCount: validationCount,
        commentCount: countComments,
        replyCount: 0,
        likeOnCommentCount: 0,
        likeOnReplyCount: 0,
        connectionCount: user.connects!,
        connectionWithHigherIq: 0);

    double calculateIq = UserIQCalculator.calculateIQ(iq: iq);
    int roundediq = (calculateIq / 10).round() * 10;
    await _store
        .collection("Users")
        .doc(user.uid!)
        .set({"iq": roundediq}, SetOptions(merge: true));

    await _store
        .collection("iq")
        .doc(user.uid!)
        .set(iq.toMap(), SetOptions(merge: true));
  }

  Future<int> _countPost(String useruid) async {
    QuerySnapshot<Map<String, dynamic>> posts = await _store
        .collection("posts")
        .where("userId", isEqualTo: useruid)
        .get();
    return posts.docs.length;
  }

  Future<int> _countValidation(String useruid) async {
    QuerySnapshot<Map<String, dynamic>> post = await _store
        .collection("posts")
        .where("userId", isEqualTo: useruid)
        .get();

    int validations = 0;
    for (DocumentSnapshot<Map<String, dynamic>> documents in post.docs) {
      int totalCountValidation = documents.data()!["totalValidates"];
      validations += totalCountValidation;
    }

    return validations;
  }

  Future<int> _countComments(String useruid) async {
    QuerySnapshot<Map<String, dynamic>> posts = await _store
        .collection("posts")
        .where("userId", isEqualTo: useruid)
        .get();
    int count = 0;
    for (DocumentSnapshot documents in posts.docs) {
      QuerySnapshot<Map<String, dynamic>> commentCount =
          await documents.reference.collection("comment").get();

      count += commentCount.docs.length;
    }

    return count;
  }
}
