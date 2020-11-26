import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/update_password_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/forget_password_screen.dart';

import 'package:flutter_fazal_test/user_login_screens_flow/login_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/verify_phone_no_screen.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class InputOtpForgotPasswordScreen extends StatefulWidget {
  @override
  _InputOtpScreen createState() => _InputOtpScreen();
}

class _InputOtpScreen extends State<InputOtpForgotPasswordScreen> {
  TextEditingController PinFieldAutoFillController = TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: ForgetPasswordScreen()));
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
                        child: ForgetPasswordScreen()));
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
                'Account\nVerification',
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
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Form(

                  child: PinFieldAutoFill(
                    decoration: _pinDecoration,
                    controller: PinFieldAutoFillController,
                    codeLength: 5,
                    // prefill with a code
                  ),
                ),
              ),
            ),
           Container(margin: EdgeInsets.only(top: 20),),
           InkWell(onTap: (){
             didNotRecivedAnyCode();
           },child:  Container(
             alignment: Alignment.topLeft,
             margin: EdgeInsets.only(top: 0, left: 30),
             child: Text(
               "I didn't receive any code",
               style: GoogleFonts.questrial(color: Colors.white),
             ),
           ),),
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
                    //  CreateAccount();
                    if (ConstantsVariable.randomeOTPforForgotPass.toString() ==
                        PinFieldAutoFillController.text) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: UpdatePasswordScreen()));
                    } else {
                      print('Otp Not match');
                      Fluttertoast.showToast(
                          msg: "You enter invalid OTP",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  }),
            ),
          ],
        ),
      )),
    );
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
      SharedPreferences pref=await SharedPreferences.getInstance();
    String email=  pref.getString('tempemail');
      ShowLoadingDialog.showAlertDialog(context);
      String myurl = ApiUrls.BASE_API_URL+"forgetpassword";
      http.post(myurl, headers: {
        'Accept': 'application/json',
      }, body: {
        "email": email,

      }).then((response) {
        print(response.statusCode);
        print(response.body);

        var jsArray = json.decode(response.body);
        String message = jsArray['message'];

        if (message == 'Email not exist') {
          Navigator.pop(context);
          DialogNotFound(context, 'Email not exist');
          new Future.delayed(new Duration(seconds: 2), () {
            Navigator.pop(context);
          });

        }

        if (message == 'Activation code send.') {
          Navigator.pop(context);
          showDialog(context: context,builder: (BuildContext context){
            ConstantsVariable.randomeOTPforForgotPass=jsArray['randomlink'];
            return    CustomDialog.con('Request Sent','OTP code has been sent to your phone','CONTINUE',InputOtpForgotPasswordScreen());

          });

          print('***status==>' + message);
          print('I am here');
          // return Navigator.pushReplacement(
          //      context,
          //      PageTransition(
          //          type: PageTransitionType.rightToLeft,
          //          child: InputOtpForgotPasswordScreen()));
        }
      });
    }
  DialogNotFound(BuildContext context,String message) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text(message)),
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

}
