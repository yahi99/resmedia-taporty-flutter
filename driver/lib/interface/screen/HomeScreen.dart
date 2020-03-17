import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_driver/interface/page/OrderTab.dart';
import 'package:resmedia_taporty_driver/interface/page/ReservedShiftTab.dart';
import 'package:resmedia_taporty_driver/interface/page/CalendarTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "/account"),
              icon: Icon(Icons.account_circle),
            )
          ],
          bottom: TabBar(
            labelStyle: theme.textTheme.body1.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Ordini',
              ),
              Tab(
                text: 'Turni',
              ),
              Tab(
                text: 'Calendario',
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            OrderTab(),
            ReservedShiftTab(),
            CalendarTab(),
          ],
        ),
      ),
    );
  }
}
