import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';

class BottomSheetForGroup extends StatefulWidget {
  const BottomSheetForGroup({super.key});

  @override
  State<BottomSheetForGroup> createState() => _BottomSheetForGroupState();
}

class _BottomSheetForGroupState extends State<BottomSheetForGroup> {
  DateTime selectedDate = DateTime.now();

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String currentCategory = "Technology";

  final _formKey = GlobalKey<FormState>();

  List<String> selectedCategories = [
    "Health",
    "Fintech",
    "Education",
    "Customers Goods",
    "Technology",
    "Fashion",
    "Cosmetics",
    "Lifestyle",
    "Gaming",
    "Communication"
  ];

  Widget _entryBoxForGroups(
      BuildContext context, TextEditingController controller,
      {int? maxLine = 1, bool multipleLine = false}) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Fill details properly";
        }

        return null;
      },
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
      maxLines: maxLine,
      decoration: InputDecoration(
          fillColor: AppColors.kcardColor,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15))),
    );
  }

  final TextEditingController _title = TextEditingController();

  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              buildText(
                                  text: "Create Group",
                                  txtSize: 20,
                                  fontWeight: FontWeight.bold),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 50,
                                height: 2,
                                decoration: BoxDecoration(
                                    color: AppColors.kHintColor,
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildText(text: "Name", txtSize: 15),
                      const SizedBox(
                        height: 10,
                      ),
                      _entryBoxForGroups(context, _title),
                      const SizedBox(
                        height: 15,
                      ),
                      buildText(text: "Description", txtSize: 15),
                      const SizedBox(
                        height: 10,
                      ),
                      _entryBoxForGroups(context, _description, maxLine: 4),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText(text: "Start Date", txtSize: 15),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.kcardColor),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    buildText(
                                        text:
                                            "${selectedDate.day.toString()} / ${selectedDate.month.toString()} / ${selectedDate.year.toString()}"),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: const Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(
                                    text: "Concept Category", txtSize: 15),
                                const SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(10),
                                  dropdownColor: AppColors.sBackgroundColor,
                                  value: currentCategory,
                                  decoration: InputDecoration(
                                    fillColor: AppColors.kcardColor,
                                    filled: true,
                                    isCollapsed: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: AppColors.kBackgroundColor,
                                  ),
                                  elevation: 20,
                                  onChanged: (String? value) {
                                    currentCategory = value!;
                                  },
                                  items: selectedCategories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: buildText(
                                          text: value,
                                          color: Colors.white,
                                          txtSize: 13),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: SizeConfig.screenWidth / 3,
                            child: ElevatedButton(
                                onPressed: () async {
                                  String title = _title.text.trim();
                                  String desc = _description.text.trim();

                                  if (_formKey.currentState!.validate()) {
                                    print("here");
                                    UserModel? user = await ProfileController()
                                        .fetchUserProfile();
                                    if (user != null) {
                                      print("here");
                                      GroupModel group = GroupModel(
                                          title: title,
                                          description: desc,
                                          createdAt:
                                              Timestamp.fromDate(selectedDate),
                                          category: currentCategory,
                                          level: 0,
                                          createdBy: user.uid!,
                                          createdByName: user.name!,
                                          groupImg: "");
                                      await GroupController()
                                          .addNewGroup(group, user);
                                      print("done");
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: buildText(
                                    text: "Create",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    txtSize: 15)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
