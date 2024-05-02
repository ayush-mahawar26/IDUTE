part of '../posts/post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;
  final CategoryEnum category;

  PostLoaded(this.category, {required this.posts});
  @override
  List<Object> get props => [posts];
}

class PostFailure extends PostState {
  @override
  List<Object> get props => [];
}
