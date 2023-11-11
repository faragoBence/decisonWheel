import 'dart:ui';

import 'package:decision_wheel/models/wheel.dart';
import 'package:decision_wheel/screens/elements/wheellistelement.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../models/providers/wheelsprovider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    List<Wheel> wheels =
        Provider.of<WheelsProvider>(context, listen: true).wheels;
    return Scaffold(
      backgroundColor: ColorService.getLightGreen(),
      appBar: AppBar(
        toolbarHeight: _h / 10,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(_w, 56.0),
          ),
        ),
        backgroundColor: ColorService.getDarkGreen(),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate('app_name') ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(_w / 30),
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: wheels.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    horizontalOffset: -300,
                    verticalOffset: -850,
                    child: WheelListElement(
                      wheel: wheels[index],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: _h * 0.8,
              left: _w * 0.7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pushNamed(
                      'create_wheel',
                      arguments: Wheel.createEmpty(),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Container(
                        height: _w / 7,
                        width: _w / 7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: _w / 10,
                            color: ColorService.getPrimaryColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
