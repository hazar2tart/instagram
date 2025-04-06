import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final dynamic icon;
  final void Function()? onTap;
  const MyDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      // leading: Icon(
      //   icon,
      //   color: Theme.of(context).colorScheme.primary,
      // ),
      leading: icon is IconData
          ? Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            )
          : icon is Widget
              ? IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: icon,
                )
              : null,

      onTap: onTap,
    );
  }
}
