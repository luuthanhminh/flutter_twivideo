
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  Future<void> initRenderers() async {
    Provider.of<AppLoadingProvider>(context, listen: false).showLoading(context);
    await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(onAuthorizationDioError: (){
      onTapLogout();
    });
    Provider.of<AppLoadingProvider>(context, listen: false).hideLoading();
  }

  Future<void> onTapLogout() async {
    await Provider.of<AuthProvider>(context, listen: false).handleLogout();
    Provider.of<LoginProvider>(context, listen: false).setLogout();
    NestedNavigatorsBlocProvider.of(context).select(AppConstant.searchPageRoute);
    Provider.of<ProfileProvider>(context, listen: false).clearData();
    Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
    Provider.of<CallingProvider>(context, listen: false).disconnect();
  }

  Future<void> onTapUpdateProfile() async {
    Provider.of<AppLoadingProvider>(context, listen: false).showLoading(context);
    final int gender = await Provider.of<LocalStorage>(context, listen: false).getGender();
    final User user = await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(uid: '', gender: gender, onAuthorizationDioError: () {
      onTapLogout();
    });
    Provider.of<AppLoadingProvider>(context, listen: false).hideLoading();
    if (user != null) {
      Fluttertoast.showToast(msg: 'Update information successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppHeader(
            leading: InkWell(
              onTap: () async {
                Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
                final bool maybePop = await Navigator.maybePop(context);
                if (!maybePop) {
                  Navigator.pushReplacementNamed(context, AppConstant.settingsPageRoute);
                }
              },
              child: Row(
                children: <Widget>[
                  Image.asset(AppImages.icBack, color: AppColors.darkGreyBlue,),
                  SizedBox(width: 10.W,),
                  Text('Settings', style: normalTextStyle(17.SP, AppColors.darkGreyBlue),)
                ],
              ),
            ),
            title: 'Personal information',
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  onTapLogout();
                },
                child: Image.asset(AppImages.icLogout),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.W),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                SizedBox(height: 21.H,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Stack(
                      children: <Widget> [
                        Container(
                          width: 202.W,
                          height: 202.W,
                          decoration: BoxDecoration(
                              color: AppColors.white3,
                              shape: BoxShape.circle,
                              image: Provider.of<ProfileProvider>(context).imagePath != null ?
                              DecorationImage(
                                  image: AssetImage(Provider.of<ProfileProvider>(context).imagePath),
                                  fit: BoxFit.cover) :
                              Provider.of<ProfileProvider>(context).networkAvatar != null ?
                              DecorationImage(
                                  image: NetworkImage(Provider.of<ProfileProvider>(context).networkAvatar),
                                  fit: BoxFit.cover) : null
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                              onTap: () => Provider.of<ProfileProvider>(context, listen: false).getImage(context),
                              child: Image.asset(AppImages.icCameraGreen)),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 24.H,),
                Text('Your name', style: normalTextStyle(12.SP, AppColors.warmGrey)),
                SizedBox(height: 4.H,),
                Container(
                  height: 31.H,
                  child: TextField(
                    onChanged: (String text) {
                      Provider.of<ProfileProvider>(context, listen: false).userName = text;
                    },
                    controller: TextEditingController()..text = Provider.of<ProfileProvider>(context).userName,
                    decoration: InputDecoration(
                      hintStyle: normalTextStyle(14.SP, Colors.black),
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 20.H),
                    ),
                  ),
                ),

                Container(
                  height: 1,
                  color: AppColors.warmGrey2,
                ),
                SizedBox(height: 25.H,),
                Text('Your email', style: normalTextStyle(12, AppColors.warmGrey)),
                SizedBox(height: 4.H,),
                Container(
                  height: 31.H,
                  child: TextField(
                    onChanged: (String text) {
                      Provider.of<ProfileProvider>(context, listen: false).email = text;
                    },
                    controller: TextEditingController()..text = Provider.of<ProfileProvider>(context).email,
                    decoration: InputDecoration(
                      hintStyle: normalTextStyle(14.SP, Colors.black),
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 20.H),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColors.warmGrey2,
                ),
                SizedBox(height: 10.H),
                Container(
                  padding: const EdgeInsets.only(bottom: 8.5),
                  child: DropdownButton<String>(
                    value: Provider.of<ProfileProvider>(context, listen: false).currentChoosingAge ?? Provider.of<ProfileProvider>(context, listen: false).ages.first,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image.asset(AppImages.icArrowDown),
                    ),
                    elevation: 16,
                    itemHeight: 55,
                    style: normalTextStyle(14.SP, Colors.black),
                    isExpanded: true,
                    underline: Container(
                      height: 1,
                      color: AppColors.warmGrey2,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        Provider.of<ProfileProvider>(context, listen: false).currentChoosingAge = newValue;
                      });
                    },
                    items: Provider.of<ProfileProvider>(context, listen: false).ages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: normalTextStyle(14.SP, Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 30.H),
                InkWell(
                  onTap: () async {
                    onTapUpdateProfile();
                  },
                  child: Container(
                    height: 49.H,
                    width: ScreenUtil.screenWidthDp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.jadeGreen
                    ),
                    child: Center(
                      child: Text(
                          'Save', style: boldTextStyle(16.SP, Colors.white)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.H),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
