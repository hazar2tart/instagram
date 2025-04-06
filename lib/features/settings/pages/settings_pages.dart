/*

dark mod e
bloacked usres 
account settings 


*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';
import 'package:my_ui/themes/theme_cubit.dart';

class SettingsPages extends StatelessWidget {
  const SettingsPages({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    bool isDarkMode = themeCubit.isDarkMode;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
//
      body: Column(
        children: [
          ListTile(
            title: Text("Drak Mode"),
            trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  themeCubit.toggleTheme();
                }),
          )
        ],
      ),
//theme cubit
    );
  }
}
