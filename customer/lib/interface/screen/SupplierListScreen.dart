import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierListBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/SupplierCategoryListPage.dart';
import 'package:resmedia_taporty_customer/interface/page/SupplierListPage.dart';
import 'package:resmedia_taporty_customer/interface/widget/ArrowBack.dart';
import 'package:resmedia_taporty_customer/interface/widget/SearchBar.dart';

class SupplierListScreen extends StatefulWidget {
  SupplierListScreen({Key key}) : super(key: key);

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final UserBloc userBloc = $Provider.of<UserBloc>();
  final SupplierListBloc _supplierListBloc = $Provider.of<SupplierListBloc>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (_supplierListBloc.category != null) {
          _supplierListBloc.clear();
          return false;
        }
        return true;
      },
      child: StreamBuilder<String>(
          stream: _supplierListBloc.outCategoryId,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.public),
                  onPressed: () {
                    Navigator.pushNamed(context, "/geolocalization");
                  },
                ),
                title: Text(
                  'Nella tua zona',
                  style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
                ),
                backgroundColor: ColorTheme.RED,
                centerTitle: false,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      Navigator.pushNamed(context, "/account");
                    },
                  ),
                ],
                bottom: SearchBar(
                  leading: ArrowBack(
                    onArrowBackPressed: () => _supplierListBloc.clear(),
                    showArrowBack: snapshot.hasData,
                  ),
                  searchBarStream: _supplierListBloc.searchBarController,
                ),
              ),
              body: StreamBuilder<SupplierCategoryModel>(
                stream: _supplierListBloc.outCategory,
                builder: (context, AsyncSnapshot<SupplierCategoryModel> categorySnapshot) {
                  if (categorySnapshot.data == null) return SupplierCategoryListPage();
                  return SupplierListPage(categorySnapshot.data);
                },
              ),
            );
          }),
    );
  }
}
