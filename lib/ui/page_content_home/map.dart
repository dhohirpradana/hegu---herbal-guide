import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: FlareActor("lib/assets/map.flr",animation: "anim",),
    );
  }
}
