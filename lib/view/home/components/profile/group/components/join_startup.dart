import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/custom_group_card.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/group_bottomsheet.dart';
import 'package:idute_app/components/widgets/nda_form.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/fetch_group_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/fetch_group_states.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';

class JoinStartUp extends StatefulWidget {
  const JoinStartUp({super.key});

  @override
  State<JoinStartUp> createState() => _JoinStartUpState();
}

class _JoinStartUpState extends State<JoinStartUp> {
  bool suggested = true;

  List<String> selectedCategories = [];

  final _controller = ValueNotifier<bool>(false);

  void _onCategorySelected(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  _showNDAForm(BuildContext context, GroupModel group) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: GroupController().checkForRequestAlreadySent(
                FirebaseConstants.firebaseAuth.currentUser!.uid, group),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return RequestSentBottomSheet(
                      icon: const Icon(
                        Icons.check_circle,
                        color: AppColors.kBackgroundColor,
                        size: 40,
                      ),
                      title: "Request Sent",
                      text:
                          "Your request has been send, we will let you know once the founder of this startup accepts your request");
                } else {
                  return NDAFormBottomSheet(group: group);
                }
              }

              if (snapshot.hasError) {
                RequestSentBottomSheet(
                    icon: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: Colors.red.shade900,
                      size: 40,
                    ),
                    title: "Error Occured",
                    text: "Some connection issue occured");
              }

              return const CircularProgressIndicator();
            });
      },
    );
  }

  _show(BuildContext ctx) {
    FetchGroupCubit groupCubit = BlocProvider.of<FetchGroupCubit>(ctx);

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: AppColors.kFillColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText(text: "Select Category"),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedCategories.isEmpty) {
                                  groupCubit.getAllGroups();
                                } else {
                                  groupCubit
                                      .getByCategories(selectedCategories);
                                }
                              },
                              child: Center(
                                child: buildText(
                                    text: "Apply",
                                    color: AppColors.sBackgroundColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Health Care"),
                      value: selectedCategories.contains('Health Care'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Health Care')
                              : selectedCategories.remove('Health Care');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "FinTech"),
                      value: selectedCategories.contains('FinTech'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('FinTech')
                              : selectedCategories.remove('FinTech');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Education"),
                      value: selectedCategories.contains('Education'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Education')
                              : selectedCategories.remove('Education');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Customer Goods"),
                      value: selectedCategories.contains('Customer Goods'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Customer Goods')
                              : selectedCategories.remove('Customer Goods');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Technology"),
                      value: selectedCategories.contains('Technology'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Technology')
                              : selectedCategories.remove('Technology');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Fashion"),
                      value: selectedCategories.contains('Fashion'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Fashion')
                              : selectedCategories.remove('Fashion');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Cosmetics"),
                      value: selectedCategories.contains('Cosmetics'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Cosmetics')
                              : selectedCategories.remove('Cosmetics');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Lifestyle"),
                      value: selectedCategories.contains('Lifestyle'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Lifestyle')
                              : selectedCategories.remove('Lifestyle');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Gaming"),
                      value: selectedCategories.contains('Gaming'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Gaming')
                              : selectedCategories.remove('Gaming');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: buildText(text: "Communication"),
                      value: selectedCategories.contains('Communication'),
                      onChanged: (bool? value) {
                        setState(() {
                          value!
                              ? selectedCategories.add('Communication')
                              : selectedCategories.remove('Communication');
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          suggested = true;
        } else {
          suggested = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        FetchGroupCubit groupCubit = BlocProvider.of<FetchGroupCubit>(context);
        await groupCubit.getAllGroups();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdvancedSwitch(
                  controller: _controller,
                  enabled: true,
                  width: 75,
                  height: 32,
                  activeColor: AppColors.kcardColor,
                  inactiveColor: AppColors.kcardColor,
                  activeChild: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: buildText(
                        text: "top", txtSize: 10, fontWeight: FontWeight.bold),
                  ),
                  inactiveChild: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: buildText(
                        text: "new", txtSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _show(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.kcardColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 12, right: 4.5),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildText(text: "Idea Category", txtSize: 12),
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: BlocBuilder<FetchGroupCubit, FetchGroupsStates>(
              builder: (context, state) {
            if (state is ErrorInFetchGroupState) {
              return ErrorScreen(
                  error: state.err, errorIcon: const Icon(Icons.error));
            }
            if (state is FetchedGroupState) {
              if (state.groups.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    FetchGroupCubit groupCubit =
                        BlocProvider.of<FetchGroupCubit>(context);
                    await groupCubit.getAllGroups();
                  },
                  child: ErrorScreen(
                      error: "No groups Available",
                      errorIcon: const Icon(
                        Icons.error,
                        color: AppColors.kHintColor,
                        size: 20,
                      )),
                );
              }

              return ListView.builder(
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: InkWell(
                          onTap: () {
                            _showNDAForm(context, state.groups[index]);
                          },
                          child: ListTile(
                            leading: Image.asset("assets/images/grp_card.png"),
                            // const CircleAvatar(
                            //   backgroundImage:
                            //       AssetImage("assets/images/grp_card.png"),
                            //   radius: 35,
                            // ),
                            title: buildText(
                              text: state.groups[index].title,
                              txtSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitle: buildText(
                              text: state.groups[index].description,
                              txtSize: 10,
                              fontWeight: FontWeight.w400,
                              maxLine: 3,
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                _showBottonSheet(context, state.groups[index]);
                              },
                              child: SvgPicture.asset(
                                "assets/icons/card_1.svg",
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),

                          //  CustomGroupCard(
                          //   group: state.groups[index],
                          //   isjoinStartUp: true,
                          // ),
                        ));
                  });
            }

            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.kHintColor,
              ),
            );
          }))
        ],
      ),
    );
  }

  _showBottonSheet(BuildContext context, GroupModel model) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return GroupInfoBottomSheet(
          model: model,
        );
      },
    );
  }
}
