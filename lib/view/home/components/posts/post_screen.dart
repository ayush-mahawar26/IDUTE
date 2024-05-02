// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idute_app/view/home/home.dart';
import 'package:uuid/uuid.dart';

import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/domain/usecases/upload_image_to_storage.dart';
import 'package:idute_app/view/home/components/main/main_screen.dart';

import '../../../../controller/user_profile_controller.dart';
import '../../../../model/user_model.dart';

class PostScreen extends StatefulWidget {
  bool isPostEditing;
  String problem;
  String path;
  String postId;
  CategoryEnum? category;

  PostScreen({
    Key? key,
    this.isPostEditing = false,
    this.problem = "",
    this.path = "",
    this.postId = "",
    this.category,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _postText = TextEditingController();
  late final RecorderController recorderController;
  late final PlayerController playerController;
  String path = "";
  bool isRecording = false;
  bool isPlaying = false;
  bool isLoading = false;
  String _currentUid = "";
  String currentCategory = "Category";
  UserModel? user;
  List<String> selectedCategories = [
    'Category',
    'Arts',
    'Fashion',
    'Technology',
    'Legal',
    'Business',
    'Science',
    'History'
  ];

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    _initialiseController();
    if (widget.isPostEditing) {
      _postText.text = widget.problem;
      currentCategory = widget.category!.fromCategoryEnum();
      path = widget.path;
    }
    playerController = PlayerController();
    playerController.preparePlayer(path: path);

    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    _postText.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      // var tempDir = await getTemporaryDirectory();
      // path = '${tempDir.path}/flutter_sound.aac';
      await recorderController.record();
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBar().showSnackBar(
          context: context,
          text: "Probelem in Recording",
          color: AppColors.errorColor,
          duration: const Duration(milliseconds: 800));
    }
  }

  Future<void> stopRecording() async {
    try {
      final finalPath = await recorderController.stop(true);
      setState(() {
        path = finalPath!;
        isRecording = false;
        isPlaying = true;
        playerController.preparePlayer(path: path);
      });
    } catch (e) {
      print(e);
    }
  }

  void _playAndPause() async {
    (isPlaying)
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }

  Future<void> _submitPost() async {
    if (path.isNotEmpty) {
      sl<UploadImageToStorageUseCase>().call(File(path), true, "posts").then(
        (audioUrl) async {
          await _createSubmitPost(audio: audioUrl);
        },
      );
    } else {
      await _createSubmitPost(audio: "");
    }
  }

  Future<void> fetchUserData() async {
    user = await ProfileController().fetchUserProfileByUid(_currentUid);
  }

  Future<void> _createSubmitPost({required String audio}) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
    await fetchUserData();
    if (widget.isPostEditing) {
      print("an");
      await BlocProvider.of<PostCubit>(context)
          .updatePost(
        post: PostEntity(
          postId: widget.postId,
          problem: _postText.text.trim(),
          audio: audio,
          category: currentCategory.toLowerCase().toCategoryEnum(),
        ),
      )
          .then((value) {
        setState(() {
          _postText.clear();
          playerController.dispose();
          path = "";
          isRecording = false;
          isPlaying = false;
          isLoading = false;
        });
      });
    } else {
      await BlocProvider.of<PostCubit>(context)
          .createPost(
              post: PostEntity(
        audio: audio,
        problem: _postText.text.trim(),
        userName: user!.username,
        userProfileUrl: user!.profileImage ?? "",
        category: currentCategory.toLowerCase().toCategoryEnum(),
        comments: 0,
        postId: const Uuid().v1(),
        validate: [],
        commentsList: [],
        totalValidates: 0,
        userId: FirebaseConstants.firebaseAuth.currentUser!.uid,
        // userName: FirebaseConstants.firebaseAuth.currentUser.,
        createdTime: DateTime.now(),
      ))
          .then((value) {
        setState(() {
          _postText.clear();
          playerController.dispose();
          path = "";
          isRecording = false;
          isPlaying = false;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostCubit>(),
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder(
                                  future:
                                      ProfileController().fetchUserProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        children: [
                                          Row(
                                            children: [
                                              (snapshot.data!.profileImage !=
                                                          "" &&
                                                      snapshot.data!
                                                              .profileImage !=
                                                          null)
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(snapshot
                                                              .data!
                                                              .profileImage!),
                                                    )
                                                  : const CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/icons/default.jpg"),
                                                    )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          buildText(
                                              text: snapshot.data!.username!),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  }),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.kcardColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  child: InkWell(
                                    onTap: isLoading
                                        ? () {}
                                        : () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await _submitPost();
                                            }
                                          },
                                    child: Row(
                                      children: [
                                        buildText(text: "Post", txtSize: 12),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                            "assets/icons/send.svg"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          buildText(
                              text: "Get validation and views on your idea"),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _postText,
                            maxLines: 5,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter problem";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                                  "State the market opportunity or the probelem",
                              filled: true,
                              fillColor: AppColors.kcardColor,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.kFillColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: 145,
                                child: DropdownButtonFormField<String>(
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
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
                                  ),
                                  elevation: 20,
                                  onChanged: (String? value) {
                                    currentCategory = value!;
                                    print(currentCategory.toCategoryEnum());
                                    print(currentCategory);
                                  },
                                  items: selectedCategories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: buildText(
                                          text: value,
                                          color: Colors.white,
                                          txtSize: 12),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          buildText(text: "Explain it in your own way"),
                          const SizedBox(
                            height: 30,
                          ),
                          (path == "")
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        isRecording == false
                                            ? startRecording()
                                            : stopRecording();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Icon(
                                            isRecording == false
                                                ? Icons.mic
                                                : Icons.pause,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    isRecording == false
                                        ? Row(
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth /
                                                    1.82,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                    color: AppColors.kFillColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                  color: AppColors.kFillColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Expanded(
                                            child: AudioWaveforms(
                                              size: Size(
                                                  SizeConfig.screenWidth * 0.6,
                                                  50),
                                              recorderController:
                                                  recorderController,
                                              enableGesture: true,
                                              waveStyle: const WaveStyle(
                                                waveColor: Colors.white,
                                                extendWaveform: true,
                                                showMiddleLine: false,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color: const Color(0xFF1E1B26),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  left: 18),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                            ),
                                          ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPlaying = !isPlaying;
                                          _playAndPause();
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: (widget.path.isNotEmpty
                                                ? isPlaying
                                                : !isPlaying)
                                            ? const Center(
                                                child: Icon(
                                                  Icons.pause,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : const Center(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AudioFileWaveforms(
                                      waveformType: WaveformType.long,
                                      size: Size(
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                          50),
                                      playerController: playerController,
                                      animationDuration:
                                          const Duration(minutes: 2),
                                      enableSeekGesture: false,
                                      playerWaveStyle: const PlayerWaveStyle(
                                        fixedWaveColor: Colors.white30,
                                        liveWaveColor: Colors.white,
                                        waveCap: StrokeCap.round,
                                        scaleFactor: 200,
                                        showSeekLine: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          playerController.dispose();
                                          path = "";
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: AppColors.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
