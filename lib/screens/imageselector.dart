import 'package:decision_wheel/services/wheelservice.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../models/providers/wheelprovider.dart';
import '../models/wheel.dart';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
  var _selectedImageIndex = 0;
  var _images = WheelService.instance.getSelectableImages();
}

class _ImageSelectorState extends State<ImageSelector> {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    int columnCount = 3;

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white,),
            splashColor: Colors.white,
            highlightColor: Colors.transparent,
            onPressed: () async {
              Wheel wheel =
                  Provider.of<WheelProvider>(context, listen: false).wheel;
              wheel.imageIndex = widget._selectedImageIndex;
              await Provider.of<WheelProvider>(context, listen: false).update(wheel);
              Navigator.of(context).pop();
            },
          )
        ],
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
      body: AnimationLimiter(
        child: GridView.count(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.all(_w / 60),
          crossAxisCount: columnCount,
          children: List.generate(
            widget._images.length,
            (int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: Duration(milliseconds: 500),
                columnCount: columnCount,
                child: ScaleAnimation(
                  duration: Duration(milliseconds: 900),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: FadeInAnimation(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: _w / 30, left: _w / 60, right: _w / 60),
                      padding: EdgeInsets.all(_w / 50),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: widget._selectedImageIndex == index
                                ? ColorService.getDarkGreen()
                                : Colors.transparent),
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
                      child: Center(
                        child: GestureDetector(
                          child: Image.asset(widget._images[index]),
                          onTap: () {
                            setState(() {
                              widget._selectedImageIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
