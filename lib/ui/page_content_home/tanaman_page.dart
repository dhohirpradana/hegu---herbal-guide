import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Tanaman extends StatefulWidget {
  @override
  _TanamanState createState() => _TanamanState();
}

class _TanamanState extends State<Tanaman> {
  @override
  Widget build(BuildContext context) {
    int anim = 0;
    return Stack(
      children: <Widget>[
        Center(
          child: GestureDetector(
            onTap: () {
              if (anim == 0) {
                setState(() {
                  anim = 1;
                });
              } else {
                setState(() {
                  anim = 0;
                });
              }
            },
            child: SizedBox(
              height: 170,
              child: FlareActor(
                "lib/assets/plant.flr",
                animation: (anim == 0) ? "start" : "animation",
                callback: (aN) {
                  if (aN == "start") {
                    setState(() {
                      anim = 1;
                    });
                  } else {
                    setState(() {
                      anim = 0;
                    });
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
