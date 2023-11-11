import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';

import '../../models/wheel.dart';
import '../../shared/app_localizations.dart';

class WheelListElement extends StatelessWidget {
  Wheel wheel;

  WheelListElement({required this.wheel});

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: _w / 20),
        height: _w / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(_w / 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: _w / 5,
                width: _w / 5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(wheel.getImagePath()),
              ),
              SizedBox(width: _w / 10),
              SizedBox(
                width: _w / 2.05,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      wheel.name,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorService.getSecondaryColor(),
                        fontSize: _w / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (AppLocalizations.of(context)
                                  ?.translate('number_of_elements') ??
                              '') +
                          ' : ' +
                          wheel.wheelElements.length.toString(),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorService.getPrimaryColor(),
                        fontSize: _w / 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed('wheel', arguments: wheel),
    );
  }
}
