import 'dart:io';

import '../entity/user_entity.dart';
import '../repository/repository.dart';

class UploadImageToStorageUseCase {
  final Repository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(File file, bool isPost, String childName) {
    return repository.uploadImageToStorage(file, isPost, childName);
  }
}

class GetCurrentUidUseCase {
  final Repository repository;

  GetCurrentUidUseCase({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}

class GetSingleUserUseCase {
  final Repository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}
