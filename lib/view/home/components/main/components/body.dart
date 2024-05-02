import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/domain/entity/post_entity.dart';

import 'card_list.dart';
import 'chip.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<CategoryEnum> items = [
    CategoryEnum.technology,
    CategoryEnum.arts,
    CategoryEnum.business,
    CategoryEnum.fashion,
    CategoryEnum.history,
    CategoryEnum.legal,
    CategoryEnum.science
  ];
  List<bool> isSelectedCategory = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List<Widget>.generate(
                items.length,
                (int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(4),
                    ),
                    child: Padding(
                      padding: (index == 0)
                          ? const EdgeInsets.only(left: 10)
                          : const EdgeInsets.only(left: 0),
                      child: _buildChip(items, index, context),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          BlocBuilder<PostCubit, PostState>(
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
                return BuildCardList(
                  posts: state.posts,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    List<CategoryEnum> items,
    int index,
    BuildContext context,
  ) {
    return FilterChip(
      elevation: 0,
      side: const BorderSide(
        width: 1,
        color: Color(0xff959595),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: SizedBox(
        width: getProportionateScreenWidth(85),
        height: getProportionateScreenHeight(20),
        child: Center(
          child: buildText(
            text: items[index].fromCategoryEnum(),
            color: AppColors.kPrimaryColor,
            txtSize: 12,
          ),
        ),
      ),
      selected: isSelectedCategory[index],
      onSelected: (bool selected) {
        setState(() {
          isSelectedCategory[index] = !isSelectedCategory[index];
          for (var i = 0; i < isSelectedCategory.length; i++) {
            if (i != index) {
              isSelectedCategory[i] = false;
            }
          }
        });
        if (isSelectedCategory[index]) {
          context
              .read<PostCubit>()
              .getPostsByCategory(post: [PostEntity()], category: items[index]);
          print(selected);
          print(isSelectedCategory);
        } else {
          print(selected);
          print(isSelectedCategory);
          context.read<PostCubit>().getPosts(post: PostEntity());
        }
      },
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
      disabledColor: Colors.red,
      selectedColor: AppColors.kcardColor,
      backgroundColor: AppColors.sBackgroundColor,
    );
  }
}
