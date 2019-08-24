import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/model.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/screen/CheckoutScreen.dart';
import 'package:mobile_app/interface/view/BottonButtonBar.dart';
import 'package:mobile_app/interface/view/InputField.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/model/UserModel.dart';

class ShippingPage extends StatelessWidget {
  final UserModel user;
  final Address address;

  ShippingPage({@required this.user, @required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final TextEditingController _nameController = new TextEditingController();
    final TextEditingController _lastNameController =
        new TextEditingController();
    final TextEditingController _emailController = new TextEditingController();
    final TextEditingController _addressController =
        new TextEditingController();
    final TextEditingController _phoneController = new TextEditingController();
    final TextEditingController _capController = new TextEditingController();
    final name = user.nominative.split(' ');
    _nameController.value = new TextEditingValue(text: user.nominative);
    //_lastNameController.value = new TextEditingValue(text: name[1]);
    _emailController.value = new TextEditingValue(text: user.email);
    _addressController.value = new TextEditingValue(text: '');
    _phoneController.value =
        new TextEditingValue(text: user.phoneNumber.toString());
    _capController.value = new TextEditingValue(text: address.postalCode);

    final _formKey = GlobalKey<FormState>();
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
                          if(value.length==0) return 'Campo non valido';
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
                          if(value.length==0) return 'Campo non valido';
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
                          if(value.length==0) return 'Campo non valido';
                          return null;
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                      ),
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
                      Text(address.toString()),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'CAP',
                              ),
                              validator: (value) {
                                if(value.length==0) return 'Campo non valido';
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
              if(_formKey.currentState.validate()){
                final state=MyInheritedWidget.of(context);
                state.address=_addressKey.currentState.toString();
                state.name=_phoneKey.currentState.toString();
                state.email=_emailKey.currentState.toString();
                state.address=_nameKey.currentState.toString();
                state.cap=_capKey.currentState.toString();
                DefaultTabController.of(context).index += 1;
              }
            },
          )),
    );
  }
}
//                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
