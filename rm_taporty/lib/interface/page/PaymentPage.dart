import 'package:easy_stripe/easy_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/view/BottonButtonBar.dart';
import 'package:mobile_app/interface/view/InputField.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    var userBloc = UserBloc.of();
    final TextEditingController _last4 = new TextEditingController();
    final TextEditingController _month = new TextEditingController();
    final TextEditingController _year = new TextEditingController();
    _last4.value = new TextEditingValue(text: '');
    _month.value = new TextEditingValue(text: '');
    _year.value = new TextEditingValue(text: '');
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(SPACE * 2),
            child: StreamBuilder<StripeSourceModel>(
                stream: userBloc.stripeManager.outCard,
                builder: (ctx, snap) {
                  if(snap.hasData){
                    _last4.value = new TextEditingValue(text: snap.data.card.last4);
                    _month.value = new TextEditingValue(text: snap.data.card.exp_month);
                    _year.value = new TextEditingValue(text: snap.data.card.exp_year);
                  }
                  return Column(
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
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Cognome",
                              ),
                              keyboardType: TextInputType.text,
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
                  );
                }),
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
              DefaultTabController.of(context).index += 1;
            },
          ),
        ));
  }
}