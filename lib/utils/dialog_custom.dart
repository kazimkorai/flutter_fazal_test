import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';

String titleA, descA, btnTextA;
Widget widgetA;

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogSidesState createState() => _CustomDialogSidesState();

  CustomDialog.con(String title, String desc, String btnText, Widget widget) {
    titleA = title;
    descA = desc;
    widgetA = widget;
    btnTextA = btnText;
  }
}

class _CustomDialogSidesState extends State<CustomDialog> {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // To make the card compact
          children: <Widget>[
            Container(
              child: Text(
                titleA,
                style: GoogleFonts.josefinSans(
                    color: HexColor('#232323'),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                descA,
                style: GoogleFonts.questrial(
                    fontSize: 18, color: HexColor('#777777')),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: RaisedButton(
                  child: Text(
                    btnTextA,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: HexColor('#2B748D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor('#2B748D'))),
                  onPressed: () {
                    {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: widgetA));
                    }
                  }),
            )
          ],
        ),
      ),
    );
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
