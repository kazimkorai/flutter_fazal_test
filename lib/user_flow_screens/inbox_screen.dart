import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_for_job.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'package:http/http.dart' as http;

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<dynamic> listIems;
  Future<List<dynamic>> fetchInbox() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userid = sharedPreferences.get('userid');
    final response = await http.get(ApiUrls.BASE_API_URL + 'customerinbox?userid=${userid}');
    var responceJson = json.decode(response.body);
    listIems=responceJson['data'];
    print(response.body);
    print(userid);
    if (responceJson['status']) {
      return responceJson['data'].reversed.toList();
    } else {
      print('**===> No data found');
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => FutureBuilder<List<dynamic>>(
              future: fetchInbox(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                return  getBody(snapshot);


                }
                else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody(AsyncSnapshot snapshot)
  {
    if(listIems.length>0)
      {
      return  ListView.builder(
            itemCount: snapshot.data.length == null
                ? 0
                : snapshot.data.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 10, right: 150),
                      child: Text(
                        snapshot.data[index]['jobdescription'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.questrial(
                            color: HexColor('#777777'), fontSize: 18),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                            EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              snapshot.data[index]['jobcategory'],
                              style: GoogleFonts.questrial(
                                  color: HexColor('#2B748D'),
                                  fontSize: 18),
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              snapshot.data[index]['jobdate'],
                              style: GoogleFonts.questrial(
                                  color: HexColor('#2B748D'),
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            snapshot.data[index]['status'],
                            style: GoogleFonts.questrial(
                                color: HexColor('#000000'),
                                fontSize: 12),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 7),
                              child: Text(
                                snapshot.data[index]
                                ['interestedsuppliers'] +
                                    " Available",
                                style: GoogleFonts.questrial(
                                    color: HexColor('#000000'),
                                    fontSize: 12),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                left: 5, top: 10, right: 6),
                            height: 28,
                            child: RaisedButton(
                                child: Text(
                                  'View Suppliers',
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                color: HexColor('#2B748D'),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: HexColor('#2B748D'))),
                                onPressed: () {
                                  {
                                    String requestid= snapshot.data[index]['requestid'];
                                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewRequestForJob(requestid)));
                                    //

                                  }
                                }),
                          )
                        ],
                      ),
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
