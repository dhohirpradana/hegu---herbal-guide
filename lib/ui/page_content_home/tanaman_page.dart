import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hegu/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:hegu/api/herbalModel.dart';
import 'package:hegu/ui/page_content_home/tanaman/tambahTanaman.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tanaman extends StatefulWidget {
  @override
  _TanamanState createState() => _TanamanState();
}

class _TanamanState extends State<Tanaman> {
  final list = new List<HerbalModel>();
  var loading = true;
  int page = 1;
  bool isLoading = false;

  _lihatData() async {
    list.clear();
    final response = await http.get(BaseUrl.lihatHerbal);
    if (response.contentLength == 2) {
    } else {
      await new Future.delayed(new Duration(seconds: 2));
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new HerbalModel(
            api['id'],
            api['namaHerbal'],
            api['deskripsi'],
            api['foto'],
            api['createdDate'],
            api['createdBy'],
            api['nama']);
        list.add(ab);
      });
      setState(() {
        page++;
        loading = false;
      });
    }
  }

  String level = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      level = preferences.getString("level");
    });
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
    getPref();
    // _onLoading();
  }

  List users = new List();

  @override
  Widget build(BuildContext context) {
    if (level == "3" || level == "2") {
      return Stack(
        children: <Widget>[
          // Column(
          //   children: <Widget>[
          //     NotificationListener<ScrollNotification>(
          //       onNotification: (ScrollNotification scrollInfo) {
          //         if (!isLoading &&
          //             scrollInfo.metrics.pixels ==
          //                 scrollInfo.metrics.maxScrollExtent) {
          //           _lihatData();
          //           // start loading data
          //           setState(() {
          //             isLoading = true;
          //           });
          //         }
          //       },
          //       child:
          ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                final nama = x.nama;
                final tanggal = x.createdDate;
                final foto = x.foto;
                return Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(x.namaHerbal),
                                        content: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2 /
                                              3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2 /
                                              3,
                                          imageUrl:
                                              'http://hegumk.000webhostapp.com/herbal/image/$foto',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2 /
                                                3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2 /
                                                3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                      );
                                    });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 11,
                                width: MediaQuery.of(context).size.height / 11,
                                margin: EdgeInsets.fromLTRB(0, 5, 10, 10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://hegumk.000webhostapp.com/herbal/image/$foto',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.colorBurn))),
                                  ),
                                  placeholder: (context, url) => Container(
                                      padding: EdgeInsets.all(15),
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      x.namaHerbal,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "by: $nama",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "$tanggal",
                                      style: TextStyle(color: Colors.red[700]),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.deskripsi,
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          //     ),
          //     Container(
          //       height: isLoading ? 50.0 : 0,
          //       color: Colors.transparent,
          //       child: Center(
          //         child: new CircularProgressIndicator(),
          //       ),
          //     ),
          //   ],
          // ),
          // ),
          // (level == "3" || level == "2")
          //     ?
          Align(
            alignment: Alignment(1, 1),
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 10, bottom: 10),
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 3,
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahTanaman()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 31,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          )
          // : () {},
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                final nama = x.nama;
                final tanggal = x.createdDate;
                final foto = x.foto;
                return Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(x.namaHerbal),
                                        content: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2 /
                                              3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2 /
                                              3,
                                          imageUrl:
                                              'http://hegumk.000webhostapp.com/herbal/image/$foto',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2 /
                                                3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2 /
                                                3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                      );
                                    });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 11,
                                width: MediaQuery.of(context).size.height / 11,
                                margin: EdgeInsets.fromLTRB(0, 5, 10, 10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://hegumk.000webhostapp.com/herbal/image/$foto',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.colorBurn))),
                                  ),
                                  placeholder: (context, url) => Container(
                                      padding: EdgeInsets.all(15),
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      x.namaHerbal,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "by: $nama",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "$tanggal",
                                      style: TextStyle(color: Colors.red[700]),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.deskripsi,
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      );
    }
  }
}
