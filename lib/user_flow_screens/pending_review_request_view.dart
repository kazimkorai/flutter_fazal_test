import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:rating_bar/rating_bar.dart';

class PendingReviewRequestScreen extends StatefulWidget {
  @override
  _PendingReviewRequestScreenState createState() => _PendingReviewRequestScreenState();
}

class _PendingReviewRequestScreenState extends State<PendingReviewRequestScreen> {

  final _formKey=GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => new ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'PENDING REVIEW',
                    style: GoogleFonts.raleway(
                        color: HexColor('#2B748D'),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: Text(
                    '4.5 Rating',
                    style: GoogleFonts.questrial(
                      color: HexColor('#2B748D'),
                      fontSize: 16,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                              {
                                return 'Name Required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: 'Name',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value.isEmpty)
                              {
                                return 'Telephone number Required';

                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(

                              suffixIcon: Image.asset(
                                'assets/images/ic_phon.png',
                                width: 18,
                                height: 18,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: 'Telephone number',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                              {
                                return 'Email Required';
                              }
                              else if(!EmailValidator.validate(value)){
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              suffixIcon: Container(
                                margin: EdgeInsets.only(right: 5,top: 15,bottom: 15),
                                height: 10,
                                width: 10,
                                child: Image.asset(
                                  'assets/images/ic_email.png',
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: 'Email',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty){
                                return 'Travel(Category) Required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: 'Travel (Category)',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty){
                                return 'Budget Required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: 'R5000 - R15 000',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty){
                                return 'Time Required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: '2 Weeks',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty){
                                return 'Address Required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              hintText: '22 Street, Area 51',
                            )),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            validator: (value){
                              if(value.isEmpty){
                                return 'Time Required';
                              }
                              return null;
                            },
                            maxLines: 7,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              hintText: 'Description',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1, color: HexColor("#B1B1B1")),
                              ),
                            )),
                      ),

                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: RaisedButton(
                      child: Text(
                        'GIVE REVIEW',
                        style:  GoogleFonts.josefinSans(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      color: HexColor('#2B748D'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#2B748D'))),
                      onPressed: () {
                        {
                          if(_formKey.currentState.validate())
                          {

                          }
                        }
                      }),
                ),
                Container(
                  height: 50,
                  margin:
                  EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 15),
                  child: RaisedButton(
                      child: Text(
                        'VIEW ESTABLISHMENT',
                        style: GoogleFonts.josefinSans(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: HexColor('#48484A'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#48484A'))),
                      onPressed: () {
                        {}
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
