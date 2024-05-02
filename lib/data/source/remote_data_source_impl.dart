import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/data/source/remote_data_source.dart';
import 'package:idute_app/domain/entity/comment_entity.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/domain/entity/reply_entity.dart';
import 'package:idute_app/domain/entity/user_entity.dart';
import 'package:idute_app/model/post/comment_replies_model.dart';
import 'package:idute_app/model/post/post_comments_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../model/post/post_model.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  RemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;
  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final audioUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await audioUrl;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConstants.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) {
      List<UserModel> user = [];
      for (var document in querySnapshot.docs) {
        user.add(
          UserModel.fromMap(document.data()),
        );
      }
      return user;
    });
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    final newPost = PostModel(
      postId: post.postId,
      views: 0,
      userId: post.userId,
      userName: post.userName,
      userProfileUrl: post.userProfileUrl,
      problem: post.problem,
      audio: post.audio,
      category: post.category,
      comments: post.comments,
      validate: post.validate,
      totalValidates: post.totalValidates,
      createdTime: post.createdTime,
    ).toMap();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost);
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    try {
      postCollection.doc(post.postId).delete();
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Stream<List<PostEntity>> readPosts() {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createdTime", descending: true);
    return postCollection.snapshots().map((event) {
      List<PostModel> posts = [];
      for (var document in event.docs) {
        posts.add(
          PostModel.fromMap(document.data()),
        );
      }
      return posts;
    });

    // List<PostModel> posts = [];
    // for (QueryDocumentSnapshot<Map<String, dynamic>> docs
    //     in postCollection.docs) {
    //   // print(docs.data()["postId"]);
    //   await firebaseFirestore
    //       .collection("posts")
    //       .doc(docs.data()["postId"])
    //       .set({"views": FieldValue.increment(1)}, SetOptions(merge: true));
    //   posts.add(PostModel.fromMap(docs.data()));
    // }

    // return posts;
  }

  @override
  Stream<List<PostEntity>> readPostsByCategory(
      List<PostEntity> post, CategoryEnum category) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .where("category", isEqualTo: category.fromCategoryEnum().toLowerCase())
        .orderBy("createdTime", descending: true);
    return postCollection.snapshots().map((event) {
      List<PostModel> posts = [];
      for (var document in event.docs) {
        posts.add(
          PostModel.fromMap(document.data()),
        );
      }
      return posts;
    });
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createdTime", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((event) {
      List<PostModel> posts = [];
      for (var document in event.docs) {
        posts.add(
          PostModel.fromMap(document.data()),
        );
      }
      return posts;
    });
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    print("update");
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    Map<String, dynamic> postInfo = {};

    postInfo['problem'] = post.problem;
    postInfo['audio'] = post.audio;
    postInfo['category'] = post.category!.fromCategoryEnum().toLowerCase();
    print(postInfo);
    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> validatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      final totalValidates = postRef.get("totalValidates");
      print(postRef.get("validate"));
      List validate = postRef.get("validate");
      print(validate);
      if (validate.contains(currentUid)) {
        postCollection.doc(post.postId).update(
          {
            "validate": FieldValue.arrayRemove([currentUid]),
            "totalValidates": totalValidates - 1,
          },
        );
      } else {
        print("hello");
        postCollection.doc(post.postId).update(
          {
            "validate": FieldValue.arrayUnion([currentUid]),
            "totalValidates": totalValidates + 1,
          },
        );
      }
    }
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);

    DocumentSnapshot<Map<String, dynamic>> post =
        await firebaseFirestore.collection("posts").doc(comment.postId).get();
    PostModel postModel = PostModel.fromMap(post.data()!);

    await firebaseFirestore.collection("posts").doc(comment.postId).set({
      "commentsList": FieldValue.arrayUnion([comment.userId])
    }, SetOptions(merge: true));

    final newComment = PostCommentsModel(
      comment: comment.comment,
      commentId: comment.commentId,
      userId: comment.userId,
      postId: comment.postId,
      userName: comment.userName,
      userProfileUrl: comment.userProfileUrl,
      likes: const [],
      createdTime: comment.createdTime,
      totalReply: comment.totalReply,
    ).toMap();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConstants.posts)
              .doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('comments');
              postCollection.update({"comments": totalComments + 1});
              return;
            }
          });
        });
        NotificationControllers()
            .createNotificationOnComment(postModel, comment.userId!);
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConstants.posts)
            .doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('comments');
            postCollection.update({"comments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(postId)
        .collection(FirebaseConstants.comment)
        .orderBy("createdTime", descending: true);
    return commentCollection.snapshots().map((querySnapshot) {
      List<PostCommentsModel> comments = [];
      for (var document in querySnapshot.docs) {
        comments.add(
          PostCommentsModel.fromMap(document.data()),
        );
      }
      return comments;
    });
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);

    Map<String, dynamic> commentInfo = {};

    if (comment.comment != "" && comment.comment != null) {
      commentInfo["comment"] = comment.comment;
    }

    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    final newReply = CommentRepliesModel(
      replyId: reply.replyId,
      commentId: reply.commentId,
      postId: reply.postId,
      userId: reply.userId,
      userName: reply.userName,
      userProfileUrl: reply.userProfileUrl,
      reply: reply.reply,
      likes: const [],
      createdTime: reply.createdTime,
    ).toMap();

    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReply).then((value) {
          final commentCollection = firebaseFirestore
              .collection(FirebaseConstants.posts)
              .doc(reply.postId)
              .collection(FirebaseConstants.comment)
              .doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplys = value.get('totalReply');
              commentCollection.update({"totalReply": totalReplys + 1});
              return;
            }
          });
        });
      } else {
        replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    try {
      replyCollection.doc(reply.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConstants.posts)
            .doc(reply.postId)
            .collection(FirebaseConstants.comment)
            .doc(reply.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplys = value.get('totalReply');
            commentCollection.update({"totalReply": totalReplys - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    final currentUid = await getCurrentUid();

    final replyRef = await replyCollection.doc(reply.replyId).get();

    if (replyRef.exists) {
      List likes = replyRef.get("likes");
      if (likes.contains(currentUid)) {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);
    return replyCollection.snapshots().map((querySnapshot) {
      List<CommentRepliesModel> replys = [];
      for (var document in querySnapshot.docs) {
        replys.add(
          CommentRepliesModel.fromMap(document.data()),
        );
      }
      return replys;
    });
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    Map<String, dynamic> replyInfo = {};

    if (reply.reply != "" && reply.reply != null) {
      replyInfo['reply'] = reply.reply;
    }

    replyCollection.doc(reply.replyId).update(replyInfo);
  }

  @override
  Stream<List<PostEntity>> readUserPost(String useruid) {
    final postCollection = firebaseFirestore
        .collection("posts")
        .where("userId", isEqualTo: useruid);

    return postCollection.snapshots().map((event) {
      List<PostModel> posts = [];

      for (var document in event.docs) {
        posts.add(
          PostModel.fromMap(document.data()),
        );
      }
      return posts;
    });
  }

  @override
  Future<void> addUserReaction(PostModel post) async {
    await firebaseFirestore
        .collection("Users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("Reactions")
        .doc(post.postId)
        .set(post.toMap(), SetOptions(merge: true));
  }

  @override
  Stream<List<PostEntity>> getReactedPost(String userUid) {
    final postCollection = firebaseFirestore.collection("posts");

    return postCollection.snapshots().map((event) {
      List<PostModel> posts = [];
      print(userUid);

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in event.docs) {
        if (document.data()["commentsList"] != null) {
          List allUsersReactions = document.data()["commentsList"];
          if (allUsersReactions.contains(userUid)) {
            posts.add(PostModel.fromMap(document.data()));
          }
        }
      }
      print(posts.length);
      return posts;
    });
  }

  // @override
  // Future<void> createChatList(ChatListEntity chatList) async {
  //   final chatCollection =
  //       firebaseFirestore.collection(FirebaseConstants.chats);
  //   final newChat = ChatListModel(
  //     chatId: chatList.chatId,
  //     userName: chatList.userName,
  //     lastMessage: chatList.lastMessage,
  //     userProfileUrl: chatList.userProfileUrl,
  //     userId: chatList.userId,
  //     timeSent: chatList.timeSent,
  //   ).toMap();

  //   try {
  //     final chatListDocRef = await chatCollection.doc(chatList.chatId).get();

  //     if (!chatListDocRef.exists) {
  //       chatCollection.doc(chatList.chatId).set(newChat);
  //     } else {
  //       chatCollection.doc(chatList.chatId).update(newChat);
  //     }
  //   } catch (e) {
  //     print("some error occured $e");
  //   }
  // }

  // @override
  // Stream<List<ChatListEntity>> readChatList(ChatListEntity chatList) {
  //   final chatCollection = firebaseFirestore
  //       .collection(FirebaseConstants.chats)
  //       .orderBy("timeSent", descending: true);
  //   return chatCollection.snapshots().map((event) {
  //     List<ChatListModel> chats = [];
  //     for (var document in event.docs) {
  //       chats.add(
  //         ChatListModel.fromMap(document.data()),
  //       );
  //     }
  //     return chats;
  //   });
  // }

  // @override
  // Future<void> deleteChatList(ChatListEntity chatList) async {
  //   final chatCollection =
  //       firebaseFirestore.collection(FirebaseConstants.chats);
  //   try {
  //     chatCollection.doc(chatList.chatId).delete();
  //   } catch (e) {
  //     print("some error occured $e");
  //   }
  // }

  // @override
  // Future<void> createMessage(MessageEntity message) {
  //   // TODO: implement createMessage
  //   throw UnimplementedError();
  // }

  //  @override
  // Stream<List<MessageEntity>> readMessage(MessageEntity message) {
  //   // TODO: implement readMessage
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> deleteMessage(MessageEntity message) {
  //   // TODO: implement deleteMessage
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> updateMessage(MessageEntity message) {
  //   // TODO: implement updateMessage
  //   throw UnimplementedError();
  // }
}
