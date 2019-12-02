import 'package:easy_stripe/easy_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_flutter/interface/view/InputField.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';

class PaymentPage extends StatefulWidget {
  final TabController controller;

  PaymentPage(this.controller);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var isValid = false;
    var card_id;
    var stripe_customer;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    var userBloc = UserBloc.of();
    final TextEditingController _last4 = TextEditingController();
    final TextEditingController _month = TextEditingController();
    final TextEditingController _year = TextEditingController();
    final TextEditingController _name = TextEditingController();
    final TextEditingController _lastName = TextEditingController();
    _last4.value = TextEditingValue(text: '');
    _month.value = TextEditingValue(text: '');
    _year.value = TextEditingValue(text: '');
    _name.value = TextEditingValue(text: '');
    _lastName.value = TextEditingValue(text: '');
    return StreamBuilder<StripeSourceModel>(
        stream: userBloc.stripeManager.outCard,
        builder: (ctx, snap) {
          if (snap.hasData) {
            isValid = true;
            card_id=snap.data.token;
            _last4.value = TextEditingValue(text: snap.data.card.last4);
            _month.value =
                TextEditingValue(text: snap.data.card.exp_month.toString());
            _year.value =
                TextEditingValue(text: snap.data.card.exp_year.toString());
            if (snap.data.card.name != null) {
              var temp = snap.data.card.name.split(' ');
              if (temp.length == 2) {
                _name.value = TextEditingValue(text: temp[0]);
                _lastName.value = TextEditingValue(text: temp[1]);
              }
            }
          }
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    widget.controller.animateTo(widget.controller.index-1);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(SPACE * 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Image.asset('assets/img/home/creditcard.png'),

                      Card(
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StripePickSource(
                            manager: userBloc.stripeManager,
                          ),
                        ),
                      ),

                      InputField(
                        title: Text(
                          'Numero carta',
                          style: tt.subtitle,
                        ),
                        body: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'XXXX',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    enabled: false,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'XXXX',
                                    ),
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'XXXX',
                                ),
                                enabled: false,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'XXXX',
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                enabled: false,
                                controller: _last4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InputField(
                              title: Text(
                                'Mese',
                                style: tt.subtitle,
                              ),
                              body: TextField(
                                decoration: InputDecoration(
                                  labelText: 'MM',
                                ),
                                enabled: false,
                                controller: _month,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: InputField(
                              title: Text(
                                'Anno',
                                style: tt.subtitle,
                              ),
                              body: TextField(
                                decoration: InputDecoration(
                                  labelText: 'YY',
                                ),
                                enabled: false,
                                controller: _year,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 9),
                      InputField(
                        title: Text(
                          'CVV2/CVC2/4DBC',
                          style: tt.subtitle,
                        ),
                        body: TextField(
                          decoration: InputDecoration(
                            labelText: 'XXX',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                        ),
                      ),

                      InputField(
                        title: Text(
                          "DATI PERSONALI",
                          style: tt.subtitle,
                        ),
                        body: Wrap(
                          runSpacing: 16,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Nome",
                              ),
                              keyboardType: TextInputType.text,
                              controller: _name,
                              enabled: false,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Cognome",
                              ),
                              controller: _lastName,
                              keyboardType: TextInputType.text,
                              enabled: false,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Numero di Telefono",
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  onPressed: () async{
                    if (isValid && card_id!=null) {
                      final state = MyInheritedWidget.of(context);
                      state.fingerprint = card_id;
                      state.uid=(await UserBloc.of().outFirebaseUser.first).uid;
                      widget.controller.animateTo(widget.controller.index + 1);
                    }
                  },
                ),
              ));
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
