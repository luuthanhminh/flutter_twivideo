

import 'package:flirtbees/pages/history/history_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/messages/messages_provider.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:provider/provider.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';

class TabIcon {
  TabIcon({this.icon, this.activeIcon});

  final String icon;
  final String activeIcon;
}

class TabItem {
  const TabItem({this.title, this.icon, this.routeName});

  final String title;
  final TabIcon icon;
  final String routeName;
}

class TabWidget extends StatelessWidget {
  const TabWidget({@required this.tabItems, Key key}) : super(key: key);

  final List<TabItem> tabItems;

  List<TabIcon> get tabIcons => tabItems
      .where((TabItem element) => element.icon != null)
      .map((TabItem e) => e.icon)
      .toList();

  Future<void> handleLogout(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).handleLogout();
    Provider.of<LoginProvider>(context, listen: false).setLogout();
    NestedNavigatorsBlocProvider.of(context).select(AppConstant.searchPageRoute);
    Provider.of<ProfileProvider>(context, listen: false).clearData();
    Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
    Provider.of<CallingProvider>(context, listen: false).disconnect();
  }


  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.theme();
    final List<NestedNavigatorItem> list = tabItems.map((TabItem e) =>
        NestedNavigatorItem(
            initialRoute: e.routeName,
            icon: Icons.details,
            text: e.title)).toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedNavigators<dynamic>(
        generateRoute: AppConstant.generateRoute,
        // ignore: prefer_for_elements_to_map_fromiterable
        items: Map<dynamic, NestedNavigatorItem>.fromIterable(
            list,
            key: (dynamic e) => e.initialRoute,
            value: (dynamic e) => e as NestedNavigatorItem),
        buildBottomNavigationItem: (dynamic key, NestedNavigatorItem item, bool selected) {
          final String activeIcon = tabItems.firstWhere((TabItem element) => element.routeName == item.initialRoute).icon.activeIcon;
          final String icon = tabItems.firstWhere((TabItem element) => element.routeName == item.initialRoute).icon.icon;
          return BottomNavigationBarItem(
            activeIcon: Container(
              height: 36,
              child: Image.asset(activeIcon,
                  height: 26,
                  width: 26),
            ),
            icon: Container(
              height: 36,
              child: Image.asset(icon,
                  height: 26,
                  width: 26),
            ),
            title: Text(item.text),
          );
        },
        bottomNavigationBarTheme: Theme.of(context).copyWith(
          primaryColor:  AppColors.darkGreyBlue,
        ),
        onTap: (int currentIndex) async {
          switch (tabItems[currentIndex].routeName) {
            case AppConstant.historyPageRoute:
              if (Provider.of<LoginProvider>(context, listen: false).isLoggedIn) {
                context.read<AppLoadingProvider>().showLoading(context);
                await Provider.of<HistoryProvider>(context, listen: false).getListHistories(onAuthorizationDioError: () {
                  handleLogout(context);
                });
                context.read<AppLoadingProvider>().hideLoading();
                continue messageLoggedIn;
              }
              context.read<AppThemeProvider>().updateAppTheme(const AppTheme.light());

              break;
            case AppConstant.messagePageRoute:
               if (Provider.of<LoginProvider>(context, listen: false).isLoggedIn) {
                 context.read<AppLoadingProvider>().showLoading(context);
                 await Provider.of<MessagesProvider>(context, listen: false).getListFriends(onAuthorizationDioError: () {
                   handleLogout(context);
                 });
                 context.read<AppLoadingProvider>().hideLoading();
               }
               break;
            messageLoggedIn:
            case AppConstant.settingsPageRoute:
              context.read<AppThemeProvider>().updateAppTheme(AppTheme(
                isDark: appTheme.isDark,
                backgroundColor: appTheme.backgroundColor,
                headerBgColor: AppColors.tabBarColor,
                tabSelectedColor: appTheme.tabSelectedColor,
                tabUnselectedColor: appTheme.tabUnselectedColor,
              ));
              break;
            default:
              context.read<AppThemeProvider>().updateAppTheme(const AppTheme.light());
          }
        },
        onCurrentTabPressed: (int currentIndex) {
          switch (tabItems[currentIndex].routeName) {
            case AppConstant.settingsPageRoute:
              Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
              break;
            default:
          }
        },
      ),
    );
  }
}
