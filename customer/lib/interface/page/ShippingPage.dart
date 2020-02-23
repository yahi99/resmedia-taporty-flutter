import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/BottonButtonBar.dart';
import 'package:toast/toast.dart';

class ShippingPage extends StatefulWidget {
  final UserModel user;
  final TabController controller;
  final GeoPoint customerCoordinates;
  final SupplierModel supplier;

  ShippingPage({@required this.user, @required this.customerCoordinates, @required this.supplier, @required this.controller});

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<ShippingPage> with AutomaticKeepAliveClientMixin {
  final cartBloc = $Provider.of<CartBloc>();
  final checkoutBloc = $Provider.of<CheckoutBloc>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderWidget("Informazioni di contatto"),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16, left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Campo non valido';
                        return null;
                      },
                      controller: checkoutBloc.nameController,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Numero di telefono',
                      ),
                      validator: (value) {
                        int temp = int.tryParse(value);
                        if (temp == null) return 'Campo non valido';
                        return null;
                      },
                      controller: checkoutBloc.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              HeaderWidget('Consegna'),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16, left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    StreamBuilder<DateTime>(
                      stream: checkoutBloc.outSelectedDate,
                      builder: (context, selectedDateSnapshot) {
                        var selectedDate = selectedDateSnapshot.data;
                        var dateString = selectedDateSnapshot.hasData ? DateTimeHelper.getDateString(selectedDateSnapshot.data) : "Nessuna data selezionata";
                        return StreamBuilder<List<DateTime>>(
                            stream: checkoutBloc.outAvailableDateRange,
                            builder: (context, dateRangeSnap) {
                              if (!dateRangeSnap.hasData) return Container();
                              var dateRange = dateRangeSnap.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      'Giorno di consegna:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  if (dateRange.isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(dateString),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            color: ColorTheme.BLUE,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.calendar_today,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  firstDate: selectedDate,
                                                  initialDate: dateRange[0],
                                                  lastDate: dateRange[1],
                                                );
                                                if (date != null) {
                                                  checkoutBloc.changeSelectedDate(date);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: <Widget>[
                                        Text('Non ci sono turni disponibili in questo giorno.'),
                                      ],
                                    ),
                                  if (selectedDateSnapshot.hasData) ...[
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.0, bottom: 6),
                                      child: Text(
                                        'Ora di consegna:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    StreamBuilder<List<ShiftModel>>(
                                      stream: checkoutBloc.outAvailableShifts,
                                      builder: (_, shiftListSnapshot) {
                                        if (shiftListSnapshot.hasData) {
                                          if (shiftListSnapshot.data.length > 0) {
                                            List<DropdownMenuItem<ShiftModel>> drop = List<DropdownMenuItem<ShiftModel>>();
                                            List<ShiftModel> dropdownOptions = List<ShiftModel>();
                                            for (int i = 0; i < shiftListSnapshot.data.length; i++) {
                                              dropdownOptions.add(shiftListSnapshot.data.elementAt(i));
                                              drop.add(DropdownMenuItem<ShiftModel>(
                                                child: Text(DateTimeHelper.getShiftString(shiftListSnapshot.data.elementAt(i))),
                                                value: shiftListSnapshot.data.elementAt(i),
                                              ));
                                            }

                                            return StreamBuilder<ShiftModel>(
                                              stream: checkoutBloc.outSelectedShift,
                                              builder: (context, selectedShiftSnapshot) {
                                                return Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    DropdownButton<ShiftModel>(
                                                      value: selectedShiftSnapshot.data,
                                                      onChanged: (value) {
                                                        checkoutBloc.changeSelectedShift(value);
                                                      },
                                                      items: drop,
                                                    ),
                                                  ],
                                                );
                                              },
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
                                  ]
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  HeaderWidget("Note aggiuntive"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16, left: 16, right: 16),
                    child: TextFormField(
                      maxLines: null,
                      minLines: 4,
                      decoration: InputDecoration(
                        hintMaxLines: 4,
                        hintText: "Inserisci ciò che vuoi far sapere al ristorante...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.0),
                        ),
                      ),
                      controller: checkoutBloc.noteController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        color: theme.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              color: theme.primaryColor,
              child: Text(
                "Indietro",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                widget.controller.animateTo(widget.controller.index - 1);
              },
            ),
            FlatButton(
              color: theme.primaryColor,
              child: Text(
                "Continua",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (checkoutBloc.selectedShift != null) {
                    var index = widget.controller.index;
                    widget.controller.animateTo(index + 1);
                  } else
                    Toast.show("Date e ora di consegna non selezionate.", context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
