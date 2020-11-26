import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:get/get.dart';
import 'package:flutter_fazal_test/user_flow_screens/push_notification_screen.dart';

import 'package:flutter_fazal_test/utils/page_transition.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
class UserTopMenu extends StatelessWidget implements PreferredSize {
  Function onEditingComplete;
  UserTopMenu(this._searchingController,this.onEditingComplete);
  TextEditingController _searchingController = TextEditingController();
  final double height = 70;
   var controller=Get.put(GetXVariavleConteroller());
  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // alignment: Alignment.center,
        height: height,
        decoration: BoxDecoration(
          color: HexColor('#47484a'),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                height: 24,
                width: 24,
                margin: EdgeInsets.only(left: 10),
                child: Image.asset('assets/images/ic_menu.png'),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 8),
                height: 40,
                child: TextField(
                  controller: _searchingController,

                  onChanged: onEditingComplete,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 10),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(45.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: Colors.grey),
                      hintText: "What are you looking for?",
                      fillColor: Colors.white),
                ),
              ),
            ),


            GetX<GetXVariavleConteroller>(
                builder: (controller) => Container(
                  margin: EdgeInsets.only(top: 5, right: 10),
                  child:   Row(children: [InkWell(
                    onTap: () {
                      controller.notificationCount.clear();
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: PushNotificationScreen()));
                    },
                    child:  new Stack(
                      children: <Widget>[
                        new Icon(Icons.notifications,color: Colors.white,),
                        new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              controller.getCount().toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),

                  ),],),
                ))
          ,
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
