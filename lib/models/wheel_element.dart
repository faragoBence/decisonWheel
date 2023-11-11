import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'wheel_element.g.dart';

@HiveType(typeId: 1)
class WheelElement {
  @HiveField(0)
  String name;

  @HiveField(1)
  int colorValue;

  @HiveField(2)
  int id;

  WheelElement(
      {required this.name, required this.colorValue, required this.id}) {}

  static WheelElement createEmpty() {
    return new WheelElement(
      id: 0,
      name: '',
      colorValue: ColorService.getPrimaryColor().value,
    );
  }

  WheelElement clone() {
    return new WheelElement(name: name, colorValue: colorValue, id: id);
  }

  Color getColor() {
    return Color(colorValue);
  }
}
