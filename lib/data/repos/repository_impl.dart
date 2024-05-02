import 'dart:io';

import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/domain/entity/chat_list_entity.dart';
import 'package:idute_app/domain/entity/comment_entity.dart';
import 'package:idute_app/domain/entity/message_entity.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/domain/entity/reply_entity.dart';
import 'package:idute_app/model/post/post_model.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/repository/repository.dart';
import '../source/remote_data_source.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;

  RepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Future<String> uploadImageToStorage(
          File? file, bool isPost, String childName) async =>
      remoteDataSource.uploadImageToStorage(file, isPost, childName);

  @override
  Future<void> createPost(PostEntity post) async =>
      remoteDataSource.createPost(post);
  @override
  Future<void> deletePost(PostEntity post) async =>
      remoteDataSource.deletePost(post);

  @override
  Stream<List<PostEntity>> readPosts() =>
      remoteDataSource.readPosts();

  @override
  Future<void> updatePost(PostEntity post) async =>
      remoteDataSource.updatePost(post);

  @override
  Future<void> validatePost(PostEntity post) async =>
      remoteDataSource.validatePost(post);

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) =>
      remoteDataSource.readSinglePost(postId);

  @override
  Stream<List<PostEntity>> readPostsByCategory(
          List<PostEntity> post, CategoryEnum category) =>
      remoteDataSource.readPostsByCategory(post, category);

  @override
  Future<void> createComment(CommentEntity comment) async =>
      remoteDataSource.createComment(comment);

  @override
  Future<void> createReply(ReplyEntity reply) async =>
      remoteDataSource.createReply(reply);

  @override
  Future<void> deleteComment(CommentEntity comment) async =>
      remoteDataSource.deleteComment(comment);

  @override
  Future<void> deleteReply(ReplyEntity reply) async =>
      remoteDataSource.deleteReply(reply);

  @override
  Future<void> likeComment(CommentEntity comment) async =>
      remoteDataSource.likeComment(comment);

  @override
  Future<void> likeReply(ReplyEntity reply) async =>
      remoteDataSource.likeReply(reply);

  @override
  Stream<List<CommentEntity>> readComments(String postId) =>
      remoteDataSource.readComments(postId);

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply) =>
      remoteDataSource.readReply(reply);

  @override
  Future<void> updateComment(CommentEntity comment) async =>
      remoteDataSource.updateComment(comment);

  @override
  Future<void> updateReply(ReplyEntity reply) async =>
      remoteDataSource.updateReply(reply);

  @override
  Stream<List<PostEntity>> readUserPost(String userUid) =>
      remoteDataSource.readUserPost(userUid);

  @override
  Future<void> addUserReaction(PostModel post) async {
    return remoteDataSource.addUserReaction(post);
  }

  @override
  Stream<List<PostEntity>> getReactedPost(String userUid) =>
      remoteDataSource.getReactedPost(userUid);

  // @override
  // Future<void> createChatList(ChatListEntity chatList) async =>
  //     remoteDataSource.createChatList(chatList);

  // @override
  // Future<void> createMessage(MessageEntity message)  async =>
  //     remoteDataSource.createMessage(message);

  // @override
  // Future<void> deleteChatList(ChatListEntity chatList) async =>
  //     remoteDataSource.deleteChatList(chatList);

  // @override
  // Future<void> deleteMessage(MessageEntity message)  async =>
  //     remoteDataSource.deleteMessage(message);

  // @override
  // Stream<List<ChatListEntity>> readChatList(ChatListEntity chatList)   =>
  //     remoteDataSource.readChatList(chatList);

  // @override
  // Stream<List<MessageEntity>> readMessage(MessageEntity message)   =>
  //     remoteDataSource.readMessage(message);

  // @override
  // Future<void> updateMessage(MessageEntity message)  async =>
  //     remoteDataSource.updateMessage(message);
}
