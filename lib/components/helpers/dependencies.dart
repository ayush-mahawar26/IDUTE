import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../controller/BuisnessLogic/posts/comment_cubit.dart';
import '../../controller/BuisnessLogic/posts/get_single_post_cubit.dart';
import '../../controller/BuisnessLogic/posts/post_cubit.dart';
import '../../controller/BuisnessLogic/posts/reply_cubit.dart';
import '../../controller/BuisnessLogic/user/get_single_user_cubit.dart';
import '../../data/repos/repository_impl.dart';
import '../../data/source/remote_data_source.dart';
import '../../data/source/remote_data_source_impl.dart';
import '../../domain/repository/repository.dart';
import '../../domain/usecases/comment_usecase.dart';
import '../../domain/usecases/post_usecase.dart';
import '../../domain/usecases/reply_usecase.dart';
import '../../domain/usecases/upload_image_to_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  // sl.registerFactory(
  //   () => AuthCubit(
  //     signOutUseCase: sl.call(),
  //     isSignInUseCase: sl.call(),
  //     getCurrentUidUseCase: sl.call(),
  //   ),
  // );

  // sl.registerFactory(
  //   () => CredentialCubit(
  //     signUpUseCase: sl.call(),
  //     signInUserUseCase: sl.call(),
  //   ),
  // );

  // sl.registerFactory(
  //   () => UserCubit(
  //       updateUserUseCase: sl.call(),
  //       getUsersUseCase: sl.call(),
  //       followUnFollowUseCase: sl.call()),
  // );

  sl.registerFactory(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  // sl.registerFactory(
  //   () => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()),
  // );

  // Post Cubit Injection
  sl.registerFactory(
    () => PostCubit(sl.call(), sl.call(), sl.call(), sl.call(), sl.call(),
        sl.call(), sl.call(), sl.call(), sl.call()),
  );

  sl.registerFactory(
    () => GetSinglePostCubit(readSinglePostUseCase: sl.call()),
  );

  // Comment Cubit Injection
  sl.registerFactory(
    () => CommentCubit(
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );

  // Replay Cubit Injection
  sl.registerFactory(
    () => ReplyCubit(
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );

  // // Use Cases
  // // User
  // sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => FollowUnFollowUseCase(repository: sl.call()));
  // sl.registerLazySingleton(
  //     () => GetSingleOtherUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostOfUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => AddUserReactionToPostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetReactionPost(repository: sl.call()));
  sl.registerLazySingleton(() => ValidatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => ReadCategoryPostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Replay
  sl.registerLazySingleton(() => CreateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<Repository>(
      () => RepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(
      firebaseFirestore: sl.call(),
      firebaseAuth: sl.call(),
      firebaseStorage: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
