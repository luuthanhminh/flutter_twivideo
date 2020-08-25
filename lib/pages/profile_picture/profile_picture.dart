import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfilePicturePage extends StatefulWidget {
  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 15.W,
            top: 48.H,
            child: Container(
              width: 16.W,
              height: 16.H,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(AppImages.icCloseWhite),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 280.H, decoration: BoxDecoration(
                    color: AppColors.white3,
                    image: DecorationImage(
                        image: NetworkImage(AppHelper.getImageUrl(imageName: context.watch<ChatDetailProvider>().friend?.avatar))))
            ),
          )
        ],
      ),
    );
  }
}
