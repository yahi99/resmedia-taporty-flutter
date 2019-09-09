import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/interface/screen/LoginScreen.dart';
import 'package:mobile_app/logic/bloc/FlavourBloc.dart';

/// flutter build --flavor development -t lib/main-dev.dart

//const red = Color(0xFFd50000), s_red = Color(0xFF9b0000), // B71C1C
//blue = Color(0xFF1565c0), blue_s = Color(0xFF003c8f); // 0F5DDB

const red = Color(0xFFd50000),
    accent_red = Color(0xFFff5131), // B71C1C
    blue = Color(0xFF1565c0),
    accent_blue = Color(0xFF5e92f3); // 0F5DDB
const STRIPE_PUBLIC_KEY = "pk_test_bI6Z2I2jFP7Tfjfm0AvIyWV500cS2fKdCO";

void main() {
  // TODO: Intervenire qui.
  FlavorBloc.of().init(Flavor.DRIVER);
  runApp(RepositoryBuilder(
    backgroundTask: (context, sharedPreferences) async {
      final assetHandler = await AssetHandler.init(context);
    },
    builder: (_) => MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final cls = ColorScheme.light(
      primary: red,
      primaryVariant: accent_red,
      secondary: blue,
      secondaryVariant: accent_blue,
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: cls,
        primaryColor: cls.primary,
        accentColor: cls.secondary,
        buttonColor: cls.primary,
        indicatorColor: Colors.white,
        dividerColor: Colors.grey,
        buttonTheme: ButtonThemeData(
          padding: const EdgeInsets.only(),
          buttonColor: cls.secondary,
          colorScheme: cls,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(32.0)),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white70,
        ),
        textTheme: TextTheme(
          headline: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'Comfortaa',
          ),
          title: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Comfortaa',
          ),
          subhead: TextStyle(
            fontSize: 18,
            fontFamily: 'Comfortaa',
          ),
          subtitle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
            fontFamily: 'Comfortaa',
          ),
          body1: TextStyle(
            fontSize: 16,
            letterSpacing: 0.5,
            fontFamily: 'Comfortaa',
          ),
          body2: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
            fontFamily: 'Comfortaa',
          ),
          button: TextStyle(
            fontWeight: FontWeight.bold,
            height: 0.8,
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Comfortaa',
          ),
          overline: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: cls.primaryVariant,
            fontFamily: 'Comfortaa',
          ),
        ),
      ),
      initialRoute: LoginScreen.ROUTE,
      onGenerateRoute: EasyRouter.onGenerateRouteBuilder(
          (_) => LoginScreen(), LoginScreen.ROUTE),
      navigatorObservers: <NavigatorObserver>[
        SwipeBackObserver(),
      ],
    );
  }
}
