import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/chat_list_model.dart';
import 'package:idute_app/view/home/components/profile/chat/chat_screen.dart';
import 'package:idute_app/view/home/components/profile/chat/components/message_widget.dart';
import 'package:idute_app/view/home/components/profile/chat/controllers/chat_controller.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sBackgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    buildText(text: "Inbox", txtSize: 20)
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _searchController,
                  cursorColor: AppColors.kFillColor,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: "Search People",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/icons/search.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(),
                      filled: true,
                      fillColor: AppColors.kcardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              buildSizeHeight(height: 2),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: buildText(
                      text: "Chat",
                    ),
                  ),
                  Tab(
                    icon: buildText(
                      text: "Message",
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<ChatContactModel>>(
                        stream:
                            ref.watch(chatControllerProvider).chatContacts(),
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              var chatContactData;
                              if (snapshot.data != null) {
                                chatContactData = snapshot.data![index];
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        name: chatContactData.name,
                                        profileUrl: chatContactData.profilePic,
                                        uid: chatContactData.contactId,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ChatWidget(
                                    chatContactData: chatContactData,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<ChatContactModel>>(
                        stream:
                            ref.watch(chatControllerProvider).chatContacts(),
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              var chatContactData;
                              if (snapshot.data != null) {
                                chatContactData = snapshot.data![index];
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        name: chatContactData.name,
                                        profileUrl: chatContactData.profilePic,
                                        uid: chatContactData.contactId,
                                      ),
                                    ),
                                  );
                                },
                                child: ChatWidget(
                                  chatContactData: chatContactData,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
