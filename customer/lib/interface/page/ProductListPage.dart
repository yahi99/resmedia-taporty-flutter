import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductView.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:tuple/tuple.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supplierBloc = $Provider.of<SupplierBloc>();
    return StreamBuilder<Map<String, List<ProductModel>>>(
      stream: supplierBloc.outProductsByCategory,
      builder: (context, productMapSnapshot) {
        return StreamBuilder<List<Tuple2<ProductCategoryModel, bool>>>(
          stream: supplierBloc.outProductCategories,
          builder: (context, categoryTupleListSnapshot) {
            if (!productMapSnapshot.hasData || !categoryTupleListSnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            var productMap = productMapSnapshot.data;
            var categoryTuples = categoryTupleListSnapshot.data;
            if (productMap.isEmpty || categoryTuples.isEmpty)
              return Padding(
                child: Text(
                  'Non ci sono prodotti',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                padding: EdgeInsets.all(16.0),
              );

            var selectedCategories = categoryTuples.where((t) => t.item2 == true).map((t) => t.item1).toList();
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: selectedCategories.map<Widget>((category) {
                      var products = productMap[category.id];
                      return StickyHeader(
                        header: Container(
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
                        content: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (_, index2) => Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ProductView(products[index2]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (selectedCategories.length > 1)
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: FloatingActionButton(
                      child: Center(child: Icon(FontAwesomeIcons.slidersH)),
                      backgroundColor: ColorTheme.BLUE,
                      onPressed: () => supplierBloc.toggleCategorySelection(),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
