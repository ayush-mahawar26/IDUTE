import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/view/home/components/main/components/search.view.dart';
import 'package:idute_app/view/home/components/profile/chat/message_view.dart';

import 'components/body.dart';
import 'components/home_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(searchTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => const SearchView()));
      }, onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MessageScreen(),
          ),
        );
      }),
      body: BlocProvider(
        create: (context) => sl<PostCubit>()..getPosts(post: PostEntity()),
        child: Body(),
      ),

      // BlocProvider(
      //   create: (context) => sl<PostCubit>()
      //     ..getPosts(
      //       post: PostEntity(),
      //     ),
      //   child: BlocBuilder<PostCubit, PostState>(
      //     builder: (context, state) {
      //       if (state is PostLoading) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       if (state is PostFailure) {
      //         CustomSnackBar().showSnackBar(
      //             context: context,
      //             text: "Some Failure occured while creating the post",
      //             color: Colors.red,
      //             duration: Durations.long2);
      //       }
      //       if (state is PostLoaded) {
      //         return Body(posts: state.posts);
      //       }
      //       return const Center(child: CircularProgressIndicator());
      //     },
      //   ),
      // ),
    );
  }
}
