import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/auth_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/bottombar_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/fetch_group_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/google_auth_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/profileupdate_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/comment_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/get_single_post_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/reply_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/user/get_single_user_cubit.dart';
import 'package:idute_app/firebase_options.dart';
import 'package:idute_app/view/home/home.dart';
import 'package:idute_app/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseNotificationBackgroundService);
  await init();
  print("here main");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

@pragma("vm:entry-point")
Future<void> firebaseNotificationBackgroundService(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LandingPageCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => GoogleAuthCubit()),
        BlocProvider(
            create: (context) => PostCubit(
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call(),
                sl.call())),
        BlocProvider(
            create: (context) => CommentCubit(
                sl.call(), sl.call(), sl.call(), sl.call(), sl.call())),
        BlocProvider(
            create: (context) => ReplyCubit(
                sl.call(), sl.call(), sl.call(), sl.call(), sl.call())),
        BlocProvider(
            create: (context) =>
                GetSinglePostCubit(readSinglePostUseCase: sl.call())),
        BlocProvider(
            create: (context) =>
                GetSingleUserCubit(getSingleUserUseCase: sl.call())),
        BlocProvider(create: (context) => ProfileUpdateCubit()),
        BlocProvider(create: (context) => FetchGroupCubit()),
      ],
      child: MaterialApp(
        title: 'IDUTE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.roboto().fontFamily,
          splashColor: AppColors.sBackgroundColor,
          scaffoldBackgroundColor: AppColors.sBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.sBackgroundColor,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 15, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 20, color: Colors.white),
            bodyLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseConstants.firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
