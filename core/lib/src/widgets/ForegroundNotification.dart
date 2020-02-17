import 'package:flutter/material.dart';

class ForegroundNotification extends StatelessWidget {
  final String title, message;
  final VoidCallback onTap;

  const ForegroundNotification(this.title, this.message, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: onTap,
            child: SafeArea(
              child: ListTile(
                title: Text(title),
                subtitle: Text(message),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
