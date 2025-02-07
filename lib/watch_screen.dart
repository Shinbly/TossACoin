import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return mode == WearMode.active
                ? ActiveWatchFace()
                : AmbientWatchFace();
          },
        );
      },
    );
  }
}

class ActiveWatchFace extends StatefulWidget {
  const ActiveWatchFace({Key? key}) : super(key: key);

  @override
  State<ActiveWatchFace> createState() => _ActiveWatchFaceState();
}

class _ActiveWatchFaceState extends State<ActiveWatchFace> {
  bool isFace = true;

  double verticalDrag = 0;
  double scale = 0;

  void pileouFace() {
    if (math.Random().nextBool()) {
      setFlip(360);
    } else {
      setFlip(540);
    }
  }

  Future setFlip(int rotation) async {
    for (int i = 0; i < 25; i++) {
      setState(() {
        scale += 2;
      });
      await Future.delayed(Duration(milliseconds: 1));
    }
    int nbTour = (rotation / 180).round();
    for (int i = 0; i < nbTour * 50; i++) {
      setState(() {
        verticalDrag += rotation / (nbTour * 50);
        verticalDrag %= 360;
        isFace = verticalDrag < 90 || verticalDrag > 270;
      });
      await Future.delayed(Duration(milliseconds: 2));
    }
    for (int i = 0; i < 10; i++) {
      setState(() {
        scale -= 5;
      });
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxSquareside =
        math.sqrt(math.pow((MediaQuery.of(context).size.width.round()), 2) / 2);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              pileouFace();
            },
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(2, 2, 001)
                ..rotateX(verticalDrag / 180 * math.pi),
              alignment: Alignment.center,
              child: Container(
                  //size of the greaterst square in a cirche of diameter width (not heigh because of round chin wear)
                  height: maxSquareside - scale,
                  width: maxSquareside - scale,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(maxSquareside)),
                    color: Colors.blueGrey,
                    border: Border.all(
                        color: Colors.white,
                        width: (maxSquareside - scale) / 10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(isFace ? Icons.face : Icons.euro,
                      color: Colors.white,
                      size: (math
                          .sqrt(math.pow((maxSquareside - scale), 2) / 2)))),
            ),
          ),
          SizedBox(
            height: scale,
            width: maxSquareside,
          ),
        ],
      ),
    );
  }
}

class AmbientWatchFace extends StatelessWidget {
  const AmbientWatchFace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ambient"),
    );
  }
}
