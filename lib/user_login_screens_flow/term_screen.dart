import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold%20.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';

import 'login_screen.dart';

class TermScreen extends StatefulWidget {
  @override
  _TermScreen createState() => _TermScreen();
}

class _TermScreen extends State<TermScreen> {
  @override
  Widget build(BuildContext context) {

    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;

    return WillPopScope(onWillPop: (){
      return Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight, child: HomeScreen()));
    },child: MaterialApp(

        debugShowCheckedModeBanner: false,
        home: Material(
          color: HexColor('#454547'),
          child: Scaffold(
            backgroundColor:HexColor('#454547') ,
              appBar: UserTopMenuWithBack(),
              drawer: MyCustomScaffold.getDrawer(context),
            body: Container(
              color:  HexColor('#454547'),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    height: 220,
                    width: 220,
                    child: Image.asset('assets/images/ic_shout_out.png'),
                  ),
                  Container(
                    child: Text(
                      'Terms',
                      style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    margin: EdgeInsets.only(top: 12, left: 30,right: 28),
                  ),
                  Container(
                    child: Text(
                      ConstantsVariable.termsandcondition,
                      style: GoogleFonts.questrial(color: Colors.white),
                    ),
                    margin: EdgeInsets.only(top: 20, left: 28, right: 25),
                  )
                  ,Container(margin: EdgeInsets.only(top: 10),)
                ],
              ),
            ),
          ),
        )),);
  }
}
