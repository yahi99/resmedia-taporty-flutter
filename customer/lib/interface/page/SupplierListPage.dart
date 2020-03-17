import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierListBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/NoSupplierView.dart';

class SupplierListPage extends StatefulWidget {
  SupplierListPage(this.category, {Key key}) : super(key: key);

  final SupplierCategoryModel category;

  @override
  _SupplierListPageState createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  final SupplierListBloc _supplierListBloc = $Provider.of<SupplierListBloc>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: StreamBuilder<List<String>>(
              stream: _supplierListBloc.outSelectedTags,
              builder: (context, snapshot) {
                var selectedTags = snapshot.data ?? List<String>();
                return Container(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.category.tags.length,
                    itemBuilder: (_, index) {
                      var tag = widget.category.tags[index];
                      var isSelected = selectedTags.any((t) => t == tag.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(tag.name),
                          onSelected: (value) => _supplierListBloc.toggleTag(tag.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          StreamBuilder<List<SupplierModel>>(
            stream: _supplierListBloc.outSuppliers,
            builder: (context, AsyncSnapshot<List<SupplierModel>> supplierListSnapshot) {
              if (!supplierListSnapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              var supplierList = supplierListSnapshot.data;
              if (supplierList.length > 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9),
                  child: _buildSupplierListView(supplierList),
                );
              }
              return NoSupplierView();
            },
          ),
        ],
      ),
    );
  }

  _buildSupplierListView(var supplierList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: supplierList.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () async {
              var supplierBloc = $Provider.of<SupplierBloc>();
              supplierBloc.setSupplier(supplierList[index].id);

              Navigator.pushNamed(context, "/supplier");
            },
            child: SupplierView(
              supplier: supplierList[index],
            ),
          ),
        );
      },
    );
  }
}

class SupplierView extends StatelessWidget {
  final SupplierModel supplier;

  SupplierView({
    Key key,
    @required this.supplier,
  })  : assert(supplier != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String times = supplier.getTimetableString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 150,
            child: CachedNetworkImage(
              imageUrl: supplier.thumbnailUrl ?? supplier.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                height: 30.0,
                width: 30.0,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 50,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: AutoSizeText(
                        supplier.name,
                        maxFontSize: 18,
                        minFontSize: 14,
                        maxLines: 2,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          times,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
