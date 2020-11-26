import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/supllier_flow/accepted_request_view_supplier.dart';
import 'package:flutter_fazal_test/supllier_flow/awarded_request_view_supplier.dart';
import 'package:flutter_fazal_test/supllier_flow/job_completed_request_view_supplier.dart';
import 'package:flutter_fazal_test/supllier_flow/new_request_view_supplier.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
class SupplierNewRequestScreen extends StatefulWidget {


  @override
  _SupplierNewRequestScreenState createState() =>
      _SupplierNewRequestScreenState();
}

class _SupplierNewRequestScreenState extends State<SupplierNewRequestScreen> {

  HexColor _HexColorBg = HexColor('#2B748D');
  HexColor _HexColorBlack = HexColor('##464646');
  HexColor _HexColorWhite = HexColor('#ffffff');
  HexColor bgColorFirst = HexColor('#2B748D');
  HexColor fontFirst = HexColor('ffffff');
  HexColor bgColorSecond = HexColor('ffffff');
  HexColor fontSecond = HexColor('##464646');
  List listAccepted = List();
  List listNewReq = List();
  String requestid;
  bool isNewRequestSelected=true;
  getSelectedTabColor(bool isNewRequestSelected) {
    if (isNewRequestSelected) {
      setState(() {
        bgColorFirst = _HexColorBg;
        fontFirst = _HexColorWhite;
        bgColorSecond = _HexColorWhite;
        fontSecond = _HexColorBlack;
      });
    } else {
      bgColorSecond = _HexColorBg;
      fontSecond = _HexColorWhite;
      bgColorFirst = _HexColorWhite;
      fontFirst = _HexColorBlack;
    }
  }

  @override
  void initState() {
    super.initState();
    if(ConstantsVariable.isTabIndexNew)
    {
      onPressedNewReq();
    }
    else
      {
        onPressedAcceptedReq();
      }
    setState(() {
     // wisNewRequestSelected = true;
    });
  }

  void onPressedNewReq () {
    setState(() {
      isNewRequestSelected = true;
      getSelectedTabColor( isNewRequestSelected);
      ConstantsVariable.isTabIndexNew=true;
    });
  }
  void onPressedAcceptedReq() {
    setState(() {
      isNewRequestSelected = false;
      getSelectedTabColor( isNewRequestSelected);
      ConstantsVariable.isTabIndexNew=false;
    });
  }

