import 'package:flirtbees/utils/app_theme.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/appbar_padding.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class ContentPage extends StatelessWidget {
  const ContentPage({@required this.body, Key key, this.customAppColor, this.enableBottomBar = true, this.ignoreCallBubble = false})
      : super(key: key);

  final Widget body;
  final Color customAppColor;
  final bool enableBottomBar;
  final bool ignoreCallBubble;

  @override
  Widget build(BuildContext context) {
    // Set the fit size (fill in the screen size of the device in the design)
    // https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    // Size of iPhone 8: 375 × 667 (points) - 750 × 1334 (pixels) (2x)
    ScreenUtil.init(context, width: 375, height: 667);
    NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(enableBottomBar);
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    final AppTheme theme = context.theme();
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: AppBar(
              elevation: 0,
              brightness: theme.isDark ? Brightness.dark : Brightness.light,
              backgroundColor: customAppColor ?? theme.headerBgColor),
        ),
        body: AppBarPadding(
          backgroundColor: customAppColor ?? theme.backgroundColor,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: <Widget>[
                body,
//                if (Provider.of<CallingProvider>(context).inCalling && !ignoreCallBubble) const CallingBubble()
//                else Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // After widget initialized.
  void onAfterBuild(BuildContext context) {}
}