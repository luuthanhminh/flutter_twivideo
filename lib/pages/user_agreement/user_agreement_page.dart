import 'package:flirtbees/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:provider/provider.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60.H,
          child: Center(
            child: Text('User Agreement', style: boldTextStyle(18.SP, Colors.black),),
          ),
        ),
        Container(
          height: 0.5.H,
          color: AppColors.warmGrey2,
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.W, vertical: 20.H),
                    child: const Text('''
The term "User Agreement" refers to any agreement that's put in place between an owner, operator, or provider of a website, mobile app or web-based service that dictates and defines the scope of rights and responsibilities between both parties.

It doesn't matter what name you give to one of these agreements. There's no practical or defined difference between, for example, a User Agreement, a Terms and Conditions, or a Terms of Service. These are only names, and you can simply call any of them an "Agreement".

So, if the name doesn't generally matter, are there times when your agreements should be specifically separated or named in certain ways? The short answer is yes.

Some agreements are more important than others in certain circumstances, either because of legal requirements or simply as a convenience to your users.'''),
                  ),
                ],
              ),
              Positioned(
                bottom: 20.H,
                left: 16.W,
                right: 16.W,
                child: Container(
                  height: 49.H,
                  decoration: const BoxDecoration(
                      color: AppColors.jadeGreen,
                      borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: InkWell(
                    onTap: () {
                      context.read<LocalStorage>().saveAcceptAgreementStatus(isAccept: true);
                      Navigator.pushReplacementNamed(
                          context, AppConstant.genderSelectPageRoute,
                          arguments: true);
                    },
                    child: Center(
                      child: Text(
                        'Accept',
                        style: boldTextStyle(18.SP, Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
