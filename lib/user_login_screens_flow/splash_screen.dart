import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email','pages_show_list']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Material(
            child: Center(
              child: Container(
                  color: HexColor("#2e2f31"),
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: Text('')),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 200,
                          width: 200,
                          child: Image.asset('assets/images/ic_shout_out.png'),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: 50,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 60),
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: HexColor('#2b748d'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: HexColor('#2b748d'))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: LoginScreen()));
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '-or-',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              height: 50,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 8),
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'SIGN WITH  ',
                                        style: TextStyle(
                                            color: HexColor('#ffffff')),
                                      ),
                                      Image.asset(
                                        'assets/images/ic_fb.png',
                                        height: 14,
                                        width: 14,
                                      ),
                                      Text(
                                        '  FACEBOOK',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  color: HexColor('#0075f8'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(/*color: colorSignin*/)),
                                  onPressed: () {


                                    _login();
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          )),
    );
  }


}
