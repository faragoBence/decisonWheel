import 'package:decision_wheel/models/wheel.dart';
import 'package:flutter/material.dart';

class WheelsProvider extends ChangeNotifier {
  List<Wheel> _wheels = List.empty(growable: true);

  List<Wheel> get wheels => _wheels;

  update(List<Wheel> wheels) {
    _wheels = wheels;
    notifyListeners();
  }

  reset() {
    _wheels = List.empty(growable: true);
  }
}
