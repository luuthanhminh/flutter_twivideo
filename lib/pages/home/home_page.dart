import 'package:flirtbees/pages/home/home_provider.dart';
import 'package:flirtbees/pages/notifications/notification_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flirtbees/widgets/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.isMale}) : super(key: key);

  final bool isMale;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TabItem> tabItems = <TabItem>[
    TabItem(
        title: 'History',
        icon: TabIcon(
            icon: AppImages.icHistory, activeIcon: AppImages.icHistoryActive),
        routeName: AppConstant.historyPageRoute),
    TabItem(
        title: 'Search',
        icon: TabIcon(
            icon: AppImages.icSearch, activeIcon: AppImages.icSearchActive),
        routeName: AppConstant.searchPageRoute),
    TabItem(
        title: 'Messages',
        icon: TabIcon(
            icon: AppImages.icMessage, activeIcon: AppImages.icMessageActive),
        routeName: AppConstant.messagePageRoute),
    TabItem(
        title: 'Settings',
        icon: TabIcon(
            icon: AppImages.icSetting, activeIcon: AppImages.icSettingActive),
        routeName: AppConstant.settingsPageRoute)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>()
        ..configureNotification()
        ..configureLocalNotification()
        ..setContext(context);
      final CallingProvider callingProvider =
          Provider.of<CallingProvider>(context, listen: false);
      callingProvider
        ..connect(context)
        ..showCallingPopup = () {
          print('showCallingPopup');
          callingProvider.checkCallNavigator(context);
//          callingProvider.closeCallingPopup = () {
//            Navigator.of(context).pop();
//          };
        };
    });
  }

  @override
  void dispose() {
    super.dispose();
    context.read<NotificationProvider>().disposeCurrentContext();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ],
      child: Stack(
        children: <Widget>[
          Consumer<CallingProvider>(
              builder: (BuildContext context, CallingProvider provider, _) {
            debugPrint('build');
            return Container();
          }),
          const ImageBackgroundWidget(
            imageAsset: AppImages.background,
          ),
          TabWidget(tabItems: tabItems)
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            spreadRadius: -5,
            blurRadius: 3,
            offset: Offset(0.0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: Image.asset(
                      AppImages.icBack,
                      width: 24,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: Image.asset(
                      AppImages.icFlag,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Image.asset(AppImages.icFlirtbeesLogo),
          ),
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Image.asset(AppImages.icMaleAvatar),
          ),
        ],
      ),
    );
  }
}
