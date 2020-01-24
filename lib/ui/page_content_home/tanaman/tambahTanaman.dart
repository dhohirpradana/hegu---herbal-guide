import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hegu/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:async/async.dart';

class TambahTanaman extends StatefulWidget {
  @override
  _TambahTanamanState createState() => _TambahTanamanState();
}

class _TambahTanamanState extends State<TambahTanaman> {
  String namaHerbal, deskripsi;
  final txtNamaHerbal = TextEditingController();
  final txtDeskripsi = TextEditingController();

  final _key = new GlobalKey<FormState>();

  String createdBy = "12";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      createdBy = preferences.getString("id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit(_image);
    }
  }

  File _image;
  Future getImageGallery() async {
    Random rand = new Random();
    int random = rand.nextInt(1000000) + 1000;

    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final title = random.toString();

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1000);

    var compressImage = await File("$path/FromGallery_$title.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImage;
    });
  }

  Future getImageCamera() async {
    Random rand = new Random();
    int random = rand.nextInt(1000000) + 1000;

    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final title = random.toString();

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1000);

    var compressImage = await File("$path/FromCamera_$title.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImage;
    });
  }

  Future submit(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(BaseUrl.tambahProduk);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("foto", stream, length,
        filename: path.basename(imageFile.path));

    request.fields['namaHerbal'] = txtNamaHerbal.text;
    request.fields['deskripsi'] = txtDeskripsi.text;
    request.fields['createdBy'] = createdBy;
    request.files.add(multipartFile);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: EdgeInsets.all(5),
                    child: new CircularProgressIndicator()),
                new Text("Tunggu..."),
              ],
            ),
          );
        },
      );
      var response = await request.send();
      final result = await InternetAddress.lookup('google.com');
      new Future.delayed(new Duration(seconds: 3), () {
        Navigator.pop(context);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (response.statusCode == 200) {
            setState(() {
              txtNamaHerbal.text = "";
              txtDeskripsi.text = "";
              _image = null;
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                boxShadows: [
                  BoxShadow(
                      color: Colors.grey[800],
                      offset: Offset(0.0, 2.0),
                      blurRadius: 3.0)
                ],
                backgroundGradient: LinearGradient(
                    colors: [Colors.blueGrey[600], Colors.black54]),
                isDismissible: false,
                icon: Icon(Icons.check, color: Colors.blue[600]),
                barBlur: 0.0,
                message: "Data berhasil ditambah",
                backgroundColor: Colors.red[300],
                duration: Duration(seconds: 1),
              )..show(context);
            });
            print("Register Berhasil");
          } else {
            Navigator.pop(context);
            print("Gagal tambah data");
          }
        }
      });
    } on SocketException catch (_) {
      Flushbar(
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        boxShadows: [
          BoxShadow(
              color: Colors.grey[800],
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0)
        ],
        backgroundGradient:
            LinearGradient(colors: [Colors.blueGrey[300], Colors.black87]),
        isDismissible: false,
        icon: Icon(
          Icons.signal_cellular_off,
          color: Colors.red,
        ),
        barBlur: 0.0,
        message: "Tidak ada koneksi internet",
        backgroundColor: Colors.black87,
        duration: Duration(seconds: 2),
      )..show(context);
      print("Tidak ada koneksi");
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Tambah data Tanaman"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 2.5),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                            icon: Icon(Icons.image),
                            onPressed: getImageGallery,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.5),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: getImageCamera,
                          ),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: _image == null
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 43, bottom: 43, left: 35, right: 35),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey.withOpacity(0.4)),
                            child: Text("Tidak ada gambar yang dipilih"),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 3, bottom: 3, left: 80, right: 80),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.grey.withOpacity(0.4)),
                                child: Material(
                                  elevation: 3,
                                  child: Image.file(
                                    _image,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            TextFormField(
              autofocus: true,
              controller: txtNamaHerbal,
              decoration: InputDecoration(labelText: "Nama tanaman"),
              validator: (e) {
                if (e.isEmpty) {
                  return "Masukan nama tanaman";
                }
              },
              onSaved: (e) => namaHerbal = e,
            ),
            TextFormField(
              controller: txtDeskripsi,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration:
                  InputDecoration(labelText: "Deskripsi", hintText: "Optional"),
              validator: (e) {
                if (e.isEmpty) {
                  e = txtNamaHerbal.text;
                }
              },
              onSaved: (e) => deskripsi = e,
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              color: Colors.green[700],
              child: Text(
                "SIMPAN",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
