//TODO: show the posts of the logged in user only

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';

import '../../../home/components/main/components/card_list.dart';

class ProfilePosts extends StatelessWidget {
  String useruid;
  ProfilePosts({super.key, required this.useruid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BlocProvider(
        create: (context) => sl<PostCubit>()..getUserPost(userUid: useruid),
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
                    error: "No Post by user",
                    errorIcon: const Icon(
                      Icons.error,
                      color: AppColors.kFillColor,
                    ));
              } else {
                return Column(
                  children: [
                    BuildCardList(posts: state.posts),
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
