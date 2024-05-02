import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/reply_entity.dart';
import '../../../domain/usecases/reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final ReadReplysUseCase readReplysUseCase;
  final UpdateReplyUseCase updateReplyUseCase;
  ReplyCubit(this.createReplyUseCase, this.updateReplyUseCase,
      this.readReplysUseCase, this.likeReplyUseCase, this.deleteReplyUseCase)
      : super(ReplyInitial());

  Future<void> getReplys({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = readReplysUseCase.call(reply);
      streamResponse.listen((replys) {
        emit(ReplyLoaded(replys: replys));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    try {
      await likeReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyEntity reply}) async {
    try {
      await createReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    try {
      await updateReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
