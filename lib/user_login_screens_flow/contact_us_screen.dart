import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold%20.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'package:http/http.dart' as http;

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreen createState() => _ContactUsScreen();
}

class _ContactUsScreen extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textTittle = new TextEditingController();
  TextEditingController _textDesc = new TextEditingController();




  contactUs() async {

    ShowLoadingDialog.showAlertDialog(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.get('userid');
    String myurl = ApiUrls.BASE_API_URL + "contactus";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      "title": _textTittle.text,
      "message": _textDesc.text,
      "userid": userid
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      print(jsArray.toString());

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog.con(
                'CONGRATULATIONS!',
                'Message sent successfully ',
                'Continue',
                HomeScreen());
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Material(
            child: Scaffold(
              backgroundColor: HexColor('#454547'),
              appBar: UserTopMenuWithBack(),
              drawer: MyCustomScaffold.getDrawer(context),
              body: Container(
                color: HexColor('#454547'),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      height: 220,
                      width: 220,
                      child: Image.asset('assets/images/ic_shout_out.png'),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              controller: _textTittle,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title required';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintText: 'Title',
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                            margin:
                                EdgeInsets.only(top: 12, left: 30, right: 28),
                          ),
                          Container(
                            child: TextFormField(
                              controller: _textDesc,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Description Required';
                                }
                                return null;
                              },
                              maxLines: 7,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: "Description",
                                  fillColor: Colors.white),
                            ),
                            margin:
                                EdgeInsets.only(top: 20, left: 28, right: 25),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 18),
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          child: Text(
                            'CONTINUE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: HexColor('#2B748D'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: HexColor('#2B748D'))),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {

                              contactUs();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
