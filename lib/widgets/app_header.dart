import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key key, this.leading, this.actions, this.title, this.isEnableSearching = false}) : super(key: key);

  final Widget leading;
  final List<Widget> actions;
  final String title;
  final bool isEnableSearching;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tabBarColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0.W, right: 16.0.W, top: 8.0.H),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                leading ?? Container(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions ?? <Widget>[],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6.0.H, bottom: 10.0.H),
            padding: EdgeInsets.only(left: 16.0.W, right: 16.0.W),
            child: Row(
              children: <Widget>[
                Text(
                  title ?? '',
                  style: boldTextStyle(34.SP, Colors.black),
                ),
              ],
            ),
          ),
          if (isEnableSearching) Container(
            margin: EdgeInsets.only(left: 8.0.W, right: 8.0.W, top: 11.0.H, bottom: 16.H),
            height: 36.H,
            decoration: const BoxDecoration(
              color: AppColors.steel012,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0.W),
                  child: const Icon(Icons.search, color: AppColors.steel),
                ),
                Flexible(
                  child: CupertinoTextField(
                    placeholder: 'Search',
                    style: normalTextStyle(17.SP, AppColors.steel),
                    placeholderStyle: normalTextStyle(17.SP, AppColors.steel),
                    decoration: null,
                  ),
                )
              ],
            ),
          ) else Container(),
          Container(
            height: 1.H,
            color: AppColors.warmGrey2
          )
        ],
      ),
    );
  }
}
