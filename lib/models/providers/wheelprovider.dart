import 'package:decision_wheel/models/wheel.dart';
import 'package:flutter/material.dart';

class WheelProvider extends ChangeNotifier {
  Wheel _wheel = Wheel.createEmpty();

  Wheel get wheel => _wheel;

  update(Wheel wheel) {
    _wheel = wheel;
    notifyListeners();
  }

  reset() {
    _wheel = Wheel.createEmpty();
  }
}
