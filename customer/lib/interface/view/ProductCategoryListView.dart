import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:tuple/tuple.dart';

class ProductCategoryListView extends StatelessWidget {
  final supplierBloc = $Provider.of<SupplierBloc>();
  ProductCategoryListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductCategoryModel>>(
      stream: supplierBloc.outProductCategories,
      builder: (context, categoryListSnap) {
        return StreamBuilder<List<String>>(
          stream: supplierBloc.outSelectedCategories,
          builder: (context, selectedCategoryIdListSnap) {
            List<ProductCategoryModel> categories = categoryListSnap.data ?? List<ProductCategoryModel>();
            final selectedCategoryIds = selectedCategoryIdListSnap.data ?? List<String>();
            return Container(
              height: 50,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    var category = categories[index];
                    var isSelected = selectedCategoryIds.contains(category.id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category.name),
                        onSelected: (value) => supplierBloc.toggleCategory(category.id),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
