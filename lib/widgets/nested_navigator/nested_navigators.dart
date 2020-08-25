import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:nested_navigators/nested_nav_bloc.dart';
import 'package:nested_navigators/nested_nav_item.dart';
export 'package:nested_navigators/nested_nav_bloc_provider.dart';
export 'package:nested_navigators/nested_nav_bloc.dart';
export 'package:nested_navigators/nested_nav_item.dart';

/// The key for the route argument to be used to hide the [BottomNavigationBar] for this route.
///
/// For example:
/// ```dart
///  Navigator.of(context).pushNamed(
///                    Routes.red,
///                    arguments: {
///                      hideNavTabBar: true,
///                    },
///                  );
/// ```
const String hideNavTabBar = 'hide_nav_tab_bar';

/// Widget which contains N nested navigators and [BottomNavigationBar] (if [showBottomNavigationBar] is true).
/// For access to nested navigator use as usual [Navigator.of], it will return nested navigator wherein defined current widget.
/// Add argument [hideNavTabBar] = true to route arguments if it should be displayed without bottom navigation bar.
/// [initialNavigatorKey] defined which tab should be selected when app launched.
/// You can select nested navigator using [NestedNavigatorsBloc.select] or [NestedNavigatorsBloc.selectAndNavigate]
class NestedNavigators<T> extends StatefulWidget {
  NestedNavigators({
    @required this.items,
    @required this.generateRoute,
    T initialNavigatorKey,
    BottomNavigationBarItem Function(
            T key, NestedNavigatorItem item, bool selected)
        buildBottomNavigationItem,
    this.drawer,
    this.endDrawer,
    this.drawerDragStartBehavior = DragStartBehavior.down,
    this.buildCustomBottomNavigationItem,
    this.bottomNavigationBarTheme,
    this.bottomNavigationBarElevation = 8,
    this.showBottomNavigationBar = true,
    this.clearStackAfterTapOnCurrentTab = true,
    this.onTap, this.onCurrentTabPressed,
  })  : initialSelectedNavigatorKey = initialNavigatorKey ?? _defaultInitialSelectedNavigatorKey(items.keys),
        buildBottomNavigationItem = buildBottomNavigationItem ?? _defaultBottomNavigationBarItemBuilder<T>(),
        assert(items.isNotEmpty),
        assert(generateRoute != null) {
    // ignore: always_specify_types
    items.forEach((key, NestedNavigatorItem item) => item.generateRoute = generateRoute);
  }

  /// Map which contains key (prefer to use enums) and [NestedNavigatorItem] for each nested navigator.
  /// If [NestedNavigators] is a child of your [NestedNavigatorsBlocProvider], then the key type must match the generic type of [NestedNavigatorsBloc].
  ///
  /// For example:
  /// ```dart
  ///  items: {
  ///        NestedNavItemKey.blue: NestedNavigatorItem(
  ///          initialRoute: Routes.blue,
  ///          icon: Icons.access_time,
  ///          text: "Blue",
  ///        ),
  ///        NestedNavItemKey.red: NestedNavigatorItem(
  ///          initialRoute: Routes.red,
  ///          icon: Icons.send,
  ///          text: "Red",
  ///        ),
  ///        NestedNavItemKey.green: NestedNavigatorItem(
  ///          initialRoute: Routes.green,
  ///          icon: Icons.perm_identity,
  ///          text: "Green",
  ///        ),
  ///      }
  /// ```
  final Map<T, NestedNavigatorItem> items;

  /// A method that must return [MaterialPageRoute] for each named route that is used inside nested navigators.
  // ignore: always_specify_types
  final MaterialPageRoute Function(RouteSettings routeSettings) generateRoute;

  /// Key of nested navigator which will be selected when app launched and [NestedNavigators] will be added to widget tree
  final T initialSelectedNavigatorKey;

  /// Use this builder to customize [BottomNavigationBarItem] items.
  ///
  /// For example:
  /// ```dart
  ///  buildBottomNavigationItem: (key, item, selected) => BottomNavigationBarItem(
  ///          icon: Icon(
  ///            item.icon,
  ///            color: Colors.blue,
  ///          ),
  ///          title: Text(
  ///            item.text,
  ///            style: TextStyle(fontSize: 20),
  ///          ),
  ///          activeIcon: Icon(
  ///            Icons.star,
  ///            color: Colors.yellow,
  ///          ))
  /// ```
  final BottomNavigationBarItem Function(
    T key,
    NestedNavigatorItem item,
    bool selected,
  ) buildBottomNavigationItem;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from right-to-left ([TextDirection.ltr]) or
  /// left-to-right ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  final Widget Function(
    Map<T, NestedNavigatorItem> items,
    T selectedItemKey,
    Function(T) selectNavigator,
  ) drawer;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from either left-to-right ([TextDirection.ltr]) or
  /// right-to-left ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  final Widget Function(
    Map<T, NestedNavigatorItem> items,
    T selectedItemKey,
    Function(T) selectNavigator,
  ) endDrawer;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used for opening
  /// and closing a drawer will begin upon the detection of a drag gesture.
  /// If set to [DragStartBehavior.down] it will begin when a down event is
  /// first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.down].
  final DragStartBehavior drawerDragStartBehavior;

  /// Use this builder if [BottomNavigationBarItem] is not enough for you, and you want to use your own tab item design.
  ///
  /// For example:
  /// ```dart
  ///  buildCustomBottomNavigationItem: (key, item, selected) => Container(
  ///            height: 60,
  ///            child: Column(
  ///              mainAxisAlignment: MainAxisAlignment.center,
  ///              mainAxisSize: MainAxisSize.min,
  ///              children: <Widget>[
  ///                Icon(
  ///                  item.icon,
  ///                  size: 24,
  ///                  color: selected ? Colors.blue : null,
  ///                ),
  ///                Text(
  ///                  item.text,
  ///                  style: TextStyle(fontSize: 20, color: selected ? Colors.blue : null),
  ///                ),
  ///              ],
  ///            ),
  ///          ),
  ///```
  final Widget Function(
    T key,
    NestedNavigatorItem item,
    bool selected,
  ) buildCustomBottomNavigationItem;

  /// Define your owen theme of bottom navigation bar with splashColor for using different ripple effect color, or selected state icon and text color.
  ///
  /// For example:
  /// ```dart
  /// bottomNavigationBarTheme: Theme.of(context).copyWith(
  ///        splashColor: Colors.blue[100],
  ///        primaryColor: Colors.red,
  ///      ),
  /// ```
  final ThemeData bottomNavigationBarTheme;

  final double bottomNavigationBarElevation;

  /// Set this argument as false if you want to use [Drawer] instead of [BottomNavigatorBar] for selection nested navigator
  ///
  /// Defaults to true.
  final bool showBottomNavigationBar;

  /// Whether the widget stack should be cleared after clicking on the already selected tab.
  ///
  /// For example, if the currently displayed page is the fifth item in a stack of tab widgets stack,
  /// after clicking on current tab in bottom navigation bar,
  /// the widget stack of the current tab will be cleared and displayed [NestedNavigatorItem.initialRoute].
  ///
  /// Defaults to true.
  final bool clearStackAfterTapOnCurrentTab;

  final Function(int currentIndex) onTap;

  final Function(int currentIndex) onCurrentTabPressed;

  static BottomNavigationBarItem Function(
          T key, NestedNavigatorItem item, bool selected)
      _defaultBottomNavigationBarItemBuilder<T>() =>
          // ignore: always_specify_types
          (key, NestedNavigatorItem item, bool selected) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                title: Text(item.text),
              );

  static T _defaultInitialSelectedNavigatorKey<T>(Iterable<T> keys) {
    final int size = keys.length;
    return size % 2 == 0 ? keys.first : keys.elementAt((size / 2).floor());
  }

  @override
  // ignore: always_specify_types
  State<NestedNavigators> createState() => _NestedNavigatorsState<T>();
}

// ignore: always_specify_types
class _NestedNavigatorsState<T> extends State<NestedNavigators> {
  NestedNavigatorsBloc<T> _bloc;
  bool _hasBlocProviderInTree = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Map<T, NestedNavigatorItem> get _items => Map<T, NestedNavigatorItem>.from(widget.items);

  NavigatorState _getNavigatorState(T key) => _items[key].navigatorState;

  T _getNavigatorKeyByIndex(int index) => _items.keys.toList().elementAt(index);

  int _getNavigatorIndexByKey(T key) => _items.keys.toList().indexOf(key);

  @override
  void initState() {
    super.initState();
    // Check that NestedNavigatorsBlocProvider is already defined in the widget tree,
    // if yes - retrieve NestedNavigatorsBloc from him
    // if not - create a NestedNavigatorsBloc object and then add the NestedNavigatorsBlocProvider as the parent of Scaffold which contains a stack of Navigators
    _bloc = NestedNavigatorsBlocProvider.of(context) as NestedNavigatorsBloc<T>;
    _hasBlocProviderInTree = _bloc != null;
    _bloc ??= NestedNavigatorsBloc<T>();
    _bloc.select(widget.initialSelectedNavigatorKey as T);

    // Set the bottom navigation bar visibility when nested navigator selected
    // by using NestedNavigatorsBloc.select() or NestedNavigatorsBloc.selectAndNavigate()
    _bloc.outSelectTab.listen(
      // ignore: always_specify_types
      (key) => _bloc.setTabBarVisibility(_items[key].navTabBarVisible),
    );

    // Listen queries from widget which was added to widget tree with using root navigator,
    // but which is child of NestedNavigatorsBlocProvider, it's will work when app widget is child of NestedNavigatorsBlocProvider
    _bloc.outSelectTabAndNavigate.listen(
      (MapEntry<T, Function(NavigatorState navigator)> entry) => entry.value(_getNavigatorState(entry.key)),
    );

    _bloc.outActionWithScaffold.listen(
      // ignore: always_specify_types
      (action) => action(_scaffoldKey.currentState),
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async =>
            !await _getNavigatorState(_bloc.selectedNavigatorKey).maybePop(),
        child: _hasBlocProviderInTree
            ? _buildScaffold()
            : NestedNavigatorsBlocProvider(
                bloc: _bloc,
                child: _buildScaffold(),
              ),
      );

  StreamBuilder<T> _buildScaffold() => StreamBuilder<T>(
        stream: _bloc.outSelectTab,
        initialData: _bloc.selectedNavigatorKey,
        builder: (_, AsyncSnapshot<T> snapshot) => Scaffold(
          key: _scaffoldKey,
          drawer: widget.drawer != null
              ? widget.drawer(
                  _items,
                  _bloc.selectedNavigatorKey,
                  (dynamic key) => _bloc.select(key as T),
                )
              : null,
          endDrawer: widget.endDrawer != null
              ? widget.endDrawer(
                  _items,
                  _bloc.selectedNavigatorKey,
                  (dynamic key) => _bloc.select(key as T),
                )
              : null,
          drawerDragStartBehavior: widget.drawerDragStartBehavior,
          body: Stack(
              children: _items.keys
                  // ignore: always_specify_types
                  .map((key) => _buildNavigator(key, snapshot.data))
                  .toList()),
          bottomNavigationBar: widget.showBottomNavigationBar
              ? StreamBuilder<bool>(
                  initialData: true,
                  stream: _bloc.outTabBarVisibility,
                  builder: (_, AsyncSnapshot<bool> snapshot) {
                    return snapshot.data
                        ? _buildBottomNavigator()
                        : Container(height: 0);
                  },
                )
              : null,
        ),
      );

  Widget _buildNavigator(T key, T currentKey) => Offstage(
        offstage: currentKey != key,
        child: _items[key].navigator,
      );

  Widget _buildNativeBottomNavigatorBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: widget.bottomNavigationBarElevation,
        items: getBottomNavigatorBarItems(),
        currentIndex: _getNavigatorIndexByKey(_bloc.selectedNavigatorKey),
        onTap: (int index) {
          _onTabBarItemClick(_getNavigatorKeyByIndex(index), index: index);
          if (widget.onTap != null) {
            widget.onTap(index);
          }
        },
      );

  List<BottomNavigationBarItem> getBottomNavigatorBarItems() {
    return _items.entries
        .map(
          (MapEntry<T, NestedNavigatorItem> entry) => widget.buildBottomNavigationItem(
            entry.key,
            entry.value,
            _bloc.selectedNavigatorKey == entry.key,
          ),
        )
        .toList();
  }

  Widget _buildCustomBottomNavigatorBar() {
    // The ripple effect should go a bit beyond the widget.
    final double rippleEffectRadius =
        MediaQuery.of(context).size.width / _items.length * 1.2 / 2;

    return Material(
      color: Colors.white,
      child: Row(
        children: _items.keys
            // ignore: always_specify_types
            .map((key) => Expanded(
                  child: InkResponse(
                    onTap: () => _onTabBarItemClick(key),
                    radius: rippleEffectRadius,
                    highlightColor: Colors.transparent,
                    child: widget.buildCustomBottomNavigationItem(
                        key, _items[key], _bloc.selectedNavigatorKey == key),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomNavigator() => Theme(
        data: widget.bottomNavigationBarTheme ?? Theme.of(context),
        child: widget.buildCustomBottomNavigationItem == null
            ? _buildNativeBottomNavigatorBar()
            : _buildCustomBottomNavigatorBar(),
      );

  // ignore: always_declare_return_types
  void _onTabBarItemClick(T key, {int index}) {
    if (_bloc.selectedNavigatorKey == key &&
        widget.clearStackAfterTapOnCurrentTab) {
      if (widget.onCurrentTabPressed != null) {
        widget.onCurrentTabPressed(index);
      }
      // ignore: always_specify_types
      _getNavigatorState(key).popUntil((Route route) => route.isFirst);
    } else {
      _bloc.select(key);
    }
  }
}
