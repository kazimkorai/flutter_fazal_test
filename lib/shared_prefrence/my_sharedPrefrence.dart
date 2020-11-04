import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefrence {

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static setCreateAccountData( String name,String useremail,String password) async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('name', name);
    prefs.setString('useremail', useremail);
    prefs.setString('password', password);
  }
  static setLoginUserDataPrefrence(
      String userid,
      String name,
      String useremail,
      String phone,
      String province,
      String isSupplier,
      String credits,
      String thumbnailimage) async {

    SharedPreferences prefs =await SharedPreferences.getInstance();

    prefs.setString('userid', userid);
    prefs.setString('name', name);
    prefs.setString('useremail', useremail);
    prefs.setString('phone', phone);
    prefs.setString('province', province);
    prefs.setString('isSupplier', isSupplier);
    prefs.setString('credits', credits);
    prefs.setString('thumbnailimage', thumbnailimage);
    print("***userid" + prefs.get('userid'));
  }

  void init() {}
}
