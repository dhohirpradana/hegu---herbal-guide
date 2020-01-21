import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Resep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FlareActor("lib/assets/book.flr", animation: "Untitled",),
    );
  }
}
