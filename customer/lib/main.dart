import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/interface/screen/OrderCartScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/OrderDetailScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/ChangePasswordScreeen.dart';
import 'package:resmedia_taporty_customer/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/EditAccountScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/LegalNotesScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/OrderListScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/SettingsScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/SignupScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierListScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierReviewListScreen.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierScreen.dart';

void main() {
  runApp(Taporty());
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
      supportedLocales: <Locale>[
        const Locale("it"),
      ],
      routes: {
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignupScreen(),
        "/account": (context) => AccountScreen(),
        "/editAccount": (context) => EditAccountScreen(),
        "/orderList": (context) => OrderListScreen(),
        "/orderDetail": (context) => OrderDetailScreen(),
        "/orderCart": (context) => OrderCartScreen(),
        "/legalNotes": (context) => LegalNotesScreen(),
        "/changePassword": (context) => ChangePasswordScreen(),
        "/settings": (context) => SettingsScreen(),
        "/geolocalization": (context) => GeolocalizationScreen(),
        "/supplier": (context) => SupplierScreen(),
        "/supplierReviewList": (context) => SupplierReviewListScreen(),
        "/supplierList": (context) => SupplierListScreen(),
        "/checkout": (context) => CheckoutScreen(),
      },
      // TODO: Aggiungere controllo sull'utente per caricare la prima schermata (vedi SalentoSmart)
      initialRoute: "/login",
    );
  }
}
