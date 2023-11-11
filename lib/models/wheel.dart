import 'package:decision_wheel/models/wheel_element.dart';

import '../services/wheelservice.dart';
import 'package:hive/hive.dart';

part 'wheel.g.dart';

@HiveType(typeId: 0)
class Wheel {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  @HiveField(2)
  List<WheelElement> wheelElements;

  @HiveField(3)
  int imageIndex;

  Wheel({
    required this.name,
    required this.wheelElements,
    required this.imageIndex,
    required this.id,
  });

  String getImagePath() {
    return WheelService.instance.getSelectableImages()[imageIndex];
  }

  static Wheel createEmpty() {
    return new Wheel(
        id: 0,
        name: '',
        wheelElements: List.empty(growable: true),
        imageIndex: 0);
  }

  Wheel clone() {
    List<WheelElement> clonedElements = List.empty(growable: true);

    for (WheelElement element in wheelElements) {
      clonedElements.add(element.clone());
    }
    return new Wheel(
      name: name,
      wheelElements: clonedElements,
      imageIndex: imageIndex,
      id: id,
    );
  }
}
