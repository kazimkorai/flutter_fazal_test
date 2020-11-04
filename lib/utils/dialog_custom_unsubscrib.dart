import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_dialog.dart';
import 'package:http/http.dart' as http;


class CustomDialogUnsubscribe extends StatefulWidget {
  @override
  _CustomDialogSidesState createState() => _CustomDialogSidesState();


}

class _CustomDialogSidesState extends State<CustomDialogUnsubscribe> {
  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        height: 300,
        child: Column(

          // To make the card compact
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Text(
                'Oh No!',
                style: GoogleFonts.josefinSans(
                    color: HexColor('#232323'),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 30),
              child: Text(
                'Are you sure you want to unsubscribe from ShoutOut?',
                style: GoogleFonts.questrial(
                    fontSize: 17, color: HexColor('#777777')),
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20, top: 40),
              child: RaisedButton(
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: HexColor('#2B748D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor('#2B748D'))),
                  onPressed: () {
                    {
                      unSubScribeUser();
                    }
                  }),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: RaisedButton(
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: HexColor('#48484A'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor('#48484A'))),
                  onPressed: () {
                    {
                      Navigator.pop(context);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }


  unSubScribeUser() async {

    SharedPreferences pref=await SharedPreferences.getInstance();
    String userid=pref.getString('userid');

    ShowLoadingDialog.showAlertDialog(context);
    final response = await http
        .get(
        'https://shoutout.arcticapps.dev/admin/api/unsubscribeuser?userid=${userid}');
    var responceJson = json.decode(response.body);
    if (responceJson['message'] == 'User unsubscribed.') {
      Navigator.pop(context);
      return Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: SplashScreen()));

    } else {
      throw Exception('Failed to load album');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