  Future<List<dynamic>> fetchingNewReq() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String userid=sharedPreferences.get('userid');
    print(userid+'***user');
    final response = await http.get(
        ApiUrls.BASE_API_URL+'supplierrequest?userid=${userid}');
    var responceJson = json.decode(response.body);
    if (responceJson['status']) {
      listNewReq = responceJson['new_request'].reversed.toList();;
      print(response.body);
      return listAccepted = responceJson['accept_request'].reversed.toList();;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) =>
                Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Container(
                              height: 60,
                              child: RaisedButton(
                                color: bgColorFirst,
                                onPressed: onPressedNewReq,
                                child: Text(
                                  'New Request',
                                  style: TextStyle(color: fontFirst),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Container(
                              height: 60,
                              child: RaisedButton(
                                color: bgColorSecond,
                                onPressed: onPressedAcceptedReq,
                                child: Text(
                                  'Accepted Requests',
                                  style: TextStyle(color: fontSecond),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 10,
                        child: FutureBuilder<List<dynamic>>(
                            future: fetchingNewReq(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return getList(  isNewRequestSelected);
                              }
                              else {
                                return Center(child: CircularProgressIndicator());
                              }
                            }))
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget getList(bool isNewRequest) {

    if (isNewRequest) {
      if(listNewReq.length>0)
        {
          return ListView.builder(
              itemCount: listNewReq == null
                  ? 0
                  : listNewReq.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return GestureDetector(
                  onTap: () {
                    ConstantsVariable.isTabIndexNew=true;
                    requestid=listAccepted[index]['requestid'];
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewRequestViewScreenSupplier(requestid)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                     alignment: Alignment.centerRight,
                        child: Text(listNewReq[index]['status']??"",
                            style: GoogleFonts.raleway(
                                color: HexColor('#2B748D'),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 10,
                            child: Container(
                                margin: EdgeInsets.only(top: 15, left: 10),
                                child: ReadMoreText(
                                  listNewReq[index]['requestdescription']??"",
                                  trimLines: 3,
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '...Show more',
                                  trimExpandedText: ' show less',
                                  style:
                                  GoogleFonts.questrial(color: HexColor('#777777'),
                                      fontSize: 18),
                                )


                            ),
                          ),

                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 25, left: 10),
                            child: Text(
                              listNewReq[index]['sentrequestdate']??"",
                              style: GoogleFonts.questrial(
                                  color: HexColor('#2B748D'), fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15, top: 25),
                            width: 60,
                            height: 20,
                            child: RaisedButton(
                                child: Text(
                                  'View',
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                color: HexColor('#2B748D'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: HexColor('#2B748D'))),
                                onPressed: () {
                                  {
                                    requestid=listNewReq[index]['requestid'];
                                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewRequestViewScreenSupplier(requestid)));
                                  }
                                }),
                          )
                        ],
                      ),
                      Divider(
                        color: HexColor('#B1B1B1'),
                      )
                    ],
                  ),
                );
              });
        }
      else{
        return Center(child: Text('No records found'),);
      }

    } else {
      {
     if(listAccepted.length>0)
       {
         return ListView.builder(
             itemCount: listAccepted == null
                 ? 0
                 : listAccepted.length,
             shrinkWrap: true,
             itemBuilder: (BuildContext ctxt, int index) {
               return GestureDetector(onTap: () {

                 requestid=listAccepted[index]['requestid'];
                 ConstantsVariable.isTabIndexNew=false;
                 Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewRequestViewScreenSupplier(requestid)));
               }
                 , child:  Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Align(
                       alignment: Alignment.centerRight,
                       child: Text(listAccepted[index]['status'],
                           style: GoogleFonts.raleway(
                               color: HexColor('#2B748D'),
                               fontSize: 12,
                               fontWeight: FontWeight.bold)),
                     ),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Flexible(
                           flex: 10,
                           child: Container(
                               margin: EdgeInsets.only(top: 15, left: 10),
                               child: ReadMoreText(
                                 listAccepted[index]['requestdescription'],
                                 trimLines: 3,
                                 colorClickableText: Colors.pink,
                                 trimMode: TrimMode.Line,
                                 trimCollapsedText: '...Show more',
                                 trimExpandedText: ' show less',
                                 style:
                                 GoogleFonts.questrial(color: HexColor('#777777'),
                                     fontSize: 18),
                               )


                           ),
                         ),

                       ],
                     ),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           margin: EdgeInsets.only(top: 25, left: 10),
                           child: Text(
                             listAccepted[index]['sentrequestdate'],
                             style: GoogleFonts.questrial(
                                 color: HexColor('#2B748D'), fontSize: 16),
                           ),
                         ),
                         Container(
                           margin: EdgeInsets.only(right: 15, top: 25),
                           width: 60,
                           height: 20,
                           child: RaisedButton(
                               child: Text(
                                 'View',
                                 style: GoogleFonts.josefinSans(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold),
                               ),
                               color: HexColor('#2B748D'),
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(25.0),
                                   side: BorderSide(color: HexColor('#2B748D'))),
                               onPressed: () {
                                 {
                                   requestid=listAccepted[index]['requestid'];
                                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewRequestViewScreenSupplier(requestid)));
                                 }
                               }),
                         )
                       ],
                     ),
                     Divider(
                       color: HexColor('#B1B1B1'),
                     )
                   ],
                 ),);
             });
       }
     else{
       return Center(child: Text('No records found'),);
     }
      }
    }
  }
}
