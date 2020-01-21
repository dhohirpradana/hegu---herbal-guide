import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Dokter extends StatefulWidget {
  @override
  _DokterState createState() => _DokterState();
}

class _DokterState extends State<Dokter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int mauice = 0;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: SizedBox(
          height: 300,
          child: GestureDetector(
            onTap: () {
              if (mauice == 0) {
                setState(() {
                  mauice = mauice + 1;
                });
              } else if (mauice == 11) {
                setState(() {
                  mauice = mauice - 1;
                });
              }
            },
            child: FlareActor(
              "lib/assets/Maurice.flr",
              animation: (mauice == 0)
                  ? "idle"
                  : (mauice == 1)
                      ? "left_eye_wink_eyebrow"
                      : (mauice == 2)
                          ? "right_eye_wink_eyebrow"
                          : (mauice == 3)
                              ? "smile"
                              : (mauice == 4)
                                  ? "left_eye_wink"
                                  : (mauice == 5)
                                      ? "right_eye_wink"
                                      : (mauice == 6)
                                          ? "look_down"
                                          : (mauice == 7)
                                              ? "look_right"
                                              : (mauice == 8)
                                                  ? "z_axis_right"
                                                  : (mauice == 9)
                                                      ? "z_axis_left"
                                                      : (mauice == 10)
                                                          ? "look_left"
                                                          : "look_up",
              callback: (aN) {
                if (aN == "idle") {
                  setState(() {
                    aN = "smile";
                  });
                }
              },
            ),
          )),
    );
  }
}
