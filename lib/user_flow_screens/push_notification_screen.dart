import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:flutter_fazal_test/supllier_flow/awarded_request_view_supplier.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_for_job.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_view.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class PushNotificationScreen extends StatefulWidget {
  @override
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  String isSupplier = '';

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
            builder: (context) => FutureBuilder<List<dynamic>>(
                future: fetchingPushNotification(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length == null
                            ? 0
                            : snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return GestureDetector(
                            onTap: () {
                              print('***ToSupplier'+snapshot.data[index]['to_supplier']);
                              if (snapshot.data[index]['to_supplier'] == '1') {
                                return Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SupplierNewRequestScreen()));
                              } else {
                                return Navigator.pushReplacement(
                                    context,
                                    PageTransition(type: PageTransitionType.rightToLeft,
                                        child: InboxScreen()));
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 10, right: 20),
                                            child: Text(
                                              snapshot.data[index]
                                                  ['jobdescription'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.questrial(
                                                  color: HexColor('#777777'),
                                                  fontSize: 18),
                                            )),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 4, right: 8),
                                          child: Text(
                                              _printDuration(Duration(
                                                  seconds: int.parse(snapshot
                                                      .data[index]['diff']))),
                                              style: GoogleFonts.questrial(
                                                  color: HexColor('#2B748D'),
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 15, left: 10, bottom: 8),
                                      child: Text(
                                        snapshot.data[index]['message'],
                                        style: GoogleFonts.questrial(
                                            color: HexColor('#2B748D'),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: HexColor('#B1B1B1'),
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  Future<List<dynamic>> fetchingPushNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.get('userid');
    final response = await http.get('https://shoutout.arcticapps.dev/admin/api/pushnotificationlist?userid=${userid}');
    print(response.body);
    var jsArray = json.decode(response.body);
    print(jsArray['detail'].toString());
    return jsArray['detail'].reversed.toList();
  }
}
