import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decision_wheel/services/adservice.dart';

class BannerElement extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Widget>(
      future: AdService.instance.getAd(size),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.error != null) {
          return Center();
        } else {
          if (dataSnapshot.data == null) {
            return Center();
          } else {
            return dataSnapshot.data ?? Center();
          }
        }
      },
    );
  }
}
