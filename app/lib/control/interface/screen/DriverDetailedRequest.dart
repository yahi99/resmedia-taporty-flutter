
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';

class DriverDetailedRequest extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'DriverDetailedRequest';

  final DriverRequestModel model;
  final bool isArchived;

  DriverDetailedRequest({this.model,this.isArchived});

  @override
  String get route => ROUTE;

  @override
  _DriverDetailedState createState() => _DriverDetailedState();
}

class _DriverDetailedState extends State<DriverDetailedRequest> {

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context).textTheme;
    return Scaffold(
      appBar: new AppBar(title:Text('Dettaglio Richiesta')),
      body:Padding(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Nome: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.nominative),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Esperienza: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.experience),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Mezzo di trasporto: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.mezzo),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Copertura in Km: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.km.toString()),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Codice Fiscale: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.codiceFiscale),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Container(child:Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text('Indirizzo: ',style:tt.subtitle ,),),
                      Flexible(child: Container(child: Text(widget.model.address),),),

                    ],
                  ),
                    padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if(!widget.isArchived) Database().archiveDriver(widget.model);
                          EasyRouter.pop(context);
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Database().addDriver(widget.model);
                          EasyRouter.pop(context);
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Consenti",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 4.0),
            ),
    );
  }
}