import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTheme {
  const AppTheme({
    @required this.isDark,
    @required this.backgroundColor,
    @required this.headerBgColor,
    @required this.tabSelectedColor,
    @required this.tabUnselectedColor,
  });

  const AppTheme.dark({
    this.isDark = true,
    this.backgroundColor = Colors.black,
    this.headerBgColor = Colors.black,
    this.tabSelectedColor = Colors.red,
    this.tabUnselectedColor = Colors.blue,
  });

  const AppTheme.light({
    this.isDark = false,
    this.backgroundColor = AppColors.paleGrey,
    this.headerBgColor = AppColors.paleGrey,
    this.tabSelectedColor = Colors.red,
    this.tabUnselectedColor = Colors.blue,
  });

  const AppTheme.lightAndWhiteStatusBar({
    this.isDark = false,
    this.backgroundColor = AppColors.paleGrey,
    this.headerBgColor = AppColors.tabBarColor,
    this.tabSelectedColor = Colors.red,
    this.tabUnselectedColor = Colors.blue,
  });

  const AppTheme.lightAndDarkStatusBar({
    this.isDark = false,
    this.backgroundColor = AppColors.paleGrey,
    this.headerBgColor = AppColors.black,
    this.tabSelectedColor = Colors.red,
    this.tabUnselectedColor = Colors.blue,
  });

  final bool isDark;
  final Color backgroundColor;
  final Color headerBgColor;
  final Color tabSelectedColor;
  final Color tabUnselectedColor;
}

class AppThemeProvider with ChangeNotifier {
  AppTheme theme = const AppTheme.light();

  void updateAppTheme(AppTheme appTheme) {
    theme = appTheme;
    notifyListeners();
  }
}

extension AppThemeExt on BuildContext {
  AppTheme theme() {
    return watch<AppThemeProvider>().theme;
  }
}
