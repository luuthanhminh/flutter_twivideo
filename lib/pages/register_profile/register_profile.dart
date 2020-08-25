
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:provider/provider.dart';

class RegisterProfilePage extends StatefulWidget {
  @override
  _RegisterProfilePageState createState() => _RegisterProfilePageState();
}

class _RegisterProfilePageState extends State<RegisterProfilePage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.W),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(
              margin: EdgeInsets.only(top: 28.H),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Introduce yourself', style: boldTextStyle(34.SP, Colors.black),),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).popUntil(ModalRoute.withName(AppConstant.searchPageRoute));
                    },
                    child: Image.asset(AppImages.icCloseBlack),
                  )
                ],
              ),
            ),
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
                              image: NetworkImage('${Api.apiBaseUrl}/api/users/avatar/${Provider.of<ProfileProvider>(context).networkAvatar}'),
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
                controller: TextEditingController()..text = Provider.of<ProfileProvider>(context).userName,
                onChanged: (String text) {
                  Provider.of<ProfileProvider>(context, listen: false).userName = text;
                },
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
                controller: TextEditingController()..text = Provider.of<ProfileProvider>(context).email,
                onChanged: (String text) {
                  Provider.of<ProfileProvider>(context, listen: false).email = text;
                },
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
            SizedBox(height: 10.H),
            InkWell(
              onTap: () async {

                Provider.of<AppLoadingProvider>(context, listen: false).showLoading(context);
                final int gender = await Provider.of<LocalStorage>(context, listen: false).getGender();
                final User user = await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(uid: '', gender: gender);
                Provider.of<AppLoadingProvider>(context, listen: false).hideLoading();
                if (user != null) {
                  Provider.of<ProfileProvider>(context, listen: false).imagePath = null;
                  Provider.of<ProfileProvider>(context, listen: false).clearData();
                  Navigator.of(context).popUntil(ModalRoute.withName(AppConstant.searchPageRoute));
                }
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
    );
  }
}
