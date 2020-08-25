import 'package:flirtbees/pages/search/search_provider.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PreSearchingPopup extends StatefulWidget {
  @override
  _PreSearchingPopupState createState() => _PreSearchingPopupState();
}

class _PreSearchingPopupState extends State<PreSearchingPopup> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: ScreenUtil.screenWidthDp,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 36.H,
              right: 15.W,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Start searching',
                    style: normalTextStyle(20.SP, Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.H),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(AppImages.icCamera, color: Colors.white),
                      SizedBox(width: 38.W),
                      Image.asset(AppImages.icMic, color: Colors.white),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50.0.W, right: 50.0.W, top: 45.H),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Access to camera',
                          style: normalTextStyle(16.SP, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        CupertinoSwitch(
                          value: Provider.of<SearchProvider>(context).isCameraPermissionGranted,
                          onChanged: (bool value) async {
                            final bool shouldContinue = await Provider.of<SearchProvider>(context, listen: false).requestCameraPermission();
                            if (shouldContinue) {
                              Navigator.of(context).maybePop('true');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50.0.W, right: 50.0.W, top: 25.H),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Access to microphone',
                          style: normalTextStyle(16.SP, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        CupertinoSwitch(
                          value: Provider.of<SearchProvider>(context).isMicroPermissionGranted,
                          onChanged: (bool value) async {
                            final bool shouldContinue = await Provider.of<SearchProvider>(context, listen: false).requestMicrophonePermission();
                            if (shouldContinue) {
                              Navigator.of(context).maybePop('true');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15.W, 44.H, 15.W, 23.H),
                      height: 1.H,
                      color: Colors.white
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0.W, right: 15.0.W),
                    child: Text('To start searching please allow access to camera and microphone',
                      style: normalTextStyle(16.SP, Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
