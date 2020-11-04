import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';

class UserTopMenu extends StatelessWidget implements PreferredSize {
  final double height = 90;
  TextEditingController _editingController = TextEditingController();

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
            Container(
              height: 18,
              width: 18,
              margin: EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset('assets/images/ic_menu.png'),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 8),
                height: 40,
                child: TextField(
                  onEditingComplete: (){
                    print(_editingController.toString());
                  },
                  controller: _editingController,
                  onChanged: (value) {
                    print(value);
                  },
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
            Container(
              margin: EdgeInsets.only(left: 0, right: 10),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
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
