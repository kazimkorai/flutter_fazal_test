import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_flow_screens/edit_establishment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_fazal_test/supllier_flow/buy_credits_screen.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/edit_profile_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/register_establishment_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/request_supplier.dart';
import 'package:flutter_fazal_test/user_flow_screens/single_establishment_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/about_us_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/contact_us_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/splash_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/term_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/update_password_screen.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'dialog_custom.dart';
import 'dialog_custom_unsubscrib.dart';
import 'loading_dialog.dart';
import 'package:http/http.dart' as http;

class MyCustomScaffold {
  static BuildContext _context;
  static Widget inboxSupplierWidget;
  static Widget getDrawer(BuildContext context) {
    _context = context;
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 45),
      child: Drawer(
        child: Container(
          color: HexColor('#454547'),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(children: [Align(child: Container(
                margin: EdgeInsets.only(right: 10, top: 20),
                child: getCredits(),
              ),alignment: Alignment.topRight,),
                Row(
                  children: [
                    Container(
                      width: 65.0,
                      height: 65.0,
                      margin: EdgeInsets.only(left: 10),
                      child: CachedNetworkImage(
                        imageUrl: ConstantsVariable.profileImage,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 65.0,
                          height: 65.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 14, top: 40),
                              child: Text(
                                ConstantsVariable.userName,
                                style: GoogleFonts.josefinSans(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 14, top: 5),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: EditProfileScreen()));
                            },
                            color: Colors.white,
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(color: Colors.black),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                        )
                      ],
                    ),

                    Row(
                      children: [

                      ],
                    )
                  ],
                ),
              ],),


              Divider(
                color: Colors.white,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HomeScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8, top: 20),
                    child: Text(
                      'Home',
                      style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              InkWell(
                onTap: () async {
                  SharedPreferences sharedPrefrence =
                  await SharedPreferences.getInstance();
                  print(sharedPrefrence.get('isSupplier').toString());
                  print(sharedPrefrence.get('userid').toString());
                  String is_supplier =
                      sharedPrefrence.get('isSupplier').toString();
                  if (is_supplier == '0') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog.con(
                              'ADD ESTABLISHMENT',
                              'You have not created establishment yet, would you like to create one now?',
                              'CONTINUE',
                              RegisterEstablishmentScreen());
                        });
                  } else if (is_supplier == '1') {
                    return Navigator.pushReplacement(
                        _context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EditEstablishmentScreen()));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'My Establishment',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: RequestSupplier()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'Request Supplier',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
               getWidgetForIsSupplier(context,ConstantsVariable.isSupplier),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InboxScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    ConstantsVariable.InboxTittle,
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushReplacement(
              //         context,
              //         PageTransition(
              //             type: PageTransitionType.rightToLeft,
              //             child: InboxScreen()));
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(left: 8, top: 20),
              //     child: Text(
              //       'Customer Inbox',
              //       style: GoogleFonts.josefinSans(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: AboutUsScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'About Us',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: TermScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'Terms & Conditions',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ContactUsScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'Contact Us',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: BuyCreditsScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    'Buy Credits',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, top: 70),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogUnsubscribe();
                        });
                  },
                  child: Text(
                    'Unsubscribe',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  ShowLoadingDialog.showAlertDialog(context);
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.clear();
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  String userid = sharedPreferences.get('userid');
                  final response = await http.get('https://shoutout.arcticapps.dev/admin/api/logout?userid=${userid}');
                  var responceJson = json.decode(response.body);
                  Navigator.pop(context);
                  print(responceJson);
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: MyAppSplash()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, top: 20, bottom: 20),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  userEstablishment() async {
    SharedPreferences sharedPrefrence = await SharedPreferences.getInstance();
    ShowLoadingDialog.showAlertDialog(_context);
    String myurl = "https://shoutout.arcticapps.dev/admin/api/login";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      "id": sharedPrefrence.get('userid'),
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String is_supplier = jsArray['detail'];
      Navigator.pop(_context);
      if (is_supplier == '0') {
        CustomDialog.con(
            'ADD ESTABLISHMENT',
            'You have not created establishment yet, would you like to create one now?',
            'CONTINUE',
            BuyCreditsScreen());
      } else if (is_supplier == '1') {
        Navigator.pushReplacement(
            _context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: HomeScreen()));
      }
    });
  }


static  getWidgetForIsSupplier(BuildContext context,String isSupplier)
  {
    if(isSupplier=='1')
      {
        return  InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: SupplierNewRequestScreen()));
          },
          child: Container(
            margin: EdgeInsets.only(left: 8, top: 20),
            child: Text(
              'Supplier Inbox',
              style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    else{

      return Text('');
    }
  }



static getCredits()
  {

    if(ConstantsVariable.isSupplier=='1')
      {
        ConstantsVariable.InboxTittle='Customer Inbox';
        return Text(
          ConstantsVariable.credits.toString()+' CR',
          style: GoogleFonts.josefinSans(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        );
      }
    else{
      ConstantsVariable.InboxTittle='Inbox';
      Text('');
    }
  }


}
