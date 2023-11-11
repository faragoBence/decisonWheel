import 'package:decision_wheel/screens/createwheel.dart';
import 'package:decision_wheel/screens/wheelscreen.dart';
import 'package:flutter/material.dart';

import '../models/wheel.dart';
import '../screens/imageselector.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case 'wheel':
        Wheel wheel = args as Wheel;
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => WheelScreen(wheel: wheel),
        );
      case 'create_wheel':
        Wheel wheel = args as Wheel;
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => CreateWheel(wheel: wheel),
        );
      case 'image_select':
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => ImageSelector(),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
