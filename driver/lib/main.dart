import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_driver/interface/screen/LoginScreen.dart';

void main() async {
  runApp(RepositoryBuilder(
    backgroundTask: (context, sharedPreferences) async {
      await AssetHandler.init(context);
    },
    builder: (_) => Taporty(),
  ));
}

class Taporty extends StatefulWidget {
  @override
  _TaportyState createState() => _TaportyState();
}

class _TaportyState extends State<Taporty> {
  @override
  Widget build(BuildContext context) {
    final cls = ColorScheme.light(
      primary: ColorTheme.RED,
      primaryVariant: ColorTheme.ACCENT_RED,
      secondary: ColorTheme.BLUE,
      secondaryVariant: ColorTheme.ACCENT_BLUE,
    );

    return MaterialApp(
      title: "Taporty",
      theme: ThemeData(
        colorScheme: cls,
        primaryColor: cls.primary,
        accentColor: cls.secondary,
        buttonColor: cls.primary,
        indicatorColor: Colors.white,
        dividerColor: Colors.grey,
        buttonTheme: ButtonThemeData(
          // Rimossa questa indicazione di padding che non prevedeva un padding ai pulsanti.
          // padding: const EdgeInsets.only(),
          buttonColor: cls.secondary,
          colorScheme: cls,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
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
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it"),
      ],
      routes: {
        "/login": (context) => LoginScreen(),
        "/account": (context) => AccountScreen(),
      },
      initialRoute: "/login",
    );
  }
}