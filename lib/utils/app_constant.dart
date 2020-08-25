import 'package:camera/camera.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail.dart';
import 'package:flirtbees/pages/content_settings/content_settings.dart';
import 'package:flirtbees/pages/friends/accept_friend_page.dart';
import 'package:flirtbees/pages/gender_select/gender_detector_camera_page.dart';
import 'package:flirtbees/pages/history/friend_request_page.dart';
import 'package:flirtbees/pages/history/history_page.dart';
import 'package:flirtbees/pages/history/history_settings_page.dart';
import 'package:flirtbees/pages/home/home_page.dart';
import 'package:flirtbees/pages/messages/messages_page.dart';
import 'package:flirtbees/pages/profile_picture/profile_picture.dart';
import 'package:flirtbees/pages/purchase/purchase_page.dart';
import 'package:flirtbees/pages/search/search_page.dart';
import 'package:flirtbees/pages/settings/settings_page.dart';
import 'package:flirtbees/pages/user_agreement/user_agreement_page.dart';
import 'package:flirtbees/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/pages/base/content_page.dart';
import 'package:flirtbees/pages/about_us/about_us_page.dart';
import 'package:flirtbees/pages/change_password/change_password.dart';
import 'package:flirtbees/pages/gender_select/gender_select_page.dart';
import 'package:flirtbees/pages/login/login_page.dart';
import 'package:flirtbees/pages/notifications/notifications_setting_page.dart';
import 'package:flirtbees/pages/payment_history/payment_history_page.dart';
import 'package:flirtbees/pages/profile/profile_page.dart';
import 'package:flirtbees/pages/register/register_page.dart';
import 'package:flirtbees/pages/register_profile/register_profile.dart';
import 'package:flirtbees/pages/search/pre_searching_page.dart';
import 'package:flirtbees/pages/search/calling_page.dart';
import 'package:flirtbees/pages/webrtc/call_page.dart';
import 'package:flirtbees/pages/welcome/welcome_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppConstant {
  static const String rootPageRoute = '/';
  static const String homePageRoute = '/home';
  static const String welcomePageRoute = '/welcome';
  static const String genderSelectPageRoute = '/gender_select';
  static const String userAgreementPageRoute = '/user_agreement';
  static const String callSamplePageRoute = '/call_sample';
  static const String loginPageRoute = '/login';
  static const String registerPageRoute = '/register';
  static const String profilePageRoute = '/profile';
  static const String registerProfilePageRoute = '/register_profile';
  static const String changePasswordPageRoute = '/change_password';
  static const String paymentHistoryPageRoute = '/payment_history';
  static const String aboutUsPageRoute = '/about_us';
  static const String preSearchingPageRoute = '/pre_searching';
  static const String searchingPageRoute = '/searching';
  static const String notificationSettingPageRoute = '/notification';
  static const String historyPageRoute = '/history';
  static const String searchPageRoute = '/search';
  static const String messagePageRoute = '/message';
  static const String settingsPageRoute = '/settings';
  static const String contentSettingsPageRoute = '/content_settings';
  static const String purchasePageRoute = '/purchase';
  static const String chatDetailPageRoute = '/chat_detail';
  static const String historySettingsPageRoute = '/history_settings';
  static const String friendRequestPageRoute = '/friend_request';
  static const String profilePicturePageRoute = '/profile_picture';
  static const String genderDetectorRoute = '/gender_detector';
  static const String acceptFriendRoute = '/accept_friend';

  // ignore: always_specify_types
  static MaterialPageRoute generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppConstant.homePageRoute:
        return MaterialWithModalsPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const HomeScreen());
      case AppConstant.genderDetectorRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) {
              final CameraDescription camera = routeSettings.arguments as CameraDescription;
              return ContentPage(body: GenderDetectorPage(camera: camera), enableBottomBar: false);
            });
      case AppConstant.friendRequestPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: FriendRequestPage(), enableBottomBar: false, customAppColor: AppColors.tabBarColor),);
        case AppConstant.profilePicturePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: ProfilePicturePage(), enableBottomBar: false, customAppColor: AppColors.black),);
      case AppConstant.historyPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: HistoryPage(), customAppColor: AppColors.tabBarColor));
        case AppConstant.historySettingsPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: HistorySettingsPage(), enableBottomBar: false));
      case AppConstant.messagePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_)  {
              return const ContentPage(body: MessagesPage(), customAppColor: AppColors.tabBarColor);
            });
      case AppConstant.searchPageRoute:
        return MaterialWithModalsPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: SearchPage()));
      case AppConstant.settingsPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: SettingsPage(), customAppColor: AppColors.tabBarColor));
      case AppConstant.rootPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const ContentPage(body: WelcomeScreen()));
      case AppConstant.loginPageRoute:
        return MaterialWithModalsPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: LoginPage(), enableBottomBar: false, customAppColor: AppColors.white));
      case AppConstant.registerPageRoute:
        return MaterialWithModalsPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: RegisterPage(), enableBottomBar: false, customAppColor: AppColors.white));

      case AppConstant.acceptFriendRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: AcceptFriendPage(), enableBottomBar: false, customAppColor: AppColors.white));
      case AppConstant.profilePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: ProfilePage()));
      case AppConstant.registerProfilePageRoute:
        return MaterialWithModalsPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: RegisterProfilePage(), enableBottomBar: false));
      case AppConstant.changePasswordPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: ChangePasswordPage()));
      case AppConstant.paymentHistoryPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: PaymentHistoryPage()));
      case AppConstant.aboutUsPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: AboutUsPage()));
        case AppConstant.contentSettingsPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: ContentSettingsPage()));
        case AppConstant.purchasePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: PurchasePage(), enableBottomBar: false, customAppColor: AppColors.tabBarColor));
        case AppConstant.chatDetailPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: ChatDetailPage(), enableBottomBar: false, customAppColor: AppColors.white));
      case AppConstant.notificationSettingPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: NotificationsSettingPage()));
      case AppConstant.welcomePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const ContentPage(body: WelcomeScreen()));
      case AppConstant.genderSelectPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: GenderSelectScreen()));
      case AppConstant.userAgreementPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => ContentPage(body: UserAgreementPage()));
      case AppConstant.preSearchingPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) {
              return ContentPage(body: PreSearchingPage(), enableBottomBar: false);
            });
      case AppConstant.searchingPageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const ContentPage(body: SearchingPage(), enableBottomBar: false, customAppColor: AppColors.black, ignoreCallBubble: true,));
      case AppConstant.callSamplePageRoute:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const ContentPage(
                body: CallScreen()));
//                body: CallScreen(ip: '192.168.68.107')));
      default:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => const ContentPage(body: WelcomeScreen()));
    }
  }
}