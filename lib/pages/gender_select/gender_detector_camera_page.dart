import 'package:camera/camera.dart';
import 'package:flirtbees/pages/gender_select/gender_provider.dart';
import 'package:flirtbees/pages/search/pre_searching_page.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderDetectorPage extends StatefulWidget {

  const GenderDetectorPage({Key key, this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  _GenderDetectorPageState createState() => _GenderDetectorPageState();
}

class _GenderDetectorPageState extends State<GenderDetectorPage> {

  CameraController controller;

  @override
  void initState() {
    super.initState();
    if (widget.camera != null) {
      controller = CameraController(widget.camera, ResolutionPreset.high);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cameraZone = Container(
      margin: MediaQuery.of(context).padding,
      color: AppColors.darkGreyBlue,
    );
    // ignore: unnecessary_parenthesis
    if ((controller?.value?.isInitialized ?? false)) {
      cameraZone = CameraSizedPreviewBox(
        cameraRatio: controller.value.aspectRatio,
        margin: EdgeInsets.zero,
        boxFit: BoxFit.fitHeight,
        cameraPreview: CameraPreview(controller),
      );
    }
    return ChangeNotifierProvider<GenderProvider>(
      create: (_) => GenderProvider(),
      builder: (BuildContext context, Widget _) {
        return Material(
          color: AppColors.paleGrey,
          child: Stack(
            children: <Widget>[
              const ImageBackgroundWidget(
                imageAsset: AppImages.background,
              ),
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 6.0.H,
                    left: 15.0.W,
                    right: 15.0.W,
                    bottom: 15.0.H + MediaQuery.of(context).padding.bottom,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: cameraZone)),
                  Positioned(
                      top: 35.0.H,
                      left: 15.0.W,
                      right: 15.0.W,
                      child: Center(child: Image.asset(AppImages.oval))),
                  Positioned(
                      left: 15.0.W,
                      right: 15.0.W,
                      bottom: 15.H,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Consumer<GenderProvider>(
                          builder: (BuildContext context, GenderProvider provider, _) {
                            String title = 'Detecting...';
                            String description = 'Position the camera so that your face is inside the frame...';
                            if (provider.isCompleted) {
                              title = "You're probably male";
                              description = 'Change gender or try face\nrecognition again';
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(height: 31.H),
                                  Text(title, style: normalTextStyle(18.SP, provider.isCompleted ? AppColors.fireEngineRed : AppColors.darkGreyBlue)),
                                  SizedBox(height: 16.H),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30.0.W, right: 30.0.W),
                                    child: Text(description,
                                      style: normalTextStyle(16.SP, AppColors.darkGreyBlue),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 40.H),
                                  Container(
                                    height: 49.H,
                                    width: ScreenUtil.screenWidthDp,
                                    margin: EdgeInsets.only(bottom: 10.H),
                                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                                    child: RaisedButton(
                                      color: AppColors.fireEngineRed,
                                      onPressed: () {
                                        provider.resetCountDown();
                                        provider.startTimer();
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(4))),
                                      child: Text(
                                        'Try again',
                                        style: boldTextStyle(16.SP, Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 49.H,
                                    width: ScreenUtil.screenWidthDp,
                                    margin: EdgeInsets.only(bottom: 10.H),
                                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                                    child: RaisedButton(
                                      color: AppColors.fireEngineRed,
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(AppConstant.genderSelectPageRoute);
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(4))),
                                      child: Text(
                                        'Change gender',
                                        style: boldTextStyle(16.SP, Colors.white),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, AppConstant.homePageRoute);
                                    },
                                    child: Container(height: 40.H,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Next', style: normalTextStyle(14.SP, Colors.black),),
                                        SizedBox(width: 8.W,),
                                        Image.asset(AppImages.icArrowRightBlack)
                                      ],
                                    ),),
                                  ),
                                  SizedBox(height: 40.H),
                                  Text('If you have any problem, please contact our support',
                                      style: normalTextStyle(12.SP, AppColors.warmGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('support@flirtbees.com', style: normalTextStyle(12.SP, AppColors.cerulean)),
                                  SizedBox(height: 17.H),
                                ],
                              );
                            }
                            if (provider.halfProgressing) {
                              title = 'Turn your head left';
                              description = 'Slowly turn your head left and look at the camera again';
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 20.H),
                                Text(title, style: normalTextStyle(16.SP, AppColors.darkGreyBlue)),
                                SizedBox(height: 20.H),
                                Padding(
                                  padding: EdgeInsets.only(left: 30.0.W, right: 30.0.W),
                                  child: Text(description,
                                      style: normalTextStyle(14.SP, AppColors.darkGreyBlue),
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20.H),
                                CircularProgressIndicator(
                                  value: provider.timerValue,
                                  backgroundColor: AppColors.white,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.jadeGreen),
                                ),
                                SizedBox(height: 40.H),
                              ],
                            );
                          }
                        ),
                      ))

                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
