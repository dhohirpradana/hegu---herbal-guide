import 'package:flutter/material.dart';
import 'package:hegu/ui/page_content_home/dokter_page.dart';
import 'package:hegu/ui/page_content_home/map.dart';
import 'package:hegu/ui/page_content_home/resep_page.dart';
import 'package:hegu/ui/page_content_home/tanaman_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanUtama extends StatefulWidget {
  final VoidCallback signOut;
  HalamanUtama(this.signOut);

  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", nama = "", foto = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      foto = preferences.getString("foto");
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  DateTime backbuttonpressedTime;
  Widget halaman = Tanaman();
  int _page = 0;
  Color colorNavBar = Colors.white70;
  Color color = Colors.green[100];
  Color colorAppBar = Colors.green[700];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          'http://hegumk.000webhostapp.com/image/$foto'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  // Text(
                  //   "$nama",
                  //   style: TextStyle(fontSize: 13),
                  // ),

                  // //
                  // Row(
                  //   children: <Widget>[
                  //     Text("(", style: TextStyle(fontSize: 12)),
                  //     InkWell(
                  //       onTap: () {
                  //         signOut();
                  //       },
                  //       child: Text("Keluar",
                  //           style: TextStyle(
                  //             fontSize: 13,
                  //             color: Colors.red,
                  //           )),
                  //     ),
                  //     Text(")", style: TextStyle(fontSize: 12)),
                  //   ],
                  // )
                ],
              ),
            )
          ],
          backgroundColor: colorAppBar,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 7, right: 3),
                    child: Image.asset(
                      "lib/assets/images/plant.png",
                      width: 30,
                    ),
                  ),
                  Text(
                    "HeGu",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    " Herbal Guide",
                    style: TextStyle(fontFamily: "Sofia", fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: colorNavBar,
          backgroundColor: color,
          items: <Widget>[
            Image.asset(
              "lib/assets/images/leaf.png",
              width: 30,
            ),
            Image.asset(
              "lib/assets/images/medicine.png",
              width: 30,
            ),
            Image.asset(
              "lib/assets/images/doctor(1).png",
              width: 30,
            ),
            Image.asset(
              "lib/assets/images/map.png",
              width: 30,
            ),
          ],
          onTap: (index) {
            //Handle button tap
            setState(() {
              _page = index;
              (_page == 0)
                  ? halaman = Tanaman()
                  : (_page == 1)
                      ? halaman = Resep()
                      : (_page == 2) ? halaman = Dokter() : halaman = MapPage();
            });
          },
        ),
        body: WillPopScope(
            onWillPop: onWillPop,
            child: Container(color: color, child: Center(child: halaman))));
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Ketuk lagi untuk keluar",
          backgroundColor: Colors.black87,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
