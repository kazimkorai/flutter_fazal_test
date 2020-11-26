import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/pojo/login_datamodel/login_data_model.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/verify_phone_no_screen.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'forget_password_screen.dart';
import 'login_screen.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:get/get.dart';
class CreateNewAccountScreen extends StatefulWidget {

  @override
  _CreateNewAccountScreen createState() => _CreateNewAccountScreen();
}

class _CreateNewAccountScreen extends State<CreateNewAccountScreen> {

  var controller=Get.put(GetXVariavleConteroller());

  final _formKey = GlobalKey<FormState>();

  bool isErrorMask = true;
  bool isErrorName = false;
  bool isErrorEmail = false;
  bool isErrorPassword = false;
  String hintErrorName='NAME';
  String hintErrorEmail = 'EMAIL';
  String hintErrorPassword = 'PASSWORD';




  Color errorColorforName(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForName(bool isError) {
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

  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: LoginScreen()));
      },
      child: SafeArea(
          child: Scaffold(
            backgroundColor: HexColor('#454547'),
            body: Builder(builder: (context) => getBody()),
          )),
    );
  }

  Widget getBody()
  {
    return  ListView(
      children: [
        InkWell(
          onTap: () {
            return Navigator.pushReplacement(
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
                  width: 18,
                  height: 18,
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
            'Step 1',
            style: TextStyle(color: Colors.white),
          ),
          margin: EdgeInsets.only(top: 20, left: 15),
        ),
        Container(
          child: Text(
            'Create New\nAccount!',
            style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.only(top: 25, left: 14),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 16),
          child: Text(
            'Enter your details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(

                  controller: controller.textName.value,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).nextFocus(),
                  style: TextStyle(),
                  onTap: () {
                    setState(() {
                      if (isErrorName) {
                        //  _textEmail.text = '';
                      }
                      isErrorName = false;
                      errorColorforName(isErrorName);
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        isErrorName= true;
                        hintErrorName = 'Invalid name entered';
                        controller.textName.value.text = '';
                      });
                      //    _textEmail.text = 'Please Enter Email';

                      return '';
                    } else if ((value.length>=20)) {
                      // _textEmail.text = 'Invalid Email';
                      setState(() {
                        isErrorName = true;
                        hintErrorName = 'Maximum 20 character';
                        controller.textName.value.text = '';
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
                      suffixIcon: getErrorIconForName(isErrorName),
                      errorStyle: TextStyle(height: 0),
                      contentPadding: EdgeInsets.only(left: 15),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: GoogleFonts.questrial(
                          color: errorColorforName(isErrorName)),
                      hintText: hintErrorName,
                      fillColor: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.textEmail.value,
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
                        controller.textEmail.value.text = '';
                      });
                      //    _textEmail.text = 'Please Enter Email';

                      return '';
                    } else if (!EmailValidator.validate(value)) {
                      // _textEmail.text = 'Invalid Email';
                      setState(() {
                        isErrorEmail = true;
                        hintErrorEmail = 'Invalid email entered';
                        controller.textEmail.value.text = '';
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(
                  obscureText: true,
                  controller: controller.textPassword.value,
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
                        controller.textPassword.value.text = '';
                      });
                      //    _textEmail.text = 'Please Enter Email';
                      return '';
                    }
                    else if(value.length<=5)
                    {
                      setState(() {
                        isErrorPassword = true;
                        hintErrorPassword = 'Must be six character';
                        controller.textPassword.value.text = '';
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
                height: 50,
                margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    child: Text(
                      'NEXT',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: HexColor('#2B748D'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: HexColor('#2B748D'))),
                    onPressed: () async {

                      if (_formKey.currentState.validate()) {

                        ConstantsVariable.name=controller.textName.value.text;
                        ConstantsVariable.email=controller.textEmail.value.value.text;
                        ConstantsVariable.password=controller.textPassword.value.text;

                        // controller.userName.value=_textName.text;
                        // controller.userPassword.value=_textPassword.text;
                        // controller.userEmail.value=_textEmail.text;

                        MySharedPrefrence.setCreateAccountData(controller.textName.value.text, controller.textEmail.value.value.text, controller.textPassword.value.text);
                        checkStatus(controller.textEmail.value.value.text);

                      }
                    }),
              ),
            ],
          ),
        ),
        InkWell(onTap: (){
          return Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: LoginScreen()));

        },child:  Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already have a account? ',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Sign in',
                style: TextStyle(
                    color: HexColor('#F81C40'),
                    decoration: TextDecoration.underline),
              )
            ],
          ),
        ),),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '- or -',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Image.asset(
            'assets/images/ic_f.png',
            height: 45,
            width: 45,
          ),
        )
      ],
    ) ;
  }

  Future<bool>  checkStatus(String email) async {
    ShowLoadingDialog.showAlertDialog(context);
    final response = await http.get(ApiUrls.urlCheckEmailExist+email );
    var responceJson = json.decode(response.body);

    print(responceJson.toString());
    Navigator.pop(context);
    if(responceJson['status'])
      {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: VerifyPhoneNoScreen()));
      }
    else
      {
        Fluttertoast.showToast(
            msg: "Email already exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }

}
