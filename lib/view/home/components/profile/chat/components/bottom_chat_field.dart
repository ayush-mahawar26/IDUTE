import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/home/components/profile/chat/components/display_chat_compnents.dart';
import 'package:idute_app/view/home/components/profile/chat/components/pick_files_from_gallery.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../components/constants/size_config.dart';
import '../../../../../../components/enums/message_enum.dart';
import '../../../../../../components/provider/message_reply_provider.dart';
import '../controllers/chat_controller.dart';
import '../repositories/chat_repository.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserName;
  final String recieverUserId;
  final bool isGroupChat;

  const BottomChatField({
    super.key,
    required this.recieverUserId,
    required this.receiverUserName,
    required this.isGroupChat,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isShowFileContainer = false;
  FocusNode focusNode = FocusNode();
  late final RecorderController recorderController;
  late final PlayerController playerController;
  String path = "";
  bool isRecording = false;
  bool isPlaying = false;

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    _initialiseController();
    playerController = PlayerController();
    playerController.preparePlayer(path: path);
    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      await recorderController.record();
      setState(() {
        isRecording = true;
        isShowSendButton = false;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context: context,
        content: "Probelem in Recording",
      );
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
        isShowSendButton = true;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }

  void _playAndPause() async {
    (isPlaying)
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }

  void sendTextMessage() async {
    if (isShowSendButton && path != "") {
      sendFileMessage(file: File(path), messageEnum: MessageEnum.audio);

      setState(() {
        path = "";
        isShowSendButton = false;
        isShowFileContainer = false;
        playerController.dispose();
      });
    } else if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text.trim(),
            recieverUserId: widget.recieverUserId,
            isGroupChat: widget.isGroupChat,
          );
      // ref.read(chatControllerProvider).setUnreadMessage(
      //       context,
      //       widget.recieverUserId,
      //     );
      setState(() {
        isShowSendButton = false;
      });
      _messageController.text = '';
    } else {
      isRecording == false ? startRecording() : stopRecording();
    }
  }

  Future<File?> openCamera(BuildContext context) async {
    File? image;
    try {
      final clickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (clickedImage != null) {
        image = File(clickedImage.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return image;
  }

  void sendFileMessage({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          recieverUserId: widget.recieverUserId,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
    // ref.read(chatControllerProvider).setUnreadMessage(
    //       context,
    //       widget.recieverUserId,
    //     );
  }

  void selectFromCamera() async {
    File? image = await openCamera(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? image = await pickVideoFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.video);
    }
  }

  // void selectGIF() async {
  //   final gif = await pickGif(context);
  //   if (gif != null) {
  //     // ignore: use_build_context_synchronously
  //     ref.read(chatControllerProvider).sendGIFMessage(
  //           context: context,
  //           gifUrl: gif.url,
  //           recieverUserId: widget.recieverUserId,
  //           isGroupChat: widget.isGroupChat,
  //         );
  //   }
  // }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      hideKeyboard();
      FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        },
      );
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(7),
        vertical: getProportionateScreenHeight(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              !isRecording && path == ""
                  ? _buildTextField(isShowMessageReply, isShowFileContainer)
                  : _buildRecordingField(),
              IconButton(
                onPressed: sendTextMessage,
                icon: Icon(
                  isShowSendButton
                      ? Icons.send
                      : isRecording
                          ? Icons.pause_circle_outline_rounded
                          : Icons.mic_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          buildSizeHeight(height: 5),
          _buildEmojiWidget(),
        ],
      ),
    );
  }

  Widget _buildEmojiWidget() {
    return Visibility(
      visible: isShowEmojiContainer,
      child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                height: getProportionateScreenHeight(310),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: EmojiPicker(
                    onEmojiSelected: ((category, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                      });

                      if (!isShowSendButton) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    }),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }

  Expanded _buildRecordingField() {
    return Expanded(
      child: Material(
        elevation: 0,
        color: const Color(0xff292929),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xff4d4d4d),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            !isRecording
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        _playAndPause();
                      });
                    },
                    icon: !isPlaying
                        ? const Icon(
                            Icons.pause,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                  )
                : const SizedBox(),
            Expanded(
              child: path == ""
                  ? AudioWaveforms(
                      size: const Size(500, 30),
                      recorderController: recorderController,
                      enableGesture: true,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff292929),
                      ),
                      padding: const EdgeInsets.all(9),
                    )
                  : AudioFileWaveforms(
                      waveformType: WaveformType.long,
                      size: const Size(500, 30),
                      playerController: playerController,
                      animationDuration: const Duration(minutes: 2),
                      enableSeekGesture: false,
                      playerWaveStyle: const PlayerWaveStyle(
                        fixedWaveColor: Colors.white30,
                        liveWaveColor: Colors.white,
                        waveCap: StrokeCap.round,
                        showSeekLine: false,
                      ),
                    ),
            ),
            !isRecording
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        playerController.dispose();
                        path = "";
                        isShowSendButton = false;
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(bool isShowMessageReply, bool isShowFileContainer) {
    final messageReply = ref.watch(messageReplyProvider);

    return Expanded(
      child: Container(
        height: isShowMessageReply
            ? isShowFileContainer
                ? getProportionateScreenHeight(210)
                : getProportionateScreenHeight(110)
            : null,
        decoration: BoxDecoration(
          color: const Color(0xff292929),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            isShowMessageReply
                ? buildSizeHeight(height: 5)
                : const SizedBox.shrink(),
            isShowMessageReply
                ? _buildReplyWidget(messageReply, isShowMessageReply)
                : const SizedBox.shrink(),
            isShowMessageReply
                ? buildSizeHeight(height: 5)
                : const SizedBox.shrink(),
            Material(
              elevation: 0,
              color: const Color(0xff292929),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: _messageController,
                focusNode: focusNode,
                autofocus: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                onTap: () {
                  setState(() {
                    isShowEmojiContainer = false;
                  });
                },
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: _buildInputDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildReplyWidget(
      MessageReply? messageReply, bool isShowMessageReply) {
    return Expanded(
      child: Row(
        children: [
          buildSizeWidth(width: 11),
          SizedBox(
            width: getProportionateScreenWidth(240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSizeHeight(height: 1),
                Expanded(
                  child: buildText(
                      text:
                          messageReply!.isMe ? "You" : widget.receiverUserName,
                      color: Colors.cyan),
                ),
                DisplayTextImageGIF(
                  message: messageReply.message,
                  type: messageReply.messageEnum,
                  isReply: true,
                ),
                buildSizeHeight(height: 1),
              ],
            ),
          ),
          const Spacer(),
          messageReply.messageEnum == MessageEnum.image
              ? Stack(
                  children: [
                    Image.network(
                      messageReply.message,
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => cancelReply(ref),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () => cancelReply(ref),
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                ),
          isShowMessageReply
              ? buildSizeWidth(width: 3)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Container _buildCircularCont(
    Color color,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }

  _buildFileContainer() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(
            seconds: 2,
          ),
          curve: Curves.linear,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff292929),
          ),
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularCont(
                Colors.cyan,
                () {
                  selectFromCamera();
                },
                Icons.camera_alt,
              ),
              _buildCircularCont(
                Colors.redAccent,
                () {
                  selectImage();
                },
                Icons.image,
              ),
              _buildCircularCont(
                Colors.deepOrangeAccent,
                () {
                  selectVideo();
                },
                Icons.video_camera_back,
              ),
              _buildCircularCont(
                Colors.purpleAccent,
                () {},
                Icons.headphones_rounded,
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      prefixIcon: IconButton(
        onPressed: _buildFileContainer
        // () {
        //   // setState(() {
        //   //   isShowFileContainer = !isShowFileContainer;
        //   // });
        // }
        ,
        icon: const Icon(
          Icons.attach_file,
          color: Colors.white,
        ),
      ),
      suffixIcon: IconButton(
        onPressed: toggleEmojiKeyboardContainer,
        icon: const Icon(
          Icons.emoji_emotions_outlined,
          color: Colors.white,
        ),
      ),
      hintText: 'Message.....',
      hintStyle: const TextStyle(color: Color(0xFF818181)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          getProportionateScreenWidth(20),
        ),
        borderSide: const BorderSide(
          color: Color(0xff4d4d4d),
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          getProportionateScreenWidth(20),
        ),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xff4d4d4d),
        ),
      ),
      contentPadding: const EdgeInsets.all(10),
    );
  }
}
