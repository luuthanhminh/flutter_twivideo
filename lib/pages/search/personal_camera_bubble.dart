import 'package:camera/camera.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/pre_searching_page.dart';
import 'package:flirtbees/pages/webrtc/signaling.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:provider/provider.dart';

class PersonalCameraBubble extends StatefulWidget {
  @override
  _PersonalCameraBubbleState createState() => _PersonalCameraBubbleState();
}

class _PersonalCameraBubbleState extends State<PersonalCameraBubble> {
  CameraController controller;
  bool isFrontCamera = true;
  Offset cameraPosition;
  double cameraChildWidth = 100.W, cameraChildHeight = 177.H;
  Future<void> initialingCamera;

  @override
  void initState() {
    final CallingProvider provider = context.read<CallingProvider>();
    super.initState();
    cameraPosition = Offset(ScreenUtil.screenWidthDp - 15.W - cameraChildWidth,
        ScreenUtil.screenHeightDp - 87.H - cameraChildHeight);
    if (provider.state != SignalingState.CallStateConnected || provider.state == null) {
      debugPrint('Camera Bubble: initState');
      initialingCamera = _initializingCamera();
    }

  }

  Future<void> _initializingCamera() async {
    debugPrint('Camera Bubble: _initializingCamera');
    final List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
        cameras.firstWhere(
            (CameraDescription element) =>
                element.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first),
        ResolutionPreset.high);
    await controller.initialize();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (Provider.of<CallingProvider>(context, listen: false).signaling !=
            null &&
        Provider.of<CallingProvider>(context, listen: false)
            .shouldCloseConnection) {
      debugPrint('Camera Bubble: deactivate');
      Provider.of<CallingProvider>(context, listen: false).signaling.close();
      Provider.of<CallingProvider>(context, listen: false)
          .localRenderer
          .dispose();
      Provider.of<CallingProvider>(context, listen: false)
          .remoteRenderer
          .dispose();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    debugPrint('Camera Bubble: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cameraPosition.dx,
      top: cameraPosition.dy,
      child: FutureBuilder<void>(
          future: initialingCamera,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            final bool isLoaded =
                snapshot.connectionState == ConnectionState.done;
            return Draggable<Widget>(
              feedback: Container(
                width: 100.W,
                height: 149.H,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Provider.of<CallingProvider>(context).state ==
                              SignalingState.CallStateNew
                          ? CameraSizedPreviewBox(
                              boxFit: BoxFit.fitWidth,
                              cameraRatio:
                                  controller?.value?.aspectRatio ?? 4 / 6,
                              margin: EdgeInsets.zero,
                              cameraPreview: RTCVideoView(
                                  Provider.of<CallingProvider>(context,
                                          listen: false)
                                      .localRenderer))
                          : isLoaded
                              ? CameraSizedPreviewBox(
                                  boxFit: BoxFit.fitWidth,
                                  cameraRatio: controller.value.aspectRatio,
                                  margin: EdgeInsets.zero,
                                  cameraPreview: CameraPreview(controller))
                              : Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.H),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _hangUp(context);
                            },
                            child: Container(
                              height: 26.H,
                              color: AppColors.lipstick,
                              child: Center(
                                child: Image.asset(AppImages.icMute),
                              ),
                            ),
                          )),
                          SizedBox(width: 1.W),
                          Expanded(
                              child: GestureDetector(
                            onTap: _switchCamera,
                            child: Container(
                              height: 26.H,
                              color: AppColors.black,
                              child: Center(
                                child: Image.asset(AppImages.icSwitch),
                              ),
                            ),
                          )),
                          SizedBox(width: 1.W),
                          Expanded(
                              child: GestureDetector(
                            onTap: _muteMic,
                            child: Container(
                              height: 26.H,
                              color: AppColors.black,
                              child: Center(
                                child: Image.asset(AppImages.icMicrophoneSmall),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              childWhenDragging: Container(),
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                setState(() {
                  cameraPosition = offset;
                });
              },
              child: Container(
                width: 100.W,
                height: 149.H,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Provider.of<CallingProvider>(context).state ==
                              SignalingState.CallStateConnected
                          ? CameraSizedPreviewBox(
                              boxFit: BoxFit.fitWidth,
                              cameraRatio:
                              (controller?.value?.aspectRatio) ?? 4 / 6,
                              margin: EdgeInsets.zero,
                              cameraPreview: RTCVideoView(
                                  Provider.of<CallingProvider>(context,
                                          listen: false)
                                      .localRenderer))
                          : isLoaded
                              ? CameraSizedPreviewBox(
                                  boxFit: BoxFit.fitWidth,
                                  cameraRatio: (controller?.value?.aspectRatio) ?? 4 / 6,
                                  margin: EdgeInsets.zero,
                                  cameraPreview: CameraPreview(controller))
                              : Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.H),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _hangUp(context);
                            },
                            child: Container(
                              height: 26.H,
                              color: AppColors.lipstick,
                              child: Center(
                                child: Image.asset(AppImages.icMute),
                              ),
                            ),
                          )),
                          SizedBox(width: 1.W),
                          Expanded(
                              child: GestureDetector(
                            onTap: _switchCamera,
                            child: Container(
                              height: 26.H,
                              color: AppColors.black,
                              child: Center(
                                child: Image.asset(AppImages.icSwitch),
                              ),
                            ),
                          )),
                          SizedBox(width: 1.W),
                          Expanded(
                              child: GestureDetector(
                            onTap: _muteMic,
                            child: Container(
                              height: 26.H,
                              color: AppColors.black,
                              child: Center(
                                child: Image.asset(AppImages.icMicrophoneSmall),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _hangUp(BuildContext context) {
    if (Provider.of<CallingProvider>(context, listen: false).signaling !=
        null) {
      Provider.of<CallingProvider>(context, listen: false).signaling.bye();
    }
  }

  void _muteMic() {}

  Future<void> _switchCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
        cameras.firstWhere(
            (CameraDescription element) =>
                element.lensDirection ==
                (isFrontCamera
                    ? CameraLensDirection.back
                    : CameraLensDirection.front),
            orElse: () => cameras.first),
        ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }
}
