import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fazal_test/user_flow_screens/push_notification_screen.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';

class UserTopMenuWithBack extends StatelessWidget implements PreferredSize {
  final double height = 80;
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // alignment: Alignment.center,
        height: height,
        decoration: BoxDecoration(
          color: HexColor('#454547'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  margin: EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Image.asset('assets/images/ic_menu.png'),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: Text(
                      'ShoutOut',
                      style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PushNotificationScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 0, right: 10),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () {
                  print('I clicked');
                 return GenericClasses.gotoOtherpushReplacement(
                      GenericClasses.context, GenericClasses.WidgetScreen);
                },
                child: Row(
                  children: [
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
