import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/pre_searching_page.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:provider/provider.dart';

class  CameraBubble extends StatefulWidget {

  @override
  _CameraBubbleState createState() => _CameraBubbleState();
}

class _CameraBubbleState extends State<CameraBubble> {
  Offset cameraPosition;
  double cameraChildWidth = 100.W, cameraChildHeight = 177.H;

  @override
  void initState() {
    super.initState();
    cameraPosition = Offset(ScreenUtil.screenWidthDp - 80.W - cameraChildWidth,
        ScreenUtil.screenHeightDp - 87.H - cameraChildHeight);

  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cameraPosition.dx,
      top: cameraPosition.dy,
      child: Consumer<CallingProvider>(builder: (BuildContext context, CallingProvider provider, _) {
        return Draggable<Widget>(
          feedback: Container(
              width: 150.W,
              height: 225.W,
              child: ClipOval(
                child: provider.remoteRenderer == null ?
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ) : CameraSizedPreviewBox(
                    boxFit: BoxFit.fitWidth,
                    cameraRatio: 3 / 2,
                    margin: EdgeInsets.zero,
                    cameraPreview: RTCVideoView(provider.remoteRenderer)),
              )
          ),
          childWhenDragging: Container(),
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            setState(() {
              cameraPosition = offset;
            });
          },
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppConstant.searchingPageRoute);
            },
            child: Container(
              width: 200.W,
              height: 200.W,
              child: ClipOval(
                child: provider.remoteRenderer == null ?
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ) : CameraSizedPreviewBox(
                    boxFit: BoxFit.fitWidth,
                    cameraRatio: 3 / 2,
                    margin: EdgeInsets.zero,
                    cameraPreview: RTCVideoView(provider.remoteRenderer)),
              )
            ),
          ),
        );
      }),
    );
  }
}
