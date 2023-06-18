import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../components/button/common_button.dart';
class IntroPage extends StatefulWidget {
  final VideoPlayerController controller;
  IntroPage({super.key, required this.controller}){
    controller.play();
  }

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize().then((value) => {
            widget.controller.addListener(() {
              setState(() {
                if (!widget.controller.value.isPlaying &&
                    widget.controller.value.isInitialized &&
                    (widget.controller.value.duration ==
                        widget.controller.value.position)) {
                  setState(() {
                    Navigator.pushNamed(context, "/init_setting");
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
            child: widget.controller.value.isInitialized
                ? VideoPlayer(widget.controller)
                : Container(),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 25,
          child: CommonButton(
          width: 70,
          imageName: 'skip',
          onTap: () =>   Navigator.pushNamed(context, "/init_setting"),
          ),
        ),
      ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
