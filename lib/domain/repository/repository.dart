import 'dart:io';

import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/model/post/post_model.dart';

import '../entity/chat_list_entity.dart';
import '../entity/comment_entity.dart';
import '../entity/message_entity.dart';
import '../entity/post_entity.dart';
import '../entity/reply_entity.dart';
import '../entity/user_entity.dart';

abstract class Repository {
  // User Features
  Future<String> getCurrentUid();
  Stream<List<UserEntity>> getSingleUser(String uid);

  // Store File
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts();
  Stream<List<PostEntity>> readPostsByCategory(
      List<PostEntity> post, CategoryEnum category);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> addUserReaction(PostModel post);
  Stream<List<PostEntity>> readUserPost(String userUid);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> validatePost(PostEntity post);
  Stream<List<PostEntity>> getReactedPost(String userUid);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  // Replay Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity replay);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

  // // Chat List Features
  // Future<void> createChatList(ChatListEntity chatList);
  // Stream<List<ChatListEntity>> readChatList(ChatListEntity chatList);
  // Future<void> deleteChatList(ChatListEntity chatList);

  // // Chat List Features
  // Future<void> createMessage(MessageEntity message);
  // Stream<List<MessageEntity>> readMessage(MessageEntity message);
  // Future<void> updateMessage(MessageEntity message);
  // Future<void> deleteMessage(MessageEntity message);
}
