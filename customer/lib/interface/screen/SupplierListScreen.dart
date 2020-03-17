import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/LocationBloc.dart';
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
  final LocationBloc _locationBloc = $Provider.of<LocationBloc>();

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
          return StreamBuilder<LocationModel>(
              stream: _locationBloc.outCustomerLocation,
              builder: (context, locationSnap) {
                var location = locationSnap.data;
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: InkWell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.public),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: AutoSizeText(
                              location?.shortAddress ?? "Nella tua zona",
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 15,
                              maxLines: 1,
                              style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/geolocalization");
                      },
                    ),
                    backgroundColor: ColorTheme.RED,
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
              });
        },
      ),
    );
  }
}
