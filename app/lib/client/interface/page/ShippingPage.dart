import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/model.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/InputField.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class ShippingPage extends StatefulWidget {
  final UserModel user;
  final Address address;
  final TabController controller;
  final RestaurantModel restaurant;

  ShippingPage({@required this.user, @required this.address, @required this.restaurant, @required this.controller});

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<ShippingPage> with AutomaticKeepAliveClientMixin {
  TextEditingController _nameController;
  TextEditingController _dateController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _phoneController;
  TextEditingController _capController;

  String toDate(DateTime date) {
    return (date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString());
  }

  Future<List<ShiftModel>> _availableShiftsFuture;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _capController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _capController.dispose();
    _dateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
  }

  ShiftModel _selectedShift;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    if (widget.user.nominative != null) _nameController.value = TextEditingValue(text: widget.user.nominative);
    _emailController.value = TextEditingValue(text: widget.user.email);
    _addressController.value = TextEditingValue(text: '');
    if (widget.user.phoneNumber != null) _phoneController.value = TextEditingValue(text: widget.user.phoneNumber.toString());
    _capController.value = TextEditingValue(text: widget.address.postalCode);

    final _formKey = GlobalKey<FormState>();
    final _dateKey = GlobalKey();
    final _nameKey = GlobalKey<FormFieldState>();
    final _emailKey = GlobalKey<FormFieldState>();
    final _phoneKey = GlobalKey<FormFieldState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.controller.animateTo(widget.controller.index - 1);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2, vertical: 12.0),
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
                          int temp = int.tryParse(value);
                          if (temp == null) return 'Campo non valido';
                          if (value.length != 10) return 'Numero non valido';
                          return null;
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                      ),
                      Text('Giorno di consegna:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            key: _dateKey,
                            controller: _dateController,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(hours: 48)),
                              ).then((day) {
                                if (day != null) {
                                  this.setState(() {
                                    _dateController.value = TextEditingValue(text: toDate(day));
                                    _selectedShift = null;
                                    _availableShiftsFuture =
                                        Database().getAvailableShifts(day, widget.restaurant.id, GeoPoint(widget.address.coordinates.latitude, widget.address.coordinates.longitude));
                                  });
                                }
                              });
                            },
                          ),
                          if (_availableShiftsFuture != null)
                            Padding(
                              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                              child: Text('Ora di consegna:'),
                            ),
                          if (_availableShiftsFuture != null)
                            FutureBuilder<List<ShiftModel>>(
                              future: _availableShiftsFuture,
                              builder: (ctx, AsyncSnapshot<List<ShiftModel>> shiftListSnapshot) {
                                if (shiftListSnapshot.connectionState == ConnectionState.done) {
                                  List<DropdownMenuItem<ShiftModel>> drop = List<DropdownMenuItem<ShiftModel>>();
                                  List<ShiftModel> dropdownOptions = List<ShiftModel>();
                                  if (shiftListSnapshot.hasData) {
                                    for (int i = 0; i < shiftListSnapshot.data.length; i++) {
                                      dropdownOptions.add(shiftListSnapshot.data.elementAt(i));
                                      drop.add(DropdownMenuItem<ShiftModel>(
                                        child: Text(DateTimeHelper.getShiftString(shiftListSnapshot.data.elementAt(i))),
                                        value: shiftListSnapshot.data.elementAt(i),
                                      ));
                                    }

                                    if (_selectedShift == null) _selectedShift = dropdownOptions[0];
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        DropdownButton<ShiftModel>(
                                          value: _selectedShift,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedShift = value;
                                            });
                                          },
                                          items: drop,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        Text('Non ci sono turni disponibili in questo giorno.'),
                                      ],
                                    );
                                  }
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                /*
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
                */
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
              if (_selectedShift != null) {
                // TODO: Rivedere
                final state = MyInheritedWidget.of(context);
                state.date = _selectedShift.startTime.toIso8601String();
                state.phone = _phoneKey.currentState.value.toString();
                state.email = _emailKey.currentState.value.toString();
                state.name = _nameKey.currentState.value.toString();
                widget.controller.animateTo(widget.controller.index + 1);
              } else
                Toast.show('Dati Mancanti', context);
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
