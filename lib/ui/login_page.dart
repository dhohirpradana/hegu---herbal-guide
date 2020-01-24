import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hegu/api/api.dart';
import 'package:hegu/ui/halaman_utama.dart';
import 'package:hegu/ui/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  Color colorAppBar = Colors.green[700];

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  FocusNode focus;
  FocusNode toSubmit;
  String password;
  String email;
  bool _secure = true;
  LoginStatus _loginStatus = LoginStatus.notSignIn;

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
      print("$email, $password");
      login();
    }
  }

  @override
  void initState() {
    super.initState();
    // focus = FocusNode();
    getPref();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    focus.dispose();
    super.dispose();
  }

  login() async {
    final response = await http
        .post(BaseUrl.login, body: {"username": email, "password": password});
    final data = jsonDecode(response.body);
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
                    margin: EdgeInsets.all(10),
                    child: new CircularProgressIndicator()),
                new Text("Tunggu..."),
              ],
            ),
          );
        },
      );
      final result = await InternetAddress.lookup('google.com');
      new Future.delayed(new Duration(seconds: 2), () {
        Navigator.pop(context);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          int value = data['value'];
          String levelUser = data['levelUser'];
          String foto = data['foto'];
          String usernameAPI = data['username'];
          String namaAPI = data['nama'];
          String pesan = data['message'];
          String id = data['id'];
          if (value == 1) {
            if (levelUser == "1" || levelUser == "2" || levelUser == "3") {
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
                isDismissible: false,
                icon: Icon(
                  Icons.near_me,
                  color: Colors.white,
                ),
                // showProgressIndicator: true,
                // progressIndicatorBackgroundColor: Colors.blueGrey,
                barBlur: 0.0,
                message: "Sedang masuk...",
                backgroundColor: Colors.black87,
                duration: Duration(seconds: 1),
              )..show(context);
              print(usernameAPI);
              print(namaAPI);
              print(levelUser);
              print(foto);
              print(id);
              // print("Tidak ada koneksi");
              var duration = const Duration(seconds: 3);
              return Timer(duration, () {
                print(pesan);
                setState(() {
                  _loginStatus = LoginStatus.signIn;
                  savePref(value, usernameAPI, namaAPI, levelUser, foto, id);
                });
              });
            } else {
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
                icon: Icon(Icons.check_circle, color: Colors.red[700]),
                barBlur: 0.0,
                message: "Akun anda belum diverifikasi\n$email = level 0",
                backgroundColor: Colors.red[300],
                duration: Duration(seconds: 3),
              )..show(context);
              // print("Tidak ada koneksi");
              print(pesan);
              print("Akun anda belum diverifikasi\n$email = level 0");
            }
          } else if (value == 0) {
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
              icon: Icon(
                Icons.alternate_email,
                color: Colors.amber,
              ),
              barBlur: 0.0,
              message: "Email atau password salah",
              backgroundColor: Colors.red[300],
              duration: Duration(seconds: 3),
            )..show(context);
            // print("Tidak ada koneksi");
            print(pesan);
            print("Email atau password salah");
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
        // showProgressIndicator: true,
        // progressIndicatorBackgroundColor: Colors.blueGrey,
        barBlur: 0.0,
        message: "Tidak ada koneksi internet",
        backgroundColor: Colors.black87,
        duration: Duration(seconds: 2),
      )..show(context);
      print("Tidak ada koneksi");
    }
  }

  signOut() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      preference.setInt("value", null);
      _loginStatus = LoginStatus.notSignIn;
      preference.commit();
    });
  }

  savePref(int value, String username, String nama, String level, String foto,
      String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("level", level);
      preferences.setString("username", username);
      preferences.setString("nama", nama);
      preferences.setString("foto", foto);
      preferences.setString("id", id);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  Future showFlushBar(Flushbar instance, BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: WillPopScope(
            onWillPop: onWillPop,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 1.3 / 5),
                    height: MediaQuery.of(context).size.height,
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
                                // Padding(
                                //   padding: EdgeInsets.only(top: 180),
                                // ),
                                Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 4,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                  padding: EdgeInsets.only(top: 20),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 4,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: TextFormField(
                                      validator: (e) {
                                        if (e.isEmpty) {
                                          return "    Masukan Password";
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
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "Lupa Password?",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red[600],
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 50),
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          "Login",
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
                                      "Belum punya akun?",
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
                                                builder: (context) =>
                                                    RegisterPage()));
                                      },
                                      child: Text(
                                        " Daftar",
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
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(80)),
                  elevation: 3,
                  shadowColor: Colors.green,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1.3 / 5,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(80))),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Material(
                            color: Colors.grey[200],
                            borderRadius: BorderRadiusDirectional.circular(40),
                            elevation: 4,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadiusDirectional.circular(40)),
                              child: Icon(
                                Icons.people,
                                color: Colors.green,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment(1, 1),
                            child: Container(
                                margin: EdgeInsets.only(right: 30, bottom: 30),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                )))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return HalamanUtama(signOut);
        break;
    }
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
