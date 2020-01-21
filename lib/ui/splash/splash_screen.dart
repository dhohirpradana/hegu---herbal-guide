import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hegu/ui/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("HeGu",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Sofia",
                            fontSize: 50,
                            fontWeight: FontWeight.w900)),
                    Text(
                      "Herbal Guide",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Sofia",
                          fontSize: 40,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
    );
  }
}
