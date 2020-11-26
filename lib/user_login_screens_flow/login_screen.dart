import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_fazal_test/CustomDialogs/CustomDialogs.dart';
import 'package:flutter_fazal_test/pojo/login_datamodel/login_data_model.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/splash_screen.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'create_new_account.dart';
import 'forget_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var controller=Get.put(GetXVariavleConteroller());
  final _formKey = GlobalKey<FormState>();
  var _textEmail = TextEditingController();
  var _textPassword = TextEditingController();
  bool isErrorEmail = false;
  bool isErrorPassword = false;
  bool isErrorMask = true;
  SharedPreferences prefs;
  // String videoURL = "https://www.youtube.com/watch?v=n8X9_MgEdCg";
  YoutubePlayerController _controller;
  String hintErrorEmail = 'EMAIL';
  String hintErrorPassword = 'PASSWORD';
  String firebaseToken = '';

  void init() async {
    prefs = await SharedPreferences.getInstance();
    fetchCMS();
    Firebase.initializeApp();
  }

  Color errorColorforEmail(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForEmail(bool isError) {
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

  Color errorColorforPassword(bool isError) {
    if (isError) {
      return Colors.red;
    } else {
      return HexColor('#777777');
    }
  }

  Widget getErrorIconForPassword(bool isError) {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight, child: SplashScreen()));
        },
        child: SafeArea(
            child: Scaffold(
              backgroundColor:HexColor('#454547'),
          body: Builder(builder: (context) => getBody()),
        )));
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 40, left: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: SplashScreen()));

                // Navigator.pop(context);
                /* Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: SplashScreen()));*/
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
            )),
        Container(
          child: Text(
            'Login to\ncontinue!',
            style: GoogleFonts.josefinSans(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.only(top: 40, left: 12),
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _textEmail,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(),
                    onTap: () {
                      setState(() {
                        if (isErrorEmail) {
                          //  _textEmail.text = '';
                        }
                        isErrorEmail = false;
                        errorColorforEmail(isErrorEmail);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isErrorEmail = true;
                          hintErrorEmail = 'Invalid email entered';
                          _textEmail.text = '';
                        });
                        //    _textEmail.text = 'Please Enter Email';

                        return '';
                      } else if (!EmailValidator.validate(value)) {
                        // _textEmail.text = 'Invalid Email';
                        setState(() {
                          isErrorEmail = true;
                          hintErrorEmail = 'Invalid email entered';
                          _textEmail.text = '';
                        });
                        return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#2B748D'), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: getErrorIconForEmail(isErrorEmail),
                        errorStyle: TextStyle(height: 0),
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: GoogleFonts.questrial(
                            color: errorColorforEmail(isErrorEmail)),
                        hintText: hintErrorEmail,
                        fillColor: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextFormField(
                    obscureText: true,
                    controller: _textPassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(),
                    onTap: () {
                      setState(() {
                        if (isErrorPassword) {
                          //  _textEmail.text = '';
                        }
                        isErrorPassword = false;
                        errorColorforPassword(isErrorPassword);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isErrorPassword = true;
                          hintErrorPassword = 'Invalid password entered';
                          _textPassword.text = '';
                        });
                        //    _textEmail.text = 'Please Enter Email';

                        return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#2B748D'), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: getErrorIconForPassword(isErrorPassword),
                        errorStyle: TextStyle(height: 0),
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: GoogleFonts.questrial(
                            color: errorColorforPassword(isErrorPassword)),
                        hintText: hintErrorPassword,
                        fillColor: Colors.white),
                  ),
                )
              ],
            )),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ForgetPasswordScreen()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password?',
                  style:
                      GoogleFonts.questrial(fontSize: 15, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: RaisedButton(
              child: Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
              color: HexColor('#2B748D'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: HexColor('#2B748D'))),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  // _firebaseMessaging.getToken().then((token) {
                  //   setState(() {
                  //     firebaseToken = token;
                  //     print(firebaseToken);
                  //   });
                  //   assert(token != null);
                  //   print("teken is: " + token);
                  // setState(() {
                  //   firebaseToken = token;
                  //   print(firebaseToken);
                  // });
                  // });
                  firebaseToken = await _firebaseMessaging.getToken();
                  if (!firebaseToken.isEmpty) {
                    authenticationForLogin(
                        _textEmail.text, _textPassword.text, firebaseToken);
                  }
                }
              }),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: InkWell(
            onTap: () {
              controller.textPassword.value.clear();
              controller.textEmail.value.clear();
              controller.textName.value.clear();
              controller.textEditingControllerPhone.value.clear();
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CreateNewAccountScreen()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to ShoutOut? ',
                  style: GoogleFonts.questrial(color: Colors.white),
                ),
                Text(
                  'Sign  up',
                  style: GoogleFonts.questrial(
                      color: HexColor('#F81C40'),
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '- or -',
                style: GoogleFonts.questrial(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        ),
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(top: 20),
          child: Image.asset(
            'assets/images/ic_fb_round.png',
            height: 50,
            width: 50,
          ),
        )
      ],
    );
  }

  Future<String> fetchCMS() async {
    final response = await http.get(ApiUrls.BASE_API_URL + 'generalapi');
    // print(response.body);
    var responceJson = json.decode(response.body);

    if (responceJson['status']) {
        prefs.setString('about', responceJson['aboutus']['description']);
        prefs.setString('terms',  responceJson['termsandcondition']['description']);
        prefs.setString('welcomevideo', responceJson['welcomevideo']['videourl']);
        prefs.setString('aboutvideo',responceJson['aboutus']['videourl']);
        ConstantsVariable.termsandcondition = prefs.getString('terms');
        ConstantsVariable.aboutUs = prefs.getString('about');
        ConstantsVariable.videourlWelcome = prefs.getString('welcomevideo');
        ConstantsVariable.videourlAbout = prefs.getString('aboutvideo');
        print('*welcomevideo'+ConstantsVariable.videourlWelcome);


    print('*welcomevideo==>'+prefs.get('welcomevideo'));
    } else {
      print('**no===> No data found');
      throw Exception('Failed to load');
    }
  }

  authenticationForLogin(
      String email, String pass, String firebaseToken) async {
    String deviceId = await firebaseToken;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('deviceid', deviceId);
    print(deviceId + '*deviceId');
    ShowLoadingDialog.showAlertDialog(context);
    String myurl = ApiUrls.BASE_API_URL + "login";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      "email": email,
      "password": pass,
      "deviceid": firebaseToken
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];

      if (status == 'No Record Found') {
        print('***status==>' + status);
        isErrorEmail = true;
        hintErrorEmail = 'Invalid email entered';
        //_textEmail.text = '';
        isErrorPassword = true;
        hintErrorPassword = 'Invalid password entered';
        //_textPassword.text = '';
        Navigator.pop(context);


        CustomDialogOneButton.showDialogs(
            context,
            "assets/images/img_warning_message_dialog.png",
            "Login failed",
            "invalid email or password",
            "OK",
            Container());

      } else if (status == 'Record Found') {

        LoginDataModel loginDataModel = LoginDataModel.fromJson(json.decode(response.body));
        print(loginDataModel.detail.userid);
        MySharedPrefrence.setLoginUserDataPrefrence(
            loginDataModel.detail.userid,
            loginDataModel.detail.name,
            loginDataModel.detail.useremail,
            loginDataModel.detail.phone,
            loginDataModel.detail.province,
            loginDataModel.detail.is_supplier,
            loginDataModel.detail.credits,
            loginDataModel.detail.thumbnailimage);
        ConstantsVariable.profileImage = loginDataModel.detail.thumbnailimage;
        ConstantsVariable.userName = loginDataModel.detail.name;
        ConstantsVariable.credits=loginDataModel.detail.credits;
        ConstantsVariable.isSupplier=loginDataModel.detail.is_supplier;
        print('***loginisSupplier'+ConstantsVariable.isSupplier);
        print('***status==>' + status);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: HomeScreen()));
      }
    });
  }


}
