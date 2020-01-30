import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:tuple/tuple.dart';

class ProductCategoryListPage extends StatelessWidget {
  ProductCategoryListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final supplierBloc = $Provider.of<SupplierBloc>();
    return WillPopScope(
      onWillPop: () async {
        supplierBloc.toggleCategorySelection();
        return false;
      },
      child: StreamBuilder<List<Tuple2<ProductCategoryModel, bool>>>(
        stream: supplierBloc.outProductCategories,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          var categories = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Categorie",
                              style: theme.textTheme.title,
                            ),
                            FlatButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              child: Text("Applica"),
                              onPressed: () => supplierBloc.toggleCategorySelection(),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var category = categories[index].item1;
                          var isChecked = categories[index].item2;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                value: isChecked,
                                activeColor: ColorTheme.BLUE,
                                onChanged: (value) => supplierBloc.toggleCategory(category.id),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => supplierBloc.toggleCategory(category.id),
                                child: Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                        fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: categories.length,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
