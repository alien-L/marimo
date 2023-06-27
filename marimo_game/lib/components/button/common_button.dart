import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/sound_bloc.dart';

class CommonButton extends StatelessWidget {
  CommonButton(
      {Key? key,
      this.width,
      this.height,
      required this.imageName,
      this.onTap,
      this.haveMessage = false,
      this.buttonName,
      this.textStyle
      })
      : super(key: key);
  final double? width;
  final double? height;
  final String imageName;
  final controller = StreamController<bool>.broadcast();
  final GestureTapCallback? onTap;
  final bool haveMessage;
  final String? buttonName;
  final TextStyle? textStyle;

  Widget buttonWidget() {
    return StreamBuilder<bool>(
        stream: controller.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          } else {
            return Listener(
              onPointerDown: (details) => controller.add(true),
              onPointerUp: (event) => controller.add(false),
              child: GestureDetector(
                onTap: onTap,
                child: Center(
                  child: haveMessage
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              child: SizedBox(
                                width: width,
                                height: height,
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage(snapshot.requireData
                                      ? "assets/images/buttons/${imageName}_on.png"
                                      : "assets/images/buttons/${imageName}_off.png",),
                                  width: width,
                                  height: height,
                                ),
                              ),
                            ),
                            Positioned(child: Text(buttonName??"",style: textStyle,)),
                          ],
                        )
                      : Image(
                          fit: BoxFit.fill,
                          image: AssetImage(snapshot.requireData
                              ? "assets/images/buttons/${imageName}_on.png"
                              : "assets/images/buttons/${imageName}_off.png"),
                          width: width,
                          height: height,
                        ),
                ),
              ),
            );
          }
        });
  }

  Widget buttonWidget1() {
    return StreamBuilder<bool>(
        stream: controller.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          } else {
            return BlocBuilder<SoundBloc, bool>(builder: (context, state) {
              // return widget here based on BlocA's state
              return Listener(
                onPointerDown: (details) => controller.add(true),
                onPointerUp: (event) => controller.add(false),
                child: GestureDetector(
                  onTap: onTap,
                  child: Center(
                    child: state
                        ? Image(
                            fit: BoxFit.fill,
                            image: AssetImage(snapshot.requireData
                                ? "assets/images/buttons/music_on.png"
                                : "assets/images/buttons/music_off.png"),
                            width: width,
                            height: height,
                          )
                        : Image(
                            fit: BoxFit.fill,
                            image: AssetImage(snapshot.requireData
                                ? "assets/images/buttons/stop_on.png"
                                : "assets/images/buttons/stop_off.png"),
                            width: width,
                            height: height,
                          ),
                  ),
                ),
              );
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return buttonWidget();
  }
}

