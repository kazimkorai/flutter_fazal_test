import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/pojo/login_datamodel/login_data_model.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/create_new_account.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_otp_for_forgot_password.dart';
import 'input_otp_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:get/get.dart';
class VerifyPhoneNoScreen extends StatefulWidget {


  @override
  _VerifyPhoneNoScreen createState() => _VerifyPhoneNoScreen();
}

class _VerifyPhoneNoScreen extends State<VerifyPhoneNoScreen> {
  var controller=Get.put(GetXVariavleConteroller());
  bool isErrorPhone = false;
  String hintErrorPhone = '289 92920 00';
  String countryDialer = '+27';

  Color errorColorforPhone(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForPhone(bool isError) {
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

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: CreateNewAccountScreen()));
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
                      return Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: CreateNewAccountScreen()));
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
                  child: Text(
                    'Step 2',
                    style: TextStyle(color: Colors.white),
                  ),
                  margin: EdgeInsets.only(top: 16, left: 16),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 16),
                  child: Text(
                    'Verify Phone\nNumber',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 16),
                  child: Text(
                    'We have sent you an SMS with a code \nto number',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 2),
                        child: CountryCodePicker(
                          onInit: (code) => print(
                            controller.defualtDialerCode.value=code.code
                              ),
                          flagWidth: 24,
                          onChanged: (code) {
                            setState(() {
                              controller.defualtDialerCode.value=code.code;
                              countryDialer = code.dialCode;
                              print('**fromOnchanged==>' + countryDialer);
                            });
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: controller.defualtDialerCode.value,
                          favorite: ['+39', 'FR'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                      Expanded(

                        flex: 2,
                        child: Form(
                          key: _formKey,
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                              ],
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isErrorPhone = true;
                                    hintErrorPhone = 'Invalid phone entered';
                                    controller.textEditingControllerPhone.value.text = '';
                                  });
                                  return '';
                                }
                                return null;
                              },
                              controller: controller.textEditingControllerPhone.value,


                              onEditingComplete: (){

                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                   errorStyle: TextStyle(height: 0),
                                  suffixIcon: getErrorIconForPhone(isErrorPhone),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  filled: true,
                                  hintStyle: GoogleFonts.questrial(
                                      color: errorColorforPhone(isErrorPhone)),
                                  hintText: hintErrorPhone,
                                  fillColor: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: RaisedButton(

                      child: Text(
                        'NEXT',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: HexColor('#2B748D'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#2B748D'))),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          ConstantsVariable.phone = countryDialer+controller.textEditingControllerPhone.value.text;

                          getOtp('+923165199609');
                        }
                      }),
                ),
              ],
            ),
          )),
    );
  }

  getOtp(String phonenumber) async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString('tempphone', phonenumber);
    ShowLoadingDialog.showAlertDialog(context);
    String otpUrl =
        ApiUrls.BASE_API_URL+'sendrandomnumberviatwilio';
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
        showDialog(context: context,builder: (BuildContext context){

          return    CustomDialog.con('Request Sent','OTP code has been sent to your phone','CONTINUE',InputOtpScreen());

        });

      }
    });

  }
}
