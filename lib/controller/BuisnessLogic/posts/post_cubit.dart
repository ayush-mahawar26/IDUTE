import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/model/post/post_model.dart';

import '../../../components/enums/category_enums.dart';
import '../../../domain/entity/post_entity.dart';
import '../../../domain/usecases/post_usecase.dart';
part 'post_states.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final ValidatePostUseCase validatePostUseCase;
  final AddUserReactionToPostUseCase addUserReactionToPost;
  final GetReactionPost getReactionPost;
  final ReadPostUseCase readPostUseCase;
  final ReadPostOfUserUseCase readUserPosts;
  final UpdatePostUseCase updatePostUseCase;
  final ReadCategoryPostUseCase readCategoryPostUseCase;
  PostCubit(
      this.addUserReactionToPost,
      this.updatePostUseCase,
      this.readCategoryPostUseCase,
      this.deletePostUseCase,
      this.getReactionPost,
      this.validatePostUseCase,
      this.createPostUseCase,
      this.readPostUseCase,
      this.readUserPosts)
      : super(PostInitial());

  Future<void> getPosts(
      {CategoryEnum category = CategoryEnum.technology,
      required PostEntity post}) async {
    emit(PostLoading());

    try {
      final streamResponse = readPostUseCase.call();
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts, category));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getPostsByCategory(
      {required List<PostEntity> post, required CategoryEnum category}) async {
    emit(PostLoading());
    try {
      final streamResponse = readCategoryPostUseCase.call(post, category);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts, category));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getUserPost({required String userUid}) async {
    try {
      final streamResponse = readUserPosts.call(userUid);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts, CategoryEnum.arts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getReactedPost({required String userUid}) async {
    try {
      final streamResponse = getReactionPost.call(userUid);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts, CategoryEnum.arts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> validatePost({required PostEntity post}) async {
    try {
      PostModel postModel = PostModel(
          postId: post.postId,
          views: post.views,
          userId: post.userId,
          problem: post.problem,
          userProfileUrl: post.userProfileUrl,
          userName: post.userName,
          audio: post.audio,
          validate: post.validate,
          totalValidates: post.totalValidates,
          comments: post.comments,
          category: post.category,
          createdTime: post.createdTime);
      // print(postModel.toMap());
      await validatePostUseCase.call(post);
      await addUserReactionToPost.call(postModel);
      // await NotificationControllers().notificationOnLike(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    try {
      await deletePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    try {
      await createPostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    try {
      await updatePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
