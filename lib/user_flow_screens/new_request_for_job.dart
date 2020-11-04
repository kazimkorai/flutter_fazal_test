import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/user_flow_screens/awarded_request_view.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_view.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewRequestForJob extends StatefulWidget {
  NewRequestForJob(this.requestid);

  final String requestid;

  @override
  _NewRequestForJobState createState() => _NewRequestForJobState(requestid);
}

class _NewRequestForJobState extends State<NewRequestForJob> {
  _NewRequestForJobState(this.requestid);

  final String requestid;
  HexColor _HexColorBg = HexColor('#2B748D');
  HexColor _HexColorBlack = HexColor('#000000');
  HexColor _HexColorWhite = HexColor('#ffffff');
  HexColor bgColorFirst = HexColor('#2B748D');
  HexColor fontFirst = HexColor('ffffff');
  HexColor bgColorSecond = HexColor('ffffff');
  HexColor fontSecond = HexColor('#000000');
  bool isNewRequestSelected = false;
  List listAwarded = List();
  List listNewReq = List();

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
    print('new request for job');
    setState(() {
      isNewRequestSelected = true;
    });
  }

  Future<List<dynamic>> fetchingNewReq() async {
    print(requestid);

    final response = await http.get(ApiUrls.BASE_API_URL +
        'particularserviceforcustomer?requestid=${requestid}');
    var responceJson = json.decode(response.body);

    if (responceJson['status']) {
      listNewReq = responceJson['accepted_request'];
      return listAwarded = responceJson['award_request'];
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: InboxScreen()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => Column(
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
                            onPressed: () {
                              setState(() {
                                isNewRequestSelected = true;
                                getSelectedTabColor(isNewRequestSelected);
                              });
                            },
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
                            onPressed: () {
                              setState(() {
                                isNewRequestSelected = false;
                                getSelectedTabColor(isNewRequestSelected);
                              });
                            },
                            child: Text(
                              'Awarded Requests',
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
                          return getList(isNewRequestSelected);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getList(bool isNewRequest) {
    print("*new requestforjob"+listNewReq.length.toString());
    print("*new requestforjob"+listAwarded.length.toString());
    if (isNewRequest) {
      if(listNewReq.length>0)
        {
          return ListView.builder(
              itemCount: listNewReq == null ? 0 : listNewReq.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              listNewReq[index]['suppliername'],
                              style: GoogleFonts.questrial(
                                  color: HexColor('#777777'), fontSize: 18),
                            )),
                        Container(
                          margin: EdgeInsets.only(bottom: 3, right: 8,top: 5),
                          child: Text(listNewReq[index]['status'],
                              style: GoogleFonts.raleway(
                                  color: HexColor('#2B748D'),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25, left: 10),
                          child: Text(
                            listNewReq[index]['supplierrating'] + ' Rating',
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
                                  String supplierid = listNewReq[index]['supplierid'];
                                  String rating= listNewReq[index]['supplierrating'];
                                  print('I am Supplier'+supplierid);
                                  return Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                          new NewRequestViewScreen(requestid,supplierid,rating)));
                                }
                              }),
                        )
                      ],
                    ),
                    Divider(
                      color: HexColor('#B1B1B1'),
                    )
                  ],
                );
              });
        }
      else{
        return Center(child: Text('No records found'),);
      }

    } else {
      {
        if(listAwarded.length>0)
          {
            return ListView.builder(
                itemCount: listAwarded == null ? 0 : listAwarded.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 15, left: 10,),
                              child: Text(
                                listAwarded[index]['suppliername'],
                                style: GoogleFonts.questrial(
                                    color: HexColor('#777777'), fontSize: 18),
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 5, right: 8,top: 4),
                            child: Text(listAwarded[index]['status'],
                                style: GoogleFonts.raleway(
                                    color: HexColor('#2B748D'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 25, left: 10),
                            child: Text(
                              listAwarded[index]['supplierrating'] + ' Rating',
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
                                    String supplierid = listAwarded[index]['supplierid'];
                                    String rating= listAwarded[index]['supplierrating'];
                                    return Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                            new NewRequestViewScreen(
                                                requestid,supplierid,rating)));
                                  }
                                }),
                          )
                        ],
                      ),
                      Divider(
                        color: HexColor('#B1B1B1'),
                      )
                    ],
                  );
                });
          }
        else{
          return Center(child: Text('No records found'),);
        }
      }
    }
  }
}
