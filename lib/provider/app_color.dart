import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApplicationColor with ChangeNotifier {
  bool _isNight;

  bool get isNight => _isNight;
  set isNight(bool value) {
    _isNight = value;
    notifyListeners();
  }

  Color get color => (_isNight) ? Colors.black26 : Colors.white;
}
