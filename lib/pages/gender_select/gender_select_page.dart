import 'package:camera/camera.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_constant.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'gender_button.dart';

class GenderSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ImageBackgroundWidget(
          imageAsset: AppImages.icBackground,
        ),
        Container(
          color: const Color(0xFFE8E3E8).withOpacity(0.3),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(AppImages.icFlirtbeesLogo,
                        width: 162, height: 41),
                    const SizedBox(height: 16),
                    Text(
                      'You are',
                      style: semiBoldTextStyle(18, const Color(0xFF222222)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GenderButton(
                              normalIcon: AppImages.icMaleGrey,
                              pressedIcon: AppImages.icMaleWhite,
                              pressedColor: const Color(0xFF0A62C3),
                              onPressed: () async {
                                context.read<LocalStorage>().saveSelectedGender();
                                context.read<LocalStorage>().setGender(gender: 0);
                                Navigator.pushReplacementNamed(context, AppConstant.homePageRoute);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Male',
                              style: semiBoldTextStyle(
                            14, const Color(0xFF262626)),
                            )
                          ],
                        ),
                        SizedBox(width: 78.w.toDouble()),
                        Column(
                          children: <Widget>[
                            GenderButton(
                              normalIcon: AppImages.icFemaleGrey,
                              pressedIcon: AppImages.icFemaleWhite,
                              pressedColor: const Color(0xFFFB4C7E),
                              onPressed: () async {
                                context.read<LocalStorage>().saveSelectedGender();
                                context.read<LocalStorage>().setGender(gender: 1);
                                if (await requestCameraPermission()) {
                                  final List<CameraDescription> cameras = await availableCameras();
                                  final CameraDescription camera = cameras.firstWhere((CameraDescription element) => element.lensDirection == CameraLensDirection.front);
                                  Navigator.pushNamed(context, AppConstant.genderDetectorRoute, arguments: camera);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Female',
                              style: semiBoldTextStyle(
                                  14, const Color(0xFF262626)),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        )
      ],
    );
  }

  Future<bool> requestCameraPermission() async {
    // ignore: always_specify_types
    final Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
    if (statuses[Permission.camera].isGranted) {
      return true;
    }
    return false;
  }

}

class GenderSelectHeader extends StatelessWidget {
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
                    onPressed: () {},
                    color: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: Image.asset(
                      AppImages.icEmail,
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
            child: Image.asset(AppImages.icFlirtbeesIcon),
          ),
        ],
      ),
    );
  }
}
