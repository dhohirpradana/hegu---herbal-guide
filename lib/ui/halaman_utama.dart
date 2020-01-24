import 'package:cached_network_image/cached_network_image.dart';
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

  String username = "", namanya = "", nama = "", foto = "", level = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      foto = preferences.getString("foto");
      username = preferences.getString("username");
      namanya = preferences.getString("nama");
      level = preferences.getString("level");
    });
    nama = (level == "3")
        ? "$namanya (admin)"
        : (level == "2") ? "$namanya (dokter)" : nama = "$namanya (>__<)";
    print("nama: $nama");
  }

  @override
  void initState() {
    super.initState();
    isLogout = false;
    getPref();
  }

  bool isLogout = false;

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
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                AlertDialog(
                                  content: Column(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                1 /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1 /
                                                2,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 5, 10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://hegumk.000webhostapp.com/image/$foto',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.grey,
                                                            BlendMode
                                                                .colorBurn))),
                                          ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Text(
                                        nama,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Tutup",
                                                style: TextStyle(
                                                    color: Colors.red[400],
                                                    fontSize: 16))),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              signOut();
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        SizedBox(
                                          width: 25,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                      child: CachedNetworkImage(
                        imageUrl: 'http://hegumk.000webhostapp.com/image/$foto',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey, BlendMode.colorBurn))),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
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
          color: Colors.white,
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
          child: Container(color: color, child: Center(child: halaman)),
        ));
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
