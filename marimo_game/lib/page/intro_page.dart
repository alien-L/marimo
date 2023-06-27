import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../components/button/common_button.dart';
class IntroPage extends StatefulWidget {
  final VideoPlayerController videoController;
  IntroPage({super.key, required this.videoController}){
    videoController.play();
  }

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    widget.videoController.initialize().then((value) => {
            widget.videoController.addListener(() {
              setState(() {
                if (!widget.videoController.value.isPlaying &&
                    widget.videoController.value.isInitialized &&
                    (widget.videoController.value.duration ==
                        widget.videoController.value.position)) {
                  setState(() {
                     Navigator.pushNamed(context, "/init_setting");
                     widget.videoController.pause();
                  });
                }
              });
            })
          });
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children:[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: widget.videoController.value.isInitialized
                ? VideoPlayer(widget.videoController)
                : Container(),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 25,
          child: CommonButton(
          width: 70,
          imageName: 'skip',
          onTap: () {
            Navigator.pushNamed(context, "/init_setting");
             widget.videoController.pause();
             }
          ),
        ),
      ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoController.pause();
     widget.videoController.dispose();
  }
}
