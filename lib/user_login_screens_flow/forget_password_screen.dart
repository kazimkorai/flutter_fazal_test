import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/input_otp_for_forgot_password.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/login_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/update_password_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreen createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends State<ForgetPasswordScreen> {
  var _textEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isErrorEmail = false;
  String hintErrorEmail = 'EMAIL';
  Color errorColorforEmail(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForEmail(bool isError) {
    if (isError) {
      return Container(
        height: 12,
        width: 12,
        child: Image.asset(
          'assets/images/ic_error_text.png',
          height: 12,
          width: 12,
        ),
      );
    } else {
      return Icon(
        Icons.description,
        size: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight, child: LoginScreen()));
        },
        child: Material(
            child: Container(
          color: HexColor('#454547'),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: LoginScreen()));
                  },
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
                margin: EdgeInsets.only(top: 45, left: 12),
                child: Text(
                  'Forgot\nPassword?',
                  style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                child: Text(
                  'Enter your email address and will send your instruction on how to reset it',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Form(
                key: _formKey,
                child:  Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _textEmail,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).nextFocus(),
                    style: TextStyle(),
                    onTap: () {
                      setState(() {
                        if (isErrorEmail) {
                          //  _textEmail.text = '';
                        }
                        isErrorEmail = false;
                        errorColorforEmail(isErrorEmail);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isErrorEmail = true;
                          hintErrorEmail = 'Invalid email entered';
                          _textEmail.text = '';
                        });
                        //    _textEmail.text = 'Please Enter Email';

                        return '';
                      } else if (!EmailValidator.validate(value)) {
                        // _textEmail.text = 'Invalid Email';
                        setState(() {
                          isErrorEmail = true;
                          hintErrorEmail = 'Invalid email entered';
                          _textEmail.text = '';
                        });
                        return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#2B748D'), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: getErrorIconForEmail(isErrorEmail),
                        errorStyle: TextStyle(height: 0),
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: GoogleFonts.questrial(
                            color: errorColorforEmail(isErrorEmail)),
                        hintText: hintErrorEmail,
                        fillColor: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: RaisedButton(
                    child: Text(
                      'SEND NOW',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: HexColor('#2B748D'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: HexColor('#2B748D'))),
                    onPressed: () {
                      {
                        if (_formKey.currentState.validate()) {

                        return  ForgotPassword(_textEmail.text);

                        }
                      }
                    }),
              ),
            ],
          ),
        )));
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

  ForgotPassword(String email) async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString('tempemail', email);
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
}


