import 'package:camera/camera.dart';
import 'package:flirtbees/pages/notifications/notification_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/pre_searching_popup.dart';
import 'package:flirtbees/pages/search/search_provider.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallingPopup extends StatelessWidget {
  const CallingPopup({Key key, this.dialogContext}) : super(key: key);

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 68.H,
        padding: EdgeInsets.symmetric(vertical: 8.H, horizontal: 10.W),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 52.H,
                    height: 52.H,
                    decoration: BoxDecoration(
                        color: AppColors.white3,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(AppHelper.getImageUrl(
                                imageName: context
                                    .watch<CallingProvider>()
                                    .currentFriend
                                    ?.user?.avatar)),
                            fit: BoxFit.cover))),
                SizedBox(
                  width: 8.W,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      context.watch<CallingProvider>().currentCaller.name,
                      style: semiBoldTextStyle(14.SP, Colors.black),
                    ),
                    SizedBox(
                      height: 2.H,
                    ),
                    Text(
                      'Video call',
                      style: normalTextStyle(14.SP, AppColors.steel),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 32.H,
                  height: 32.H,
                  child: InkWell(
                    onTap: () async {
                      if (await Provider.of<SearchProvider>(context,
                              listen: false)
                          .isAllPermissionsGranted()) {
                        Navigator.of(dialogContext).pop();
                        context.read<CallingProvider>()
                          ..isReceivedAnswer = true
                          ..closeCallingPopup = null
                          ..signaling.acceptCall();
                        if (context.read<NotificationProvider>().currentRouteName != AppConstant.searchingPageRoute) {
                          //Prevent push multiple calling page
                          Navigator.pushNamed(
                              context, AppConstant.searchingPageRoute);
                        }

                      } else {
                        final SearchProvider searchProvider = context.read<SearchProvider>();
                        showModalBottomSheet<String>(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            builder: (BuildContext context) => ChangeNotifierProvider<SearchProvider>.value(
                                value: searchProvider,
                                child: PreSearchingPopup())).then((dynamic value) async {
                          if (value == 'true') {
                            final List<CameraDescription> cameras = await availableCameras();
                            Navigator.pushNamed(context, AppConstant.searchingPageRoute, arguments: cameras);
                          }
                        });
                      }
                    },
                    child: Image.asset(AppImages.icVideoCallGreen),
                  ),
                ),
                SizedBox(
                  width: 8.W,
                ),
                Container(
                  width: 32.H,
                  height: 32.H,
                  child: InkWell(
                    onTap: () async {
                      // cancel
                      Navigator.of(dialogContext).pop();
                      Provider.of<CallingProvider>(context, listen: false)
                          .signaling
                          .bye();
                    },
                    child: Image.asset(AppImages.icCloseRedCircle),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
