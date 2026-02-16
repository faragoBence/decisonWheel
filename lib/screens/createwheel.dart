import 'dart:ui';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:decision_wheel/models/providers/wheelprovider.dart';
import 'package:decision_wheel/models/wheel_element.dart';
import 'package:decision_wheel/services/wheelservice.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:decision_wheel/shared/colorservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

import '../models/wheel.dart';

class CreateWheel extends StatefulWidget {
  @override
  _CreateWheelState createState() => _CreateWheelState();

  Wheel wheel;

  CreateWheel({required this.wheel});
}

class _CreateWheelState extends State<CreateWheel> {
  TextEditingController _nameController = TextEditingController();
  Wheel wheel = Wheel.createEmpty();
  List<WheelElement> items = List.empty(growable: true);
  Map<int, TextEditingController> _elementNameControllers =
      Map<int, TextEditingController>();

  @override
  void initState() {
    _nameController.text = widget.wheel.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    wheel = Provider.of<WheelProvider>(context, listen: true).wheel;
    items = widget.wheel.wheelElements;

    for (WheelElement element in items) {
      if (!_elementNameControllers.containsKey(element.id)) {
        var controller = new TextEditingController();
        controller.text = element.name;
        _elementNameControllers[element.id] = controller;
      }
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
          SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Center(
              child: Container(
                width: _w * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: _h * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('image_select');
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: _w / 30, left: _w / 60, right: _w / 60),
                            padding: EdgeInsets.all(_w / 80),
                            height: _w / 5,
                            width: _w / 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(wheel.getImagePath()),
                          ),
                        ),
                        Container(
                          height: _w / 8,
                          width: _w * 0.6,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: _w / 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                                color: ColorService.getSecondaryColor(),
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.abc,
                                color: ColorService.getSecondaryColor(),
                              ),
                              border: InputBorder.none,
                              hintMaxLines: 1,
                              hintText: AppLocalizations.of(context)!
                                      .translate('name_of_wheel') ??
                                  '',
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: _h * 1.5,
                      child: ImplicitlyAnimatedList<WheelElement>(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        items: items,
                        areItemsTheSame: (a, b) => a.id == b.id,
                        itemBuilder: (context, animation, item, index) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween(begin: Offset(1, 0.0), end: Offset.zero)
                                  .chain(
                                CurveTween(curve: Curves.easeIn),
                              ),
                            ),
                            // List element
                            child: Container(
                              margin: EdgeInsets.only(bottom: _w / 20),
                              height: _h / 13,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: _w / 10,
                                    width: _w / 10,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: GestureDetector(
                                      onTap: () {
                                        Dialogs.materialDialog(
                                          color: Colors.white,
                                          msg: '',
                                          context: context,
                                          actions: [
                                            MaterialPicker(
                                              pickerColor: ColorService
                                                  .getPrimaryColor(),
                                              onColorChanged: (color) {
                                                setState(() {
                                                  items[index].colorValue =
                                                      color.value;
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              enableLabel: false,
                                              portraitOnly: true,
                                            ),
                                          ],
                                        );
                                      },
                                      child: new Container(
                                        width: _w / 5,
                                        height: _w / 5,
                                        decoration: new BoxDecoration(
                                          color: item.getColor(),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: _w / 2.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: TextField(
                                            controller: _elementNameControllers[
                                                item.id],
                                            style: TextStyle(
                                                color: ColorService
                                                    .getSecondaryColor(),
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintMaxLines: 1,
                                              hintText: AppLocalizations.of(
                                                          context)!
                                                      .translate(
                                                          'name_of_decision') ??
                                                  '',
                                              hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(.5)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () => {
                                        setState(() {
                                          items.remove(item);
                                        }),
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: _h * 0.77,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.wheel.id != 0)
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      Dialogs.bottomMaterialDialog(
                        msg: AppLocalizations.of(context)
                                ?.translate('delete_approve') ??
                            '',
                        title:
                            AppLocalizations.of(context)?.translate('delete') ??
                                '',
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            text: AppLocalizations.of(context)
                                    ?.translate('cancel') ??
                                '',
                            iconData: Icons.cancel_outlined,
                            textStyle: TextStyle(color: Colors.white),
                            color: ColorService.getSecondaryColor(),
                            iconColor: Colors.white,
                          ),
                          IconsButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              await WheelService.instance
                                  .deleteWheel(context, widget.wheel);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            text: AppLocalizations.of(context)
                                    ?.translate('delete') ??
                                '',
                            iconData: Icons.delete,
                            color: ColorService.getDarkGreen(),
                            textStyle: TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ],
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
                              Icons.delete,
                              size: _w / 10,
                              color: ColorService.getPrimaryColor(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (_nameController.text == '') {
                      WheelService.instance
                          .showErrorSnackBar(context, 'error_no_name');
                      return;
                    }

                    if (items.length < 2) {
                      WheelService.instance
                          .showErrorSnackBar(context, 'error_min_elements');
                      return;
                    }

                    HapticFeedback.lightImpact();
                    Wheel wheel = widget.wheel;
                    for (WheelElement element in items) {
                      element.name = _elementNameControllers[element.id]!.text;
                    }
                    wheel.wheelElements = items;
                    wheel.name = _nameController.text;
                    wheel.id = wheel.id;
                    wheel.imageIndex = Provider.of<WheelProvider>(context, listen: false).wheel.imageIndex;
                    await WheelService.instance.saveWheel(context, wheel);
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                            Icons.save,
                            size: _w / 10,
                            color: ColorService.getPrimaryColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (items.length < 12) {
                      setState(() {
                        var controller = new TextEditingController();
                        String text = AppLocalizations.of(context)!
                                .translate('example') ??
                            '';
                        controller.text = text;
                        _elementNameControllers[items.length + 1] = controller;
                        items.add(
                          WheelElement(
                            name: text,
                            colorValue: ColorService.getPrimaryColor().value,
                            id: items.length + 1,
                          ),
                        );
                      });
                    } else {
                      WheelService.instance
                          .showErrorSnackBar(context, 'error_max_elements');
                    }
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
