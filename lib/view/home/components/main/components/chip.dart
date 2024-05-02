import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/components/helpers/dependencies.dart';

import '../../../../../components/constants/colors.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/widgets/normal_text_widget.dart';
import '../../../../../controller/BuisnessLogic/posts/post_cubit.dart';
import '../../../../../domain/entity/post_entity.dart';

class BuildChoiceChip extends StatefulWidget {
  List<PostEntity> posts;

  BuildChoiceChip({
    super.key,
    required this.posts,
  });

  @override
  State<BuildChoiceChip> createState() => _BuildChoiceChipState();
}

class _BuildChoiceChipState extends State<BuildChoiceChip> {
  @override
  Widget build(BuildContext context) {
    // list of chips
    List<CategoryEnum> items = [
      CategoryEnum.technology,
      CategoryEnum.arts,
      CategoryEnum.business,
      CategoryEnum.fashion,
      CategoryEnum.history,
      CategoryEnum.legal,
      CategoryEnum.science
    ];
    bool isSelected = false;
    int? _value;

    return Padding(
      padding: EdgeInsets.only(
        right: getProportionateScreenWidth(0),
        left: getProportionateScreenWidth(0),
      ),
      child: SizedBox(
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
                  child: _buildChip(items, index, context, isSelected, _value),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildChip(
    List<CategoryEnum> items,
    int index,
    BuildContext context,
    bool isSelected,
    int? value,
  ) {
    return ChoiceChip(
      elevation: 1,
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
      selected: value == index,
      onSelected: (bool selected) {
        setState(() {
          value = selected ? index : null;
        });
      },

      // onSelected: (item) {
      //   if (item) {
      //     setState(() {
      //       BlocProvider(
      //         create: (context) => sl<PostCubit>()
      //           ..getPostsByCategory(
      //               post: widget.posts, category: items[index]),
      //       );
      //       print(widget.posts);
      //       isSelected = !isSelected;
      //       print(item);
      //     });
      //   } else {
      //     setState(() {
      //       BlocProvider(
      //           create: (context) => sl<PostCubit>()
      //             ..getPosts(
      //               post: PostEntity(),
      //             ));
      //     });
      //   }
      // },
      // selected: isSelected,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
      disabledColor: Colors.white,
      selectedColor: AppColors.kcardColor,
      backgroundColor: Colors.black,
    );
  }
}
