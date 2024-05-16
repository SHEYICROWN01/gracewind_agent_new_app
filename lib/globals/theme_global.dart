import 'package:flutter/material.dart';

class _ThemeGlobal {
  ValueNotifier<String> theme = ValueNotifier<String>("defaultTheme");

  setTheme(String value) async {
    theme.value = value;
  }
}

var themeGlobal = _ThemeGlobal();
