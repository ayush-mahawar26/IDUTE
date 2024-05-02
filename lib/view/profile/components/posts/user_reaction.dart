import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/view/home/components/main/components/card_list.dart';
import 'package:idute_app/view/profile/components/reaction_widget.dart';

class UserReactedPostView extends StatelessWidget {
  String useruid;
  UserReactedPostView({super.key, required this.useruid});

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  @override
  Widget build(BuildContext context) {
    print(useruid);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BlocProvider(
        create: (context) => sl<PostCubit>()..getReactedPost(userUid: useruid),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PostFailure) {
              CustomSnackBar().showSnackBar(
                  context: context,
                  text: "Some Failure occured while creating the post",
                  color: Colors.red,
                  duration: Durations.long2);
            }
            if (state is PostLoaded) {
              if (state.posts.isEmpty) {
                return ErrorScreen(
                    error: "No Reaction on any post",
                    errorIcon: const Icon(
                      Icons.error,
                      color: AppColors.kFillColor,
                    ));
              } else {
                return Column(
                  children: [
                    ReactedWidget(
                      posts: state.posts,
                      useruid: useruid,
                    ),
                  ],
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
