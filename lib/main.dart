import 'package:decision_wheel/models/wheel.dart';
import 'package:decision_wheel/models/wheel_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:decision_wheel/screens/startanimation.dart';
import 'package:decision_wheel/shared/app_localizations.dart';
import 'package:decision_wheel/shared/custom_route.dart';
import 'package:decision_wheel/shared/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/providers/wheelprovider.dart';
import 'models/providers/wheelsprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await MobileAds.instance.initialize();

  Hive.registerAdapter(WheelAdapter());
  Hive.registerAdapter(WheelElementAdapter());

  await Hive.openBox('wheels');
  Hive.box('wheels').delete(1);
  runApp(new MyApp());
}

const int _goldPrimaryValue = 0xFF1B5E20;

const MaterialColor primaryGold = MaterialColor(
  _goldPrimaryValue,
  <int, Color>{
    50: Color(_goldPrimaryValue),
    100: Color(_goldPrimaryValue),
    200: Color(_goldPrimaryValue),
    300: Color(_goldPrimaryValue),
    400: Color(_goldPrimaryValue),
    500: Color(_goldPrimaryValue),
    600: Color(_goldPrimaryValue),
    700: Color(_goldPrimaryValue),
    800: Color(_goldPrimaryValue),
    900: Color(_goldPrimaryValue),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WheelProvider()),
        ChangeNotifierProvider(create: (context) => WheelsProvider()),
      ],
      child: MaterialApp(
        title: 'Decision Wheel',
        theme: ThemeData(
          primarySwatch: primaryGold,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: ScaleTransitionBuilder(),
            TargetPlatform.iOS: ScaleTransitionBuilder(),
          }),
          fontFamily: 'Georgia',
        ),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hu', 'HU'),
        ],
        onGenerateRoute: RouteGenerator.generateRoute,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: StartAnimation(),
      ),
    );
  }
}
