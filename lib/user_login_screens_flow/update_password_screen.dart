import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_login_screens_flow/forget_password_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/login_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreen createState() => _UpdatePasswordScreen();
}

class _UpdatePasswordScreen extends State<UpdatePasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  var _textPassword = TextEditingController();
  var _textConfirmPassword = TextEditingController();

  bool isErrorMaskPassword = true;
  bool isErrorMaskConfrm = true;
  bool isErrorPassword = false;
  bool isErrorPasswordConfirm = false;
  bool isErrorMask=true ;


  String hintErrorPassword = 'PASSWORD';
  String hintErrorConfirmdPassword='CONFIRM PASSWORD';

  Color errorColorforPassword(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForPassword(bool isError) {
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

  Color errorColorforConfirmPassword(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForConfirmdPassword(bool isError) {
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

  void passwordUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('title'),
          content: Text('content'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: LoginScreen()));
      },
      child: Material(
          child: Container(
        color: HexColor('#454547'),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: LoginScreen()));
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
              child: Text(
                'Update your\nPassword?',
                style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 45, left: 12),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Text(
                'Please Enter your new password',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: _textPassword,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      style: TextStyle(),
                      onTap: () {
                        setState(() {
                          if (isErrorPassword) {
                            //  _textEmail.text = '';
                          }
                          isErrorPassword = false;
                          errorColorforPassword(isErrorPassword);
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isErrorPassword = true;
                            hintErrorPassword = 'Invalid password entered';
                            _textPassword.text = '';
                          });
                          //    _textEmail.text = 'Please Enter Email';

                          return '';
                        }
                        else if(value.length<=5)
                        {
                          isErrorPassword = true;
                          hintErrorPassword = 'Must be six character';
                          _textPassword.text = '';
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
                          suffixIcon:
                          getErrorIconForPassword(isErrorPassword),
                          errorStyle: TextStyle(height: 0),
                          contentPadding: EdgeInsets.only(left: 15),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: GoogleFonts.questrial(color: errorColorforPassword(isErrorPassword)),
                          hintText: hintErrorPassword,
                          fillColor: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: _textConfirmPassword,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      style: TextStyle(),
                      onTap: () {
                        setState(() {


                          isErrorPasswordConfirm = false;
                          errorColorforConfirmPassword(isErrorPasswordConfirm);
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isErrorPasswordConfirm = true;
                            hintErrorConfirmdPassword = 'Invalid password entered';
                            _textConfirmPassword.text = '';
                          });
                          //    _textEmail.text = 'Please Enter Email';
                        }
                        else if(value.length<=5)
                          {
                            isErrorPasswordConfirm = true;
                            hintErrorConfirmdPassword = 'Must be six character';
                            _textConfirmPassword.text = '';
                          }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('#2B748D'), width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          suffixIcon:
                          getErrorIconForConfirmdPassword(isErrorPasswordConfirm),
                          errorStyle: TextStyle(height: 0),
                          contentPadding: EdgeInsets.only(left: 15),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: GoogleFonts.questrial(color: errorColorforConfirmPassword(isErrorPasswordConfirm)),
                          hintText: hintErrorConfirmdPassword,
                          fillColor: Colors.white),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RaisedButton(
                        child: Text(
                          'RESET PASSWORD',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: HexColor('#2B748D'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: HexColor('#2B748D'))),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if(_textConfirmPassword.text!=_textPassword.text)
                            {
                              Fluttertoast.showToast(
                                  msg: "Password and confirmed are not equal",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            else{

                              updatePassword();
                            }


                          }
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  updatePassword() async {
    ShowLoadingDialog.showAlertDialog(context);
    String myurl = ApiUrls.BASE_API_URL+'updatepassword';
    http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      'newpassword': _textPassword.text,
      'randomnumber': ConstantsVariable.randomeOTPforForgotPass.toString(),
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];
      print(status);
      if (status == 'Password changed') {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  "Hello !",
                  "Your password has been Updated successfully!",
                  "CONTINUE",
                  LoginScreen());
            });
      } else  {

        new Future.delayed(new Duration(seconds: 3), () {

        });
      }
    });
  }
}
