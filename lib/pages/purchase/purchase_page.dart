import 'package:flirtbees/pages/purchase/purchase_provider.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PurchaseProvider>(
      create: (_) => PurchaseProvider(),
        builder: (BuildContext context, _) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 549.H,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(image: AssetImage(AppImages.backgroundPurchase), fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          left: 5.W,
                          top: 15.H,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 30.W,
                              height: 30.W,

                              child: Container(
                                width: 7.W,
                                height: 13.H,
                                child: Image.asset(AppImages.icBack, color: Colors.white,),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15.0,
                          right: 15.0,
                          bottom: 15.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Buy minutes', style: blackTextStyle(20.SP, Colors.white),),
                              SizedBox(height: 4.H,),
                              Text('to chat', style: normalTextStyle(16.SP, Colors.white),),
                              SizedBox(height: 4.H,),
                              Text('without restrictions', style: normalTextStyle(16.SP, Colors.white),),
                              SizedBox(height: 8.H,),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.darkGreyBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(4))
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.W, vertical: 15.H),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 74.H,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(4))
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16.W, vertical: 13.H),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text('360 minutes', style: mediumTextStyle(22.SP, Colors.black),),
                                                  Text('€ 99', style: normalTextStyle(16.SP, Colors.black),)
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 4.H),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 17.W,
                                                          height: 18.H,
                                                          child: Image.asset(AppImages.icGiftPink),
                                                        ),
                                                        Container(
                                                            margin: EdgeInsets.only(left: 8.W),
                                                            child: Text('+160 minutes', style: normalTextStyle(16.SP, AppColors.rosyPink),))
                                                      ],
                                                    ),
                                                    Text('€ 9/month', style: normalTextStyle(16.SP, AppColors.steel),)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 60.H,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 10.H,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(width: 91.W,
                                                    child: Container(
                                                      width: 9.W,
                                                      height: 8.H,
                                                      child: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 12) ? Image.asset(AppImages.icTriangleDownWhite) : Container(),
                                                    ),
                                                  ),
                                                  Container(width: 91.W,
                                                    child: Container(
                                                      width: 9.W,
                                                      height: 8.H,
                                                      child: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 6) ? Image.asset(AppImages.icTriangleDownWhite) : Container(),
                                                    ),
                                                  ),
                                                  Container(width: 91.W,
                                                    child: Container(
                                                      width: 9.W,
                                                      height: 8.H,
                                                      child: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 1) ? Image.asset(AppImages.icTriangleDownWhite) : Container(),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  height: 49.H,
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                      border: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 12) ? Border.all(color: AppColors.jadeGreen) : Border.all(color: AppColors.steel)
                                                  ),
                                                  width: 91.W,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Provider.of<PurchaseProvider>(context, listen: false).updateNumberMonthPurchase(numberMonth: 12);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('12', style: mediumTextStyle(20.SP, Colors.white),),
                                                        Text('month', style: normalTextStyle(12.SP, Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 49.H,
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                      border: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 6) ? Border.all(color: AppColors.jadeGreen) : Border.all(color: AppColors.steel)
                                                  ),
                                                  width: 91.W,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Provider.of<PurchaseProvider>(context, listen: false).updateNumberMonthPurchase(numberMonth: 6);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('6', style: mediumTextStyle(20.SP, Colors.white),),
                                                        Text('month', style: normalTextStyle(12.SP, Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 49.H,
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                      border: (Provider.of<PurchaseProvider>(context).numberMonthPurchase == 1) ? Border.all(color: AppColors.jadeGreen) : Border.all(color: AppColors.steel)
                                                  ),
                                                  width: 91.W,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Provider.of<PurchaseProvider>(context, listen: false).updateNumberMonthPurchase(numberMonth: 1);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('1', style: mediumTextStyle(20.SP, Colors.white),),
                                                        Text('month', style: normalTextStyle(12.SP, Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.H,),
                                      Container(
                                        height: 49.H,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: AppColors.jadeGreen
                                        ),
                                        child: InkWell(
                                          onTap: () {

                                          },
                                          child: Center(
                                            child: Text('Buy', style: boldTextStyle(16.SP, Colors.white),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.H,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {

                                            },
                                            child: Text('Restore purchases', style: normalTextStyle(16.SP, Colors.white),),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.H,),
                  Container(
                    width: 315.W,
//                  height: 48.H,
                    child: Text('Your subscription can be canceld at any time.\nThe total cost is € 98,99. Your subscription will renew\nautomatically, and the subscription amout will be debited again at\nthe beginning of each billing period.',
                    style: normalTextStyle(10.SP, AppColors.warmGrey), textAlign: TextAlign.center, maxLines: 4,
                    ),

                  )
                ],
              ),

            ),
          );
        }
    );
  }
}
