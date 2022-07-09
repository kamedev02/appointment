import 'package:appointment/utils/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  ChangeThemeButton(ThemeProvider model, {Key? key}) : super(key: key);

  late ThemeProvider model;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.moon_stars),
      onPressed: () {
        model.toggleTheme();
      },
    );
  }
}
