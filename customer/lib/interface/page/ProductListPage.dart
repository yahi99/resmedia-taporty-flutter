import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductCategoryListView.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductView.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supplierBloc = $Provider.of<SupplierBloc>();
    return StickyHeader(
      header: ProductCategoryListView(),
      content: StreamBuilder<Map<String, List<ProductModel>>>(
        stream: supplierBloc.outProductsByCategory,
        builder: (context, productMapSnapshot) {
          return StreamBuilder<List<ProductCategoryModel>>(
            stream: supplierBloc.outProductCategories,
            builder: (context, categoryListSnapshot) {
              return StreamBuilder<List<String>>(
                stream: supplierBloc.outSelectedCategories,
                builder: (context, selectedCategoryListSnap) {
                  if (!productMapSnapshot.hasData || !categoryListSnapshot.hasData || !selectedCategoryListSnap.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  var productMap = productMapSnapshot.data;
                  var categories = categoryListSnapshot.data;
                  var selectedCategoryIds = selectedCategoryListSnap.data;
                  if (productMap.isEmpty || categories.isEmpty)
                    return Padding(
                      child: Text(
                        'Non ci sono prodotti',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      padding: EdgeInsets.all(16.0),
                    );
                  var selectedCategories;
                  if (selectedCategoryIds.length == 0)
                    selectedCategories = categories;
                  else
                    selectedCategories = categories.where((c) => selectedCategoryIds.contains(c.id)).toList();
                  return SingleChildScrollView(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedCategories.length,
                      itemBuilder: (_, index) {
                        final category = selectedCategories[index];
                        final products = productMap[category.id];
                        return Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              color: ColorTheme.LIGHT_GREY,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: DefaultTextStyle(
                                  style: theme.textTheme.subtitle,
                                  child: Text(category.name),
                                ),
                              ),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (_, index2) => Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ProductView(products[index2]),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
