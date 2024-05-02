import 'dart:io';

import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/domain/entity/user_entity.dart';
import 'package:idute_app/model/post/post_model.dart';

import '../../domain/entity/chat_list_entity.dart';
import '../../domain/entity/comment_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/entity/reply_entity.dart';

abstract class RemoteDataSource {
  Future<String> getCurrentUid();
  Stream<List<UserEntity>> getSingleUser(String uid);
  // Cloud Storage
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);
  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts();
  Stream<List<PostEntity>> readUserPost(String useruid);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Stream<List<PostEntity>> readPostsByCategory(
      List<PostEntity> post, CategoryEnum category);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> validatePost(PostEntity post);
  Future<void> addUserReaction(PostModel post);
  Stream<List<PostEntity>> getReactedPost(String userUid);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  // Reply Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

  // Chat List Features
  // Future<void> createChatList(ChatListEntity chatList);
  // Stream<List<ChatListEntity>> readChatList(ChatListEntity chatList);
  // Future<void> deleteChatList(ChatListEntity chatList);

  // // Chat List Features
  // Future<void> createMessage(MessageEntity message);
  // Stream<List<MessageEntity>> readMessage(MessageEntity message);
  // Future<void> updateMessage(MessageEntity message);
  // Future<void> deleteMessage(MessageEntity message);
}
