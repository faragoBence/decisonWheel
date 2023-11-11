import 'dart:async';
import 'dart:math';

import 'package:decision_wheel/models/providers/wheelprovider.dart';
import 'package:decision_wheel/models/wheel_element.dart';
import 'package:decision_wheel/services/adservice.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';

import '../models/providers/wheelsprovider.dart';
import '../models/wheel.dart';
import 'elements/bannerelement.dart';

class WheelScreen extends StatelessWidget {
  Wheel wheel;

  WheelScreen({required this.wheel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StreamController<int> controller = StreamController.broadcast();
    int selectedItem = 0;

    List<Wheel> wheels =
        Provider.of<WheelsProvider>(context, listen: true).wheels;
    for (Wheel cachedWheel in wheels) {
      if (cachedWheel.id == wheel.id) {
        wheel = cachedWheel;
      }
    }

    List<FortuneItem> items = List.empty(growable: true);
    for (WheelElement element in wheel.wheelElements) {
      items.add(
        new FortuneItem(
          child: Text(
            element.name,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          style: FortuneItemStyle(color: element.getColor()),
        ),
      );
    }
    return Scaffold(
      backgroundColor: ColorService.getLightGreen(),
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: size.height / 10,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(size.width, 56.0),
          ),
        ),
        backgroundColor: ColorService.getDarkGreen(),
        centerTitle: true,
        title: Text(
          wheel.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              Provider.of<WheelProvider>(context, listen: false).update(wheel);
              Navigator.of(context).pushNamed(
                'create_wheel',
                arguments: wheel.clone(),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: size.height * 0.01),
          Center(
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.7,
              child: FortuneWheel(
                indicators: <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
                animateFirst: false,
                physics: CircularPanPhysics(
                  duration: Duration(seconds: 3),
                  curve: Curves.decelerate,
                ),
                onAnimationEnd: () {
                  String selectedValue = wheel.wheelElements[selectedItem].name;
                  Dialogs.materialDialog(
                    color: ColorService.getLightGreen(),
                    titleStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    msgStyle: TextStyle(fontSize: 16),
                    msg: (AppLocalizations.of(context)!
                                .translate('the_winner_is') ??
                            '') +
                        ' ' +
                        selectedValue,
                    title: AppLocalizations.of(context)!
                            .translate('congratulations') ??
                        '',
                    lottieBuilder: Lottie.asset(
                      'lib/assets/animations/congratulation.json',
                      fit: BoxFit.contain,
                    ),
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          AdService.instance.initializeInterstitialAd(context);
                        },
                        text: 'Ok',
                        color: ColorService.getSecondaryColor(),
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  );
                },
                onFling: () {
                  int num = Random().nextInt(wheel.wheelElements.length);
                  controller.add(num);
                  selectedItem = num;
                },
                selected: controller.stream,
                items: items,
              ),
            ),
          ),
          Container(child: BannerElement()),
        ],
      ),
    );
  }
}
