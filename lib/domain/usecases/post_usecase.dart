import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/domain/repository/repository.dart';
import 'package:idute_app/model/post/post_model.dart';

import '../entity/post_entity.dart';

class CreatePostUseCase {
  final Repository repository;

  CreatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.createPost(post);
  }
}

class DeletePostUseCase {
  final Repository repository;

  DeletePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.deletePost(post);
  }
}

class ValidatePostUseCase {
  final Repository repository;

  ValidatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.validatePost(post);
  }
}

class ReadPostUseCase {
  final Repository repository;

  ReadPostUseCase({required this.repository});

  Stream<List<PostEntity>> call() {
    return repository.readPosts();
  }
}

class AddUserReactionToPostUseCase {
  final Repository repository;

  AddUserReactionToPostUseCase({required this.repository});

  Future<void> call(PostModel post) async {
    return repository.addUserReaction(post);
  }
}

class ReadPostOfUserUseCase {
  final Repository repository;

  ReadPostOfUserUseCase({required this.repository});

  Stream<List<PostEntity>> call(String useruid) {
    return repository.readUserPost(useruid);
  }
}

class GetReactionPost {
  final Repository repository;

  GetReactionPost({required this.repository});

  Stream<List<PostEntity>> call(String useruid) {
    return repository.getReactedPost(useruid);
  }
}

class ReadSinglePostUseCase {
  final Repository repository;

  ReadSinglePostUseCase({required this.repository});

  Stream<List<PostEntity>> call(String postId) {
    return repository.readSinglePost(postId);
  }
}

class ReadCategoryPostUseCase {
  final Repository repository;

  ReadCategoryPostUseCase({required this.repository});

  Stream<List<PostEntity>> call(List<PostEntity> post, CategoryEnum category) {
    return repository.readPostsByCategory(post, category);
  }
}

class UpdatePostUseCase {
  final Repository repository;

  UpdatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
