import 'package:decision_wheel/models/wheel_element.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../models/providers/wheelprovider.dart';
import '../models/providers/wheelsprovider.dart';
import '../models/wheel.dart';

class WheelService {
  WheelService._privateConstructor();

  static final WheelService instance = WheelService._privateConstructor();

  Future<bool> buildWheels(BuildContext context) async {
    List<Wheel> wheels = List.empty(growable: true);
    Hive.box('wheels').toMap().forEach((key, value) {
      wheels.add(value);
    });

    if (wheels.isEmpty) {
      wheels.add(await _createFoodWheel(context));
      wheels.add(await _createYesNoWheel(context));
    }

    await Provider.of<WheelsProvider>(context, listen: false).update(wheels);
    return true;
  }

  saveWheel(BuildContext context, Wheel wheel) async {
    if (wheel.id == 0) {
      int maxId = 0;
      Hive.box('wheels').toMap().forEach((key, value) {
        if (value.id > maxId) {
          maxId = value.id;
        }
      });
      wheel.id = maxId + 1;
    }
    await Hive.box('wheels').put(wheel.id.toString(), wheel);
    await buildWheels(context);
    await Provider.of<WheelProvider>(context, listen: false).update(wheel);
  }

  deleteWheel(BuildContext context, Wheel wheel) async {
    Hive.box('wheels').delete(wheel.id.toString());
    await buildWheels(context);
    await Provider.of<WheelProvider>(context, listen: false).reset();
  }

  showErrorSnackBar(BuildContext context, String key,
      {String? textBefore = ''}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text((textBefore ?? '') +
            (AppLocalizations.of(context)?.translate(key) ?? '')),
      ),
    );
  }

  Future<Wheel> _createFoodWheel(BuildContext context) async {
    List<WheelElement> wheelElements = List.empty(growable: true);

    wheelElements.add(
      WheelElement(colorValue: Colors.red.value, name: 'Pizza', id: 1),
    );
    wheelElements.add(
      WheelElement(
          colorValue: Colors.green.value,
          name: AppLocalizations.of(context)!.translate("burger") ?? '',
          id: 2),
    );
    wheelElements
        .add(WheelElement(colorValue: Colors.blue.value, name: 'Sushi', id: 3));
    wheelElements.add(WheelElement(
        colorValue: Colors.pink.value,
        name: AppLocalizations.of(context)!.translate("pasta") ?? '',
        id: 4));
    wheelElements.add(WheelElement(
        colorValue: Colors.orange.value,
        name: AppLocalizations.of(context)!.translate("chinese") ?? '',
        id: 5));
    wheelElements.add(WheelElement(
        colorValue: Colors.purple.value,
        name: AppLocalizations.of(context)!.translate("mexican") ?? '',
        id: 6));
    wheelElements.add(WheelElement(
        colorValue: Colors.yellow.value,
        name: AppLocalizations.of(context)!.translate("local_cousine") ?? '',
        id: 7));
    wheelElements.add(WheelElement(
        colorValue: Colors.grey.value,
        name: AppLocalizations.of(context)!.translate("salad") ?? '',
        id: 8));

    Wheel wheel = new Wheel(
      name: AppLocalizations.of(context)!.translate("what_to_eat") ?? '',
      wheelElements: wheelElements,
      imageIndex: 2,
      id: 1,
    );

    await Hive.box('wheels').put('1', wheel);

    return wheel;
  }

  Future<Wheel> _createYesNoWheel(BuildContext context) async {
    List<WheelElement> wheelElements = List.empty(growable: true);

    wheelElements.add(WheelElement(
        colorValue: Colors.green.value,
        name: AppLocalizations.of(context)!.translate("yes") ?? '',
        id: 1));
    wheelElements.add(WheelElement(
        colorValue: Colors.red.value,
        name: AppLocalizations.of(context)!.translate("no") ?? '',
        id: 2));

    Wheel wheel = new Wheel(
      name: AppLocalizations.of(context)!.translate("yes_no") ?? '',
      wheelElements: wheelElements,
      imageIndex: 0,
      id: 2,
    );

    await Hive.box('wheels').put('2', wheel);

    return wheel;
  }

  List<String> getSelectableImages() {
    return [
      "lib/assets/images/icon.png",
      "lib/assets/images/icons/baby.png",
      "lib/assets/images/icons/burger.png",
      "lib/assets/images/icons/clock.png",
      "lib/assets/images/icons/dinosaur.png",
      "lib/assets/images/icons/game-controller.png",
      "lib/assets/images/icons/gender.png",
      "lib/assets/images/icons/heart.png",
      "lib/assets/images/icons/id-card.png",
      "lib/assets/images/icons/light-saber.png",
      "lib/assets/images/icons/love-birds.png",
      "lib/assets/images/icons/money.png",
      "lib/assets/images/icons/star.png",
      "lib/assets/images/icons/tv.png",
      "lib/assets/images/icons/womens-day.png",
      "lib/assets/images/icons/plane.png",
      "lib/assets/images/icons/cake.png",
      "lib/assets/images/icons/christmas-tree.png",
    ];
  }
}
