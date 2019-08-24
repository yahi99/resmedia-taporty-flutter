import 'package:flutter/material.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:mobile_app/data/config.dart';


class AccountPageDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1+1/3*2,
                child: Image.asset("assets/img/home/etnici.png", fit: BoxFit.cover,),
              ),
            ],
          ),
        ),

        const Divider(color: Colors.grey,),
        Expanded(
          child: ListViewSeparated(
            separator: const Divider(color: Colors.grey,),
            children: <Widget>[
              Text("Cognome", style: theme.textTheme.headline,),
              Text("Nome", style: theme.textTheme.headline,),
              Text("Email", style: theme.textTheme.headline,)
            ].map((child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: SPACE*2),
                child: child,
              );
            }).toList(),
          ),
        ),
        const Divider(color: Colors.grey,),
      ],
    );
  }
}

//Container(
//        height: 170,
//        width: double.infinity,
//        decoration: BoxDecoration(
//        image: DecorationImage(
//            image: AssetImage('assetName'),
//            fit: BoxFit.cover,
//          ),
//        boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 0.0)],
//        ),
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(
//                top: 60.0,
//                bottom: 18.0,
//                left: 18.0,
//                right: 18.0,
//              ),
//              child: Row(
//                children: <Widget>[
//                  Container(
//                    height: 60.0,
//                    width: 60.0,
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      image: DecorationImage(
//                        image: AssetImage('assetName'),
//                        fit: BoxFit.cover,
//                      )
//                    ),
//                    )
//                ],
//              ),
//            ),
//            TextFormField(
//              decoration: InputDecoration(
//                hintText: 'Cognome',
//              ),
//            ),
//            TextFormField(
//              decoration: InputDecoration(
//                hintText: 'Nome',
//              ),
//            ),
//            TextFormField(
//              decoration: InputDecoration(
//                hintText: 'E-mail',
//              ),
//            )
//          ],
//
//          ),
//      )