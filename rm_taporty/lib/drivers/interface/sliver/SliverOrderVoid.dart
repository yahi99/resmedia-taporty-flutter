import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';

class SliverOrderVoid extends StatelessWidget {
  final Widget title;
  final int childCount;
  final IndexedWidgetBuilder builder;

  const SliverOrderVoid({Key key,
    @required this.title, @required this.childCount, @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverList(
      delegate: SliverListSeparatorDelegate.childrenBuilder(
        childCount: childCount+1,
        separator: const SizedBox(height: 16.0,),
        builder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.title,
                child: title,
              ),
            );
          }
          return builder(context, index-1);
        },
      ),
    );
  }
}