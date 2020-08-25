import 'dart:ui' as ui;

import 'package:flirtbees/generated/l10n.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/friends/accept_friend_provider.dart';
import 'package:flirtbees/pages/history/friend_request_provider.dart';
import 'package:flirtbees/pages/history/history_provider.dart';
import 'package:flirtbees/pages/home/home_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/messages/messages_provider.dart';
import 'package:flirtbees/pages/notifications/notification_provider.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/pages/register/register_provider.dart';
import 'package:flirtbees/pages/search/search_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/auth_api.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flirtbees/services/remote/message_api.dart';
import 'package:flirtbees/services/remote/user_api.dart';
import 'package:flirtbees/services/startup_provider.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_constant.dart';
import 'package:flirtbees/utils/app_theme.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'widgets/nested_navigator/nested_navigators.dart';

Future<void> myMain() async {
  // Start services later
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  // Run Application
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<LocalStorage>(create: (_) => LocalStorage()),

        Provider<AuthApi>(create: (_) => AuthApi()),
        Provider<UserApi>(create: (BuildContext context) {
          final LocalStorage localStorage =
          Provider.of<LocalStorage>(context, listen: false);
          return UserApi(localStorage);
        }),
        Provider<FriendApi>(create: (BuildContext context) {
          final LocalStorage localStorage =
          Provider.of<LocalStorage>(context, listen: false);
          return FriendApi(localStorage);
        }),
        Provider<MessageApi>(create: (BuildContext context) {
          final LocalStorage localStorage =
          Provider.of<LocalStorage>(context, listen: false);
          return MessageApi(localStorage);
        }),
        Provider<AppLoadingProvider>(create: (_) => AppLoadingProvider()),
        ChangeNotifierProvider<HistoryProvider>(create: (BuildContext context) {
          final LocalStorage localStorage =
          Provider.of<LocalStorage>(context, listen: false);
          final FriendApi friendApi =
          Provider.of<FriendApi>(context, listen: false);
          return HistoryProvider(friendApi, localStorage);
        }),
        ChangeNotifierProvider<LoginProvider>(
            create: (BuildContext context) {
              final UserApi userApi = Provider.of<UserApi>(context, listen: false);
              final AuthApi authApi = Provider.of<AuthApi>(context, listen: false);
              final LocalStorage localStorage =
              Provider.of<LocalStorage>(context, listen: false);
              return LoginProvider(authApi, userApi, localStorage);
            }),
        ChangeNotifierProvider<StartupProvider>(create: (BuildContext context) {
          final LocalStorage localStorage =
          Provider.of<LocalStorage>(context, listen: false);
          final LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
          return StartupProvider(localStorage, loginProvider);
        }),
        ChangeNotifierProvider<RegisterProvider>(
          create: (BuildContext context) {
            final LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
            final AuthApi authApi = Provider.of<AuthApi>(context, listen: false);
            final LocalStorage localStorage =
            Provider.of<LocalStorage>(context, listen: false);
            return RegisterProvider(authApi, localStorage, loginProvider);
          },
        ),
        ChangeNotifierProvider<AuthProvider>(
            create: (BuildContext context) {
              final LocalStorage localStorage =
              Provider.of<LocalStorage>(context, listen: false);
              final LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
              final AuthApi authApi = Provider.of<AuthApi>(context, listen: false);
              final UserApi userApi = Provider.of<UserApi>(context, listen: false);
              return AuthProvider(authApi, localStorage, loginProvider, userApi);
            }),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<SocketHelper>(create: (_) => SocketHelper()),
        ChangeNotifierProvider<AppThemeProvider>(
            create: (_) => AppThemeProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider()),
        ChangeNotifierProvider<MessagesProvider>(
            create: (BuildContext context) {
              final FriendApi friendApi = Provider.of<FriendApi>(context, listen: false);
              final LocalStorage localStorage = Provider.of<LocalStorage>(context, listen: false);
              return MessagesProvider(friendApi, localStorage);
            }),
        ChangeNotifierProvider<ChatDetailProvider>(
            create: (BuildContext context) {
              final MessageApi messageApi = Provider.of<MessageApi>(context, listen: false);
              final LocalStorage localStorage = Provider.of<LocalStorage>(context, listen: false);
              return ChatDetailProvider(messageApi, localStorage);
            }),
        ChangeNotifierProvider<CallingProvider>(
            create: (BuildContext context) {
              final UserApi userApi = Provider.of<UserApi>(context, listen: false);
              final LocalStorage localStorage = Provider.of<LocalStorage>(context, listen: false);
              final FriendApi friendApi = Provider.of<FriendApi>(context, listen: false);
              final ChatDetailProvider chatDetailProvider = Provider.of<ChatDetailProvider>(context, listen: false);
              final SocketHelper socketHelper = Provider.of<SocketHelper>(context, listen: false);
              return CallingProvider(localStorage, userApi, friendApi, chatDetailProvider, socketHelper);
            }),
        ChangeNotifierProvider<SearchProvider>(
            create: (BuildContext context) {
              final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
              final LocalStorage localStorage = Provider.of<LocalStorage>(context, listen: false);
              final CallingProvider callingProvider = Provider.of<CallingProvider>(context, listen: false);
              return SearchProvider(authProvider, localStorage, callingProvider);
            }),
        ChangeNotifierProvider<ProfileProvider>(
            create: (BuildContext context) {
              final UserApi userApi = Provider.of<UserApi>(context, listen: false);
              final LocalStorage localStorage =
              Provider.of<LocalStorage>(context, listen: false);
              return ProfileProvider(userApi, localStorage);
            }),
        ChangeNotifierProvider<FriendRequestProvider>(
          create: (BuildContext context) {
            final CallingProvider callingProvider = Provider.of<CallingProvider>(context, listen: false);
            final FriendApi friendApi = Provider.of<FriendApi>(context, listen: false);
            return FriendRequestProvider(callingProvider, friendApi);
          },
        ),
        ChangeNotifierProvider<AccpetFriendProvider>(
          create: (BuildContext context) {
            final FriendApi friendApi = Provider.of<FriendApi>(context, listen: false);
            return AccpetFriendProvider(friendApi);
          },
        ),
        Provider<NotificationProvider>(create: (BuildContext context) {
          final AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
          final AccpetFriendProvider acceptFriendProvider =
          Provider.of<AccpetFriendProvider>(context, listen: false);
          final CallingProvider callingProvider =
          Provider.of<CallingProvider>(context, listen: false);
          final AppLoadingProvider apploadingProvider =
          Provider.of<AppLoadingProvider>(context, listen: false);
          final ChatDetailProvider chatDetailProvider =
          Provider.of<ChatDetailProvider>(context, listen: false);
          return NotificationProvider(authProvider, acceptFriendProvider, callingProvider, chatDetailProvider, apploadingProvider);
        }),

      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
   MyApp();

  final NestedNavigatorsBloc<String> _bloc = NestedNavigatorsBloc<String>();
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState(_bloc, navigatorState);
}

class _MyAppState extends State<MyApp> {

  final NestedNavigatorsBloc<String> _bloc;
  final GlobalKey<NavigatorState> navigatorState;


  _MyAppState(this._bloc, this.navigatorState);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<StartupProvider>().verifyStartupScreen();
      if (Provider.of<LoginProvider>(context, listen: false).isLoggedIn) {
        Provider.of<HistoryProvider>(context, listen: false).getListHistories();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (BuildContext context, LocaleProvider localeProvider, _) {

        final String startupScreen = context.watch<StartupProvider>().startupScreenRoute;

        return NestedNavigatorsBlocProvider(
          bloc: _bloc,
          child: MaterialApp(
            navigatorKey: navigatorState,
            locale: localeProvider.locale,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: AppFonts.lato,
//                pageTransitionsTheme: buildPageTransitionsTheme(),
            ),
            home: AppConstant.generateRoute(RouteSettings(name: startupScreen)).builder(context),
            onGenerateRoute: AppConstant.generateRoute,
          ),
        );
      },
    );
  }

  // Custom page transitions theme
  PageTransitionsTheme buildPageTransitionsTheme() {
    return const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
      },
    );
  }
}

class LocaleProvider with ChangeNotifier {
  Locale locale = Locale(ui.window.locale?.languageCode ?? ' en');

  Future<void> updateLocale(Locale locale) async {
    await S.load(locale);
    this.locale = locale;
    notifyListeners();
  }
}
