import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/view/home/components/profile/chat/components/video_player_item.dart';

import '../../../../../../components/enums/message_enum.dart';
import '../../../../../../components/widgets/normal_text_widget.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isReply;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
    this.isReply = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? buildText(
            text: message,
            txtSize: 15,
            maxLine: isReply ? 1 : 30,
            overflow: TextOverflow.ellipsis,
          )
        : type == MessageEnum.audio
            ? isReply
                ? buildText(text: "Voice Message")
                : StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 100,
                      ),
                      iconSize: 30,
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          await audioPlayer.play(UrlSource(message));
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: Colors.white,
                      ),
                    );
                  })
            : type == MessageEnum.video
                ? isReply
                    ? buildText(text: "Video")
                    : VideoPlayerItem(
                        videoUrl: message,
                      )
                : type == MessageEnum.gif
                    ? isReply
                        ? buildText(text: "GIF")
                        : CachedNetworkImage(
                            imageUrl: message,
                          )
                    : isReply
                        ? buildText(text: "Image")
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 300,
                              maxWidth: 300,
                              minHeight: 100,
                              minWidth: 200,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: message,
                              fit: BoxFit.cover,
                            ),
                          );
  }
}
