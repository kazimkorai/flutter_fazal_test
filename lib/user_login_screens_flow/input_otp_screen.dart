import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';

import 'package:flutter_fazal_test/user_login_screens_flow/login_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/verify_phone_no_screen.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class InputOtpScreen extends StatefulWidget {
  @override
  _InputOtpScreen createState() => _InputOtpScreen();
}

class _InputOtpScreen extends State<InputOtpScreen> {
  TextEditingController pinAutoFill = TextEditingController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String firebaseToken = '';
  PinDecoration _pinDecoration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _pinDecoration = UnderlineDecoration(
        textStyle: TextStyle(color: Colors.white,fontSize: 20),
          colorBuilder: PinListenColorBuilder(Colors.white, Colors.white),
          obscureStyle: ObscureStyle(

          ));
    });
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: VerifyPhoneNoScreen()));
      },
      child: Material(
          child: Container(
        color: HexColor('#454547'),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                return Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: VerifyPhoneNoScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 40, left: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ic_back.png',
                      height: 18,
                      width: 18,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      child: Text(
                        'BACK',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12, top: 20),
              child: Text(
                'Step 3',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25, left: 12),
              child: Text(
                'Phone\nVerification',
                style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Text(
                'Enter your 5-digit OTP code to continue',
                style: GoogleFonts.questrial(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              width: MediaQuery.of(context).size.width,
              child: Form(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 2,right: 2),
                  child: PinFieldAutoFill(
                    currentCode: pinAutoFill.text,
                    controller: pinAutoFill,
                    decoration: _pinDecoration,
                    codeLength: 5,
                  ),
                ),

                //   child: PinFieldAutoFill(
                //
                //   controller: pinAutoFill,
                //   codeLength: 5, // prefill with a code
                // ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 20, left: 30),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: InkWell(
                onTap: () {
                  didNotRecivedAnyCode();
                },
                child: Text(
                  "I didn't receive any code",
                  style: GoogleFonts.questrial(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 25, left: 25, right: 25),
              child: RaisedButton(
                  child: Text(
                    'DONE',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: HexColor('#2B748D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: ConstantsVariable.btnloginColor)),
                  onPressed: () {
                    print(pinAutoFill.toString());
                    print(
                        ConstantsVariable.randomOtpForCreateAccount.toString());
                    if (pinAutoFill.text ==
                        ConstantsVariable.randomOtpForCreateAccount
                            .toString()) {
                      // 21109
                      print('isEqual==>true');
                      firebaseMessaging.getToken().then((token) {
                        setState(() {
                          firebaseToken = token;
                        });
                        assert(token != null);
                        print("teken is: " + token);
                      });
                      CreateAccount(firebaseToken);
                    } else {
                      Fluttertoast.showToast(
                          msg: "OTP not match",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    //

                    // Navigator.pushReplacement(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.leftToRight,
                    //         child: LoginScreen()));
                  }),
            ),
          ],
        ),
      )),
    );
  }

  CreateAccount(String firebaseToken) async {
    print(ConstantsVariable.name);
    print(ConstantsVariable.email);
    print(ConstantsVariable.password);
    print(ConstantsVariable.phone);
    String deviceid = await firebaseToken;
    ShowLoadingDialog.showAlertDialog(context);
    String myurl = ApiUrls.BASE_API_URL + 'signup';
    http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      'name': ConstantsVariable.name,
      'email': ConstantsVariable.email,
      'phone': ConstantsVariable.phone,
      'password': ConstantsVariable.password,
      'deviceid': deviceid
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];
      print(status);

      if (status == 'Signup successfully') {
        Navigator.pop(context);
        showLoaderDialog(context, 'Signup successfully');
        new Future.delayed(new Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft, child: LoginScreen()));
        });
      } else if (status == 'Email exist') {
        Navigator.pop(context);
        showLoaderDialog(context, 'Email exist');

        new Future.delayed(new Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft, child: LoginScreen()));
        });
      }
    });
  }

  showLoaderDialog(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text(message)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  didNotRecivedAnyCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String phonenumber = pref.getString('tempphone');
    ShowLoadingDialog.showAlertDialog(context);
    String otpUrl = ApiUrls.BASE_API_URL + 'sendrandomnumberviatwilio';
    http.post(otpUrl, headers: {
      'Accept': 'application/json',
    }, body: {
      'phonenumber': phonenumber
    }).then((response) {
      print(response.body);
      Navigator.pop(context);
      if (json.decode(response.body)['message'] ==
          'Passcode sent successfully') {
        ConstantsVariable.randomOtpForCreateAccount =
            json.decode(response.body)['code'];
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'Request Sent',
                  'OTP code has been sent to your phone',
                  'CONTINUE',
                  InputOtpScreen());
            });
      }
    });
  }
}
