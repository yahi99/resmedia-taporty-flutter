import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierListBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/NoSupplierView.dart';

class SupplierCategoryListPage extends StatefulWidget {
  SupplierCategoryListPage({Key key}) : super(key: key);

  @override
  _SupplierCategoryListPageState createState() => _SupplierCategoryListPageState();
}

class _SupplierCategoryListPageState extends State<SupplierCategoryListPage> {
  final SupplierListBloc _supplierListBloc = $Provider.of<SupplierListBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SupplierCategoryModel>>(
      stream: _supplierListBloc.outCategories,
      builder: (context, AsyncSnapshot<List<SupplierCategoryModel>> supplierCategoryListSnapshot) {
        if (!supplierCategoryListSnapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        var supplierCategoryList = supplierCategoryListSnapshot.data;
        if (supplierCategoryList.length > 0) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSupplierCategoryListView(supplierCategoryList),
            ),
          );
        }
        return NoSupplierView();
      },
    );
  }

  _buildSupplierCategoryListView(List<SupplierCategoryModel> categoryList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categoryList.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () {
              _supplierListBloc.setCategory(categoryList[index].id);
            },
            child: SupplierCategoryView(
              category: categoryList[index],
            ),
          ),
        );
      },
    );
  }
}

class SupplierCategoryView extends StatelessWidget {
  final SupplierCategoryModel category;

  SupplierCategoryView({
    Key key,
    @required this.category,
  })  : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 11.5 / 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                colorBlendMode: BlendMode.modulate,
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
              ),
            ),
          ),
          Center(
            child: AutoSizeText(
              category.name,
              maxLines: 2,
              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}
