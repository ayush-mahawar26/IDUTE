import '../entity/reply_entity.dart';
import '../repository/repository.dart';

class CreateReplyUseCase {
  final Repository repository;

  CreateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.createReply(reply);
  }
}

class DeleteReplyUseCase {
  final Repository repository;

  DeleteReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.deleteReply(reply);
  }
}
class LikeReplyUseCase {
  final Repository repository;

  LikeReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.likeReply(reply);
  }
}
class ReadReplysUseCase {
  final Repository repository;

  ReadReplysUseCase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repository.readReply(reply);
  }
}
class UpdateReplyUseCase {
  final Repository repository;

  UpdateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.updateReply(reply);
  }
}
