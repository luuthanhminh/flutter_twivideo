import 'package:camera/camera.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/flutter_screenutil_extension.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:provider/provider.dart';

class PreSearchingPage extends StatefulWidget {

  @override
  _PreSearchingPageState createState() => _PreSearchingPageState();
}

class _PreSearchingPageState extends State<PreSearchingPage> {
  CameraController controller;
  bool isFrontCamera = true;
  Future<void> initialingCamera;

  @override
  void initState() {
    super.initState();
    initialingCamera = _initializingCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> handleLogout() async {
    await Provider.of<AuthProvider>(context, listen: false).handleLogout();
    Provider.of<LoginProvider>(context, listen: false).setLogout();
    NestedNavigatorsBlocProvider.of(context).select(AppConstant.searchPageRoute);
    Provider.of<ProfileProvider>(context, listen: false).clearData();
    Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
    Provider.of<CallingProvider>(context, listen: false).disconnect();
  }
  Future<void> getRandom() async {
    Provider.of<AppLoadingProvider>(context, listen: false).showLoading(context);
    final User client = await context.read<CallingProvider>().getRandom(onAuthorizationDioError: () {
      handleLogout();
    });
    Provider.of<AppLoadingProvider>(context, listen: false).hideLoading();
    if (client != null) {
      Navigator.pushNamed(context, AppConstant.searchingPageRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleGrey,
      body: Stack(
        children: <Widget>[
          const ImageBackgroundWidget(
            imageAsset: AppImages.background,
          ),
          Column(
            children: <Widget>[
              Container(
                height: 42.H,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.brightBlue),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Center(
                      child: Text('Search', style: semiBoldTextStyle(17.SP, Colors.black)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15.W, right: 15.W,),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: FutureBuilder<void>(
                              future: initialingCamera,
                              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return CameraSizedPreviewBox(
                                      boxFit: BoxFit.fitWidth,
                                      cameraRatio: controller.value.aspectRatio,
                                      margin: EdgeInsets.zero,
                                      cameraPreview: CameraPreview(controller));
                                }
                                return Container(color: AppColors.white3);
                              }
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 49.H,
                        width: ScreenUtil.screenWidthDp,
                        margin: EdgeInsets.only(bottom: 12.H, left: 15.W, right: 15.W),
                        padding: EdgeInsets.symmetric(horizontal: 16.H),
                        child: RaisedButton(
                          color: AppColors.jadeGreen,
                          onPressed: () {
                            getRandom();
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            'Start search',
                            style: boldTextStyle(16.SP, Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0.W, right: 15.0.W, top: 6.H, bottom: MediaQuery.of(context).padding.bottom + 10.H),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 30.H,
                        color: AppColors.lipstick,
                        child: Center(
                          child: Image.asset(AppImages.icMute),
                        ),
                      )
                    ),
                    SizedBox(width: 3.W),
                    Expanded(
                        child: GestureDetector(
                          onTap: _switchCamera,
                          child: Container(
                            height: 30.H,
                            color: AppColors.black,
                            child: Center(
                              child: Image.asset(AppImages.icSwitch),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: 3.W),
                    Expanded(
                        child: Container(
                          height: 30.H,
                          color: AppColors.black,
                          child: Center(
                            child: Image.asset(AppImages.icMicrophoneSmall),
                          ),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 8.H + MediaQuery.of(context).padding.bottom)
            ],
          )
        ],
      ),
    );
  }

  Future<void> _initializingCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
        cameras.firstWhere((CameraDescription element) => element.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first), ResolutionPreset.high);
    await controller.initialize();
  }

  Future<void> _switchCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
        cameras.firstWhere((CameraDescription element) => element.lensDirection == (isFrontCamera ? CameraLensDirection.back : CameraLensDirection.front),
            orElse: () => cameras.first), ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }
}

class CameraSizedPreviewBox extends StatelessWidget {
  const CameraSizedPreviewBox({Key key, this.cameraRatio, this.cameraPreview, this.margin, this.boxFit}) : super(key: key);

  final Widget cameraPreview;
  final double cameraRatio;
  final EdgeInsets margin;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.screenHeight,
      width: ScreenUtil.screenWidthDp,
      margin: margin ?? EdgeInsets.only(left: 15.W, right: 15.W),
      child: ClipRect(
        child: OverflowBox(
          child: FittedBox(
            fit: boxFit,
            child: Container(
              width: ScreenUtil.screenWidthDp,
              height: ScreenUtil.screenWidthDp / cameraRatio,
              child: AspectRatio(
                  aspectRatio: cameraRatio,
                  child: cameraPreview),
            ),
          ),
        ),
      ),
    );
  }
}
