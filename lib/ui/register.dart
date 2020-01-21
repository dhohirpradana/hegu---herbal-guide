import 'dart:async';
import 'dart:math';
import 'package:async/async.dart';
import 'package:hegu/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hegu/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

enum LoginStatus { notSignIn, signIn }

class _RegisterPage extends State<RegisterPage> {
  //Image Picker
  File _image;
  Future getImageGallery() async {
    Random rand = new Random();
    int random = rand.nextInt(1000000) + 1000;

    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final title = random.toString();

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 500);

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
    Img.Image smallerImg = Img.copyResize(image, width: 500);

    var compressImage = await File("$path/FromCamera_$title.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImage;
    });
  }

  //Before
  Color colorAppBar = Colors.green[700];

  TextEditingController txtNama = TextEditingController();
  TextEditingController txtNik = TextEditingController();
  TextEditingController txtTelp = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  FocusNode focus;
  FocusNode toSubmit;

  String telp;
  String nama;
  String nik;
  String password;
  String email;
  bool _secure = true;

  DateTime backbuttonpressedTime;

  showHide() {
    setState(() {
      _secure = !_secure;
    });
  }

  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("$nama,$nik,$email,$password");
      register(_image);
    }
  }

  Future register(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(BaseUrl.register);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("foto", stream, length,
        filename: path.basename(imageFile.path));

    request.fields['username'] = txtEmail.text;
    request.fields['password'] = txtPassword.text;
    request.fields['nama'] = txtNama.text;
    request.fields['nik'] = txtNik.text;
    request.fields['telp'] = txtTelp.text;
    request.files.add(multipartFile);

    try {
      var response = await request.send();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (response.statusCode == 200) {
          setState(() {
            txtNama.text = "";
            txtPassword.text = "";
            txtEmail.text = "";
            txtNik.text = "";
            txtTelp.text = "";
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
              message: "Registrasi berhasil",
              backgroundColor: Colors.red[300],
              duration: Duration(seconds: 3),
            )..show(context);
            var duration = const Duration(seconds: 2);
            return Timer(duration, () {
              setState(() {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
              print("Register Berhasil");
            });
          });
        } else {
          print("Gagal Register");
        }
      }
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
    focus = FocusNode();
  }

  @override
  void dispose() {
    txtNama.dispose();
    txtNik.dispose();
    txtTelp.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    focus.dispose();
    super.dispose();
  }

  Future showFlushBar(Flushbar instance, BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 10 / 100),
                color: Colors.green[100],
                child: Container(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 40, left: 40),
                      child: Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 2.5),
                                          child: Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                                                  top: 43,
                                                  bottom: 43,
                                                  left: 35,
                                                  right: 35),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              child: Text(
                                                  "Tidak ada gambar yang dipilih"),
                                            )
                                          : Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: 3,
                                                      bottom: 3,
                                                      left: 80,
                                                      right: 80),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      color: Colors.grey
                                                          .withOpacity(0.4)),
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "      Masukan Nama Lengkap";
                                    }
                                  },
                                  onSaved: (e) => nama = e,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus);
                                  },
                                  controller: txtNama,
                                  decoration: InputDecoration(
                                    hintText: "Nama Lengkap",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.green,
                                    ),
                                    labelStyle: TextStyle(fontSize: 20),
                                    hintStyle: TextStyle(fontSize: 16),
                                    fillColor: Colors.orange[300],
                                    border: InputBorder.none,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                child: TextFormField(
                                    maxLength: 16,
                                    keyboardType: TextInputType.number,
                                    validator: (e) {
                                      final isDigitsOnly = int.tryParse(e);
                                      if (e.isEmpty) {
                                        return "    Masukan NIK";
                                      } else if (isDigitsOnly == null) {
                                        return "    Input hanya boleh angka";
                                      } else if (e.length < 16) {
                                        return "    Masukan 16 digit angka";
                                      }
                                    },
                                    onSaved: (e) => nik = e,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    controller: txtNik,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Nomor Induk Kependudukan",
                                      prefixIcon: Icon(
                                        Icons.credit_card,
                                        color: Colors.green,
                                      ),
                                      labelStyle: TextStyle(fontSize: 20),
                                      hintStyle: TextStyle(fontSize: 16),
                                      fillColor: Colors.orange[300],
                                      border: InputBorder.none,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                child: TextFormField(
                                    maxLength: 15,
                                    keyboardType: TextInputType.number,
                                    validator: (e) {
                                      final isDigitsOnly = int.tryParse(e);
                                      if (e.isEmpty) {
                                        return "    Masukan Nomor HP";
                                      } else if (isDigitsOnly == null) {
                                        return "    Input hanya boleh angka";
                                      } else if (e.length < 10) {
                                        return "    Masukan nomor dengan valid";
                                      }
                                    },
                                    onSaved: (e) => telp = e,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    controller: txtTelp,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Nomor HP",
                                      prefixIcon: Icon(
                                        Icons.stay_primary_portrait,
                                        color: Colors.green,
                                      ),
                                      labelStyle: TextStyle(fontSize: 20),
                                      hintStyle: TextStyle(fontSize: 16),
                                      fillColor: Colors.orange[300],
                                      border: InputBorder.none,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),

                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "    Masukan email";
                                      }
                                    },
                                    onSaved: (e) => email = e,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    controller: txtEmail,
                                    // autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Colors.green,
                                      ),
                                      labelStyle: TextStyle(fontSize: 20),
                                      hintStyle: TextStyle(fontSize: 16),
                                      fillColor: Colors.orange[300],
                                      border: InputBorder.none,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "   Masukan Password";
                                    } else if (e.length < 6) {
                                      return "   Sandi harus memiliki minimal 6 karakter";
                                    }
                                  },
                                  onSaved: (e) => password = e,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(toSubmit);
                                  },
                                  // onSaved: (e) => password = e,
                                  focusNode: focus,
                                  controller: txtPassword,
                                  obscureText: _secure,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      color: _secure
                                          ? Colors.green
                                          : Colors.red[400],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.green,
                                    ),
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[],
                            // ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                            ),
                            Material(
                              shadowColor: Colors.tealAccent,
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                              elevation: 6,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.tealAccent,
                                focusNode: toSubmit,
                                onTap: () {
                                  check();
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      "Daftar",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Sudah punya akun?",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    " Masuk",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 12,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w900),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
              elevation: 3,
              shadowColor: Colors.green,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(40))),
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment(1, 1),
                        child: Container(
                            margin: EdgeInsets.only(right: 10, bottom: 8),
                            child: Text(
                              "DAFTAR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 30),
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Material(
                color: Colors.green[500],
                elevation: 2,
                borderRadius: BorderRadius.circular(25),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
