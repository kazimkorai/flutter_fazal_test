import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/user_flow_screens/register_establishment_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../weview_screen.dart';

class BuyCreditsScreen extends StatefulWidget {
  @override
  _BuyCreditsScreenState createState() => _BuyCreditsScreenState();
}

class _BuyCreditsScreenState extends State<BuyCreditsScreen> {
  List<dynamic> listOfCredits = List();

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> getListOfCredits() async {
    final response = await http
        .get('https://shoutout.arcticapps.dev/admin/api/listedcredits');
    var responceJson = json.decode(response.body);
    listOfCredits = responceJson['detail'];
    return listOfCredits;
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
            builder: (context) => Column(
              children: [
                Flexible(

                  flex: 10,
                  child: FutureBuilder<List<dynamic>>(
                      future: getListOfCredits(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return getWidgetsBody();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getWidgetsBody() {
    return ListView.builder(
        itemCount: listOfCredits.length,
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
                        listOfCredits[index]['credits'] + ' Credits',
                        style: GoogleFonts.josefinSans(
                            color: HexColor('#232323'),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      'R' + listOfCredits[index]['creditprice'],
                      style: GoogleFonts.questrial(
                          color: HexColor('#777777'), fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, top: 10, bottom: 8),
                    width: 65,
                    height: 30,
                    child: RaisedButton(
                        child: Text(

                          'Buy',
                          style: GoogleFonts.josefinSans(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        color: HexColor('#2B748D'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: HexColor('#2B748D'))),
                        onPressed: () {
                          {

                            BuyCredits(listOfCredits[index]['recordid']);


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

  BuyCredits(String creditId) async {
    ShowLoadingDialog.showAlertDialog(context);
    SharedPreferences pref=await SharedPreferences.getInstance();
    String userid=pref.getString('userid');
    String myurl = ApiUrls.BASE_API_URL+'buycredits';
    http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      'userid': userid,
      'creditid':creditId,
    }).then((response) {
      Navigator.pop(context);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];

      String merchant_id=jsArray['payfast_data']['merchant_id'];
      String merchant_key=jsArray['payfast_data']['merchant_key'];
      String  return_url=jsArray['payfast_data']['return_url'];
      String   cancel_url=jsArray['payfast_data']['cancel_url'];
      String  notify_url=jsArray['payfast_data']['notify_url'];
      String   name_first=jsArray['payfast_data']['name_first'];
      String name_last=jsArray['payfast_data']['name_last'];

      String email_address=jsArray['payfast_data']['email_address'];


      print('*email'+email_address.toString()+'');

      String  m_payment_id=jsArray['payfast_data']['m_payment_id'].toString();
      String   amount=jsArray['payfast_data']['amount'];
      String  item_name=jsArray['payfast_data']['item_name'];
      String  item_description=jsArray['payfast_data']['item_description'];
      String  custom_int1=jsArray['payfast_data']['custom_int1'];
      String  custom_int2=jsArray['payfast_data']['custom_int2'];
      String  payment_method=jsArray['payfast_data']['payment_method'];
      String    signature=jsArray['payfast_data']['signature'];
      print(status);

      String url='https://shoutout.arcticapps.dev/admin/api/credit_webview?merchant_id=$merchant_id &merchant_key=$merchant_key &return_url=$return_url&cancel_url=$cancel_url &notify_url=$notify_url &name_first=$name_first &name_last=$name_last &email_address=$email_address&m_payment_id=$m_payment_id&amount=$amount&item_name=$item_name&item_description=$item_description&custom_int1=$custom_int1&custom_int2=$custom_int2&payment_method=$payment_method&signature=$signature';

print("******"+url);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog.con(
                "Hello !",
                status,
                "CONTINUE",
                ShopCreditWebView(url));
          });
    });
  }
}
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return CustomDialog.con(
// "Hello !",
// "Your password has been Updated successfully!",
// "CONTINUE",
// LoginScreen());
// });