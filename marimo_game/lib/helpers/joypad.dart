

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import '../const/constant.dart';
import 'direction.dart';

class Joypad extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const Joypad({Key? key, this.onDirectionChanged}) : super(key: key);

  @override
  JoypadState createState() => JoypadState();
}

class JoypadState extends State<Joypad> {
  Direction direction = Direction.none;
  Offset delta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          //Image.asset("assets/images/joystick_front.png"),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // SizedBox(
            //   height: 120,
            //   width: 120,
            //   child: Image.asset("assets/images/joystick_back.png"),
            // ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0x88ffffff),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Icon(Icons.keyboard_arrow_left,size: 30,color:Colors.black87),
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Icon(Icons.keyboard_arrow_right,size: 30,color:Colors.black87),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Icon(Icons.keyboard_arrow_up,size: 30,color:Colors.black87),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Icon(Icons.keyboard_arrow_down,size: 30,color:Colors.black87),
                    )),
              ]
            ),
            GestureDetector(
              onPanDown: onDragDown,
              onPanUpdate: onDragUpdate,
              onPanEnd: onDragEnd,
              child: Container(
                // decoration: BoxDecoration(
                //   color: const Color(0x88ffffff),
                //   borderRadius: BorderRadius.circular(60),
                // ),
                child: Center(
                  child: Transform.translate(
                    offset: delta,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.asset("${CommonConstant.assetsImageMain}joystick_front.png",),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateDelta(Offset newDelta) {
    final newDirection = getDirectionFromOffset(newDelta);

    if (newDirection != direction) {
      direction = newDirection;
      widget.onDirectionChanged!(direction);
    }

    setState(() {
      delta = newDelta;
    });
  }

  Direction getDirectionFromOffset(Offset offset) {
    if (offset.dx > 20) {
      return Direction.right;
    } else if (offset.dx < -20) {
      return Direction.left;
    } else if (offset.dy > 20) {
      return Direction.down;
    } else if (offset.dy < -20) {
      return Direction.up;
    }
    return Direction.none;
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }

  void calculateDelta(Offset offset) {
    final newDelta = offset - const Offset(60, 60);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }
}
