import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/model.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/drivers/logic/bloc/CalendarBloc.dart';
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/drivers/model/ShiftModel.dart';
import 'package:mobile_app/interface/screen/CheckoutScreen.dart';
import 'package:mobile_app/interface/view/BottonButtonBar.dart';
import 'package:mobile_app/interface/view/InputField.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/UserModel.dart';
import 'package:toast/toast.dart';

class ShippingPage extends StatefulWidget {
  final UserModel user;
  final Address address;

  ShippingPage({@required this.user, @required this.address});

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<ShippingPage>
    with AutomaticKeepAliveClientMixin {
  String toDate(DateTime date) {
    return (date.day.toString() +
        '/' +
        date.month.toString() +
        '/' +
        date.year.toString());
  }

  String getEnd(List<CalendarModel> models,String value){
    for(int i=0;i<models.length;i++){
      if(models.elementAt(i).id==value) return models.elementAt(i).endTime;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var dateStream = new StreamController<DateTime>();
    var timeStream = new StreamController<List<CalendarModel>>();
    var dropStream = new StreamController<String>();
    //StreamController.broadcast();
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final TextEditingController _nameController = new TextEditingController();
    final TextEditingController _dateController = new TextEditingController();
    final TextEditingController _emailController = new TextEditingController();
    final TextEditingController _addressController =
        new TextEditingController();
    final TextEditingController _phoneController = new TextEditingController();
    final TextEditingController _capController = new TextEditingController();
    //final name = user.nominative.split(' ');
    _nameController.value = new TextEditingValue(text: widget.user.nominative);
    //_lastNameController.value = new TextEditingValue(text: name[1]);
    _emailController.value = new TextEditingValue(text: widget.user.email);
    _addressController.value = new TextEditingValue(text: '');
    _phoneController.value =
        new TextEditingValue(text: widget.user.phoneNumber.toString());
    _capController.value =
        new TextEditingValue(text: widget.address.postalCode);
    DateTime date;
    String time,endTime;
    final _formKey = GlobalKey<FormState>();
    final _dropKey = GlobalKey();
    final _dateKey = GlobalKey();
    final _nameKey = GlobalKey<FormFieldState>();
    //final _lastNameKey = GlobalKey<FormFieldState>();
    final _emailKey = GlobalKey<FormFieldState>();
    final _addressKey = GlobalKey<FormFieldState>();
    final _phoneKey = GlobalKey<FormFieldState>();
    final _capKey = GlobalKey<FormFieldState>();
    //MyInheritedWidget.of(context).sharedData;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SPACE * 2, vertical: SPACE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InputField(
                  title: Text(
                    'INFORMAZIONI DI CONTATTO',
                    style: tt.subtitle,
                  ),
                  body: Wrap(
                    runSpacing: 16,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nome',
                        ),
                        key: _nameKey,
                        validator: (value) {
                          if (value.length == 0) return 'Campo non valido';
                          return null;
                        },
                        controller: _nameController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                        ),
                        key: _emailKey,
                        validator: (value) {
                          if (value.length == 0) return 'Campo non valido';
                          return null;
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Telefono',
                        ),
                        key: _phoneKey,
                        validator: (value) {
                          if (value.length == 0) return 'Campo non valido';
                          return null;
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                      ),
                      Text('Giorno di consegna:'),
                      StreamBuilder<DateTime>(
                          stream: dateStream.stream,
                          builder: (ctx, sp) {
                            //if(!sp.hasData) return Center(child: CircularProgressIndicator(),);
                            return Column(
                              children: <Widget>[
                                TextField(
                                  controller: _dateController,
                                  key: _dateKey,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day - 1),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2020),
                                    ).then((day) {
                                      if (day != null) {
                                        date = day;
                                        _dateController.value =
                                            new TextEditingValue(
                                                text: toDate(date));
                                        dateStream.add(day);
                                      }
                                    });
                                  },
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SPACE, bottom: SPACE),
                                      child: Text('Ora di consegna:'),
                                    ),
                                  ],
                                ),
                                StreamBuilder<List<CalendarModel>>(
                                  stream: (!sp.hasData)
                                      ? timeStream.stream
                                      : Database().getAvailableShifts(sp.data),
                                  builder: (ctx, snap) {
                                    List<DropdownMenuItem> drop =
                                        new List<DropdownMenuItem>();
                                    List<String> values = new List<String>();
                                    if (snap.hasData) {
                                      //time=snap.data.elementAt(0).startTime;
                                      if (snap.data.isNotEmpty) {
                                        dropStream.add(
                                            snap.data.elementAt(0).startTime);
                                        time = snap.data.elementAt(0).startTime;
                                      }
                                      for (int i = 0;
                                          i < snap.data.length;
                                          i++) {
                                        values.add(
                                            snap.data.elementAt(i).startTime);
                                        drop.add(DropdownMenuItem(
                                          child: new Text(
                                              snap.data.elementAt(i).startTime),
                                          value:
                                              snap.data.elementAt(i).startTime,
                                        ));
                                      }
                                    }
                                    return StreamBuilder<String>(
                                      stream: dropStream.stream,
                                      builder: (ctx, sp1) {
                                        if (sp1.hasData) {
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              DropdownButton(
                                                key: _dropKey,
                                                value: (time == null)
                                                    ? values.elementAt(0)
                                                    : sp1.data,
                                                onChanged: (value) {
                                                  print(value);
                                                  time = value;
                                                  endTime=getEnd(snap.data,value);
                                                  dropStream.add(value);
                                                },
                                                items: drop,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: <Widget>[
                                              Text(
                                                  'Non ci sono turni disponibili in questo giorno.'),
                                            ],
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InputField(
                  title: Text(
                    'INDIRIZZO DI FATTURAZIONE',
                    style: tt.subtitle,
                  ),
                  body: Wrap(
                    runSpacing: 16.0,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38)),
                        child: DropdownButton(
                          isExpanded: true,
                          isDense: true,
                          value: 'Italia',
                          items: [
                            DropdownMenuItem(
                              value: 'Italia',
                              child: Text('Italia'),
                            ),
                            DropdownMenuItem(
                              value: 'Francia',
                              child: Text('Francia'),
                            ),
                          ],
                          onChanged: (_) {},
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38)),
                        child: DropdownButton(
                          isExpanded: true,
                          isDense: true,
                          value: 'Roma',
                          items: [
                            DropdownMenuItem(
                              value: 'Roma',
                              child: Text('Roma'),
                            ),
                            DropdownMenuItem(
                              value: 'Padova',
                              child: Text('Padova'),
                            ),
                          ],
                          onChanged: (_) {},
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      Text(widget.address.addressLine),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'CAP',
                              ),
                              validator: (value) {
                                if (value.length == 0)
                                  return 'Campo non valido';
                                return null;
                              },
                              key: _capKey,
                              controller: _capController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Checkbox(
                                value: true,
                                onChanged: null,
                              ),
                              Text(
                                'Invia allo\nstesso indirizzo',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
          color: theme.primaryColor,
          child: FlatButton(
            color: theme.primaryColor,
            child: Text(
              "Continua",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print(date);
                print(time);
                if (date != null && time != null) {
                  final state = MyInheritedWidget.of(context);
                  state.date = date.toIso8601String();
                  state.time = time;
                  state.endTime=endTime;
                  state.address = _addressKey.currentState.toString();
                  state.phone = _phoneKey.currentState.toString();
                  state.email = _emailKey.currentState.toString();
                  state.name = _nameKey.currentState.toString();
                  state.cap = _capKey.currentState.toString();
                  DefaultTabController.of(context).index += 1;
                } else
                  Toast.show('Dati Mancanti', context);
              }
            },
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
//                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
