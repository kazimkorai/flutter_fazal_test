import 'dart:convert';

import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/pojo/login_datamodel/login_data_model.dart';
import 'package:flutter_fazal_test/pojo/login_datamodel/update_datamodel.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var _textPassword = TextEditingController();
  var _textConfirmPassword = TextEditingController();
  TextEditingController _textName = TextEditingController();
  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPhone = TextEditingController();
  TextEditingController _textRegion = TextEditingController();
  final picker = ImagePicker();
  bool rememberMe = false;
  SharedPreferences sharedPreferences;
  File _image;
  List dropDownList;
  String _mySelection='1';
  String userId;
  String pathImage;

  Future fetchDropDown() async {

    final response = await http
        .get('https://shoutout.arcticapps.dev/admin/api/getdropdownapi');
    var responceJson = json.decode(response.body);
    if (responceJson['status']) {
      setState(() {
        dropDownList = responceJson['region'];
      });

      print('*****REgion' + dropDownList.toString());
      return dropDownList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          pathImage = _image.path;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        if (rememberMe) {
        } else {}
      });

  @override
  void initState() {
    super.initState();
    getSharedPrefrenceData();
    fetchDropDown();
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: SafeArea(
        child: getScaffoldWithBody(),
      ),
    );
  }
Scaffold getScaffoldWithBody()
{

  return Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: UserTopMenuWithBack(),
    drawer: MyCustomScaffold.getDrawer(context),
    body:  Builder(
      builder: (context) => ListView(
        children: [
          Container(height: 140, width: 140, child: circleAva()),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(

                        controller: _textName,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name Required';
                          } else if (value.length >= 21) {
                            return 'Max length is 20';
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
                        controller: _textEmail,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!EmailValidator.validate(value)) {
                            return 'Invalid Email';
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
                          hintText: 'Email',
                        )),
                  ),
                  Container(
                      margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextFormField(
                          controller: _textPhone,
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Contact Number Required';
                            } else if (value.length <= 5) {
                              return 'Length greater than 5 ';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                            hintText: 'Contact Number',
                          ))),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor('#B1B1B1'),
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: DropDown(dropDownList)),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        obscureText: true,
                        controller: _textPassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          } else if (value.length < 6) {
                            return 'Minimum length is 6';
                          } else if (_textPassword.text != _textConfirmPassword.text) {
                            Fluttertoast.showToast(
                                msg: "Password not match",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
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
                          hintText: 'Password',
                        )),
                  ),
      Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          } else if (value.length < 6) {
                            return 'Minimum length is 6';
                          }
                          return null;
                        },
                        controller: _textConfirmPassword,
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
                          hintText: 'Confirm Password',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 18, right: 10, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accept Terms And Conditions',
                          style: GoogleFonts.questrial(
                              color: HexColor('#777777'), fontSize: 16),
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          child: Checkbox(
                            onChanged: _onRememberMeChanged,
                            value: rememberMe,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            margin:
            EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 15),
            child: RaisedButton(
                child: Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.white),
                ),
                color: HexColor('#2B748D'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: HexColor('#2B748D'))),
                onPressed: () async {
                  {
                    if(_textConfirmPassword.text==_textPassword.text)
                      {
                        if (_formKey.currentState.validate()) {
                          if (rememberMe) {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            if (pathImage == prefs.get('thumbnailimage')) {
                              UpdateProfileWithoutImage();
                            } else {
                              UpdateProfileReq();
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Accept Terms and Condition",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                        else if(rememberMe)
                        {
                          if(_textPassword.text==''&&_textConfirmPassword.text=='')
                          {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            if (pathImage == prefs.get('thumbnailimage')) {
                              UpdateProfileWithoutImage();
                            } else {
                              UpdateProfileReq();
                            }
                          }
                        }
                        else  {
                          Fluttertoast.showToast(
                              msg: "Accept Terms and Condition",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    else{

                      Fluttertoast.showToast(
                          msg: "Password not match",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  }
                }),
          )
        ],
      ),
    ),
  );
}
  Widget circleAva() {
    if (_image == null) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 140,
          width: 140,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
            Container(
            width: 100.0,
            height: 100.0,
            margin: EdgeInsets.only(left: 5),
            child: CachedNetworkImage(
              imageUrl: ConstantsVariable.profileImage,
              imageBuilder: (context, imageProvider) => Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
              Container(
                height: 22,
                width: 65,
                margin: EdgeInsets.only(bottom: 8),
                child: RaisedButton(
                  onPressed: () {
                    getImage();
                    print('Clicked');
                  },
                  color: Colors.white,
                  child: Text(
                    'Edit',
                    style: GoogleFonts.questrial(color: HexColor('#777777')),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
                radius: (52),
// backgroundColor: Colors.white,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(52),
                    child: Image.file(_image,
                        width: 300, height: 300, fit: BoxFit.fill))),
            Container(
              height: 22,
              width: 65,
              margin: EdgeInsets.only(bottom: 8),
              child: RaisedButton(
                onPressed: () {
                  getImage();
                  print('Clicked');
                },
                color: Colors.white,
                child: Text(
                  'Edit',
                  style: GoogleFonts.questrial(color: HexColor('#777777')),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget DropDown(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: Container(margin: EdgeInsets.only(left: 8),child: new Text(
                item['regionname'],
                style: TextStyle(fontSize: 14.0),
              ),),
              value: item['id'].toString(),
            );
          }).toList(),

          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
              print('_mySelection:' + _mySelection.toString());
            });
          },
          value: _mySelection,
        ),
      );
    } else {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  UpdateProfileReq() async {

    try {
      ShowLoadingDialog.showAlertDialog(context);
      FormData formData = new FormData.fromMap({
        "userid": userId,
        "name": _textName.text,
        'email': _textEmail.text,
        'phone': _textPhone.text,
        'region': _textRegion.text,
        'password': _textPassword.text,
        'profileimage': await MultipartFile.fromFile(pathImage, filename: 'name')
      });
      Response response = await Dio()
          .post('https://shoutout.arcticapps.dev/admin/api/updateprofile',
              data: formData,
              options: Options(
                  followRedirects: false,
                  receiveDataWhenStatusError: true,
                  validateStatus: (status) {
                    Navigator.pop(context);

                    return status < 500;
                  }));
      print(response.data);
      var jsArray = json.decode(response.data);
      print(jsArray['message']);
      if (jsArray['message'] == 'Profile Updated') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', userId);
        prefs.setString('name', jsArray['data']['name']);
        prefs.setString('useremail', jsArray['data']['useremail']);
        prefs.setString('phone', jsArray['data']['phone']);
        prefs.setString('province', jsArray['data']['province']);
        prefs.setString('isSupplier', jsArray['data']['is_supplier']);
        prefs.setString('credits', jsArray['data']['credits']);
        prefs.setString('thumbnailimage', jsArray['data']['thumbnailimage']);

        ConstantsVariable.profileImage = prefs.get('thumbnailimage');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'CONGRATULATIONS!',
                  'Profile Updated.',
                  'CONTINUE',
                  HomeScreen());
            });
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  UpdateProfileWithoutImage() async {
    try {
      ShowLoadingDialog.showAlertDialog(context);
      FormData formData = new FormData.fromMap({
        "userid": userId,
        "name": _textName.text,
        'email': _textEmail.text,
        'phone': _textPhone.text,
        'region': _mySelection,
        'password': _textPassword.text,
      });
      Response response = await Dio()
          .post(ApiUrls.BASE_API_URL+'updateprofile',
              data: formData,
              options: Options(
                  followRedirects: false,
                  receiveDataWhenStatusError: true,
                  validateStatus: (status) {
                    Navigator.pop(context);

                    return status < 500;
                  }));
      var jsArray = json.decode(response.data);
      print(jsArray['message']);
      if (jsArray['message'] == 'Profile Updated') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', userId);
        prefs.setString('name', jsArray['data']['name']);
        prefs.setString('useremail', jsArray['data']['useremail']);
        prefs.setString('phone', jsArray['data']['phone']);
        prefs.setString('province', jsArray['data']['province']);
        prefs.setString('isSupplier', jsArray['data']['is_supplier']);
        prefs.setString('credits', jsArray['data']['credits']);
        prefs.setString('thumbnailimage', jsArray['data']['thumbnailimage']);
        ConstantsVariable.profileImage = prefs.get('thumbnailimage');
        ConstantsVariable.userName= prefs.get('name');


        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'CONGRATULATIONS!',
                  'Profile Updated.',
                  'CONTINUE',
                  HomeScreen());
            });
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  getSharedPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.get('userid');
    _textName.text = prefs.get('name');
    _textEmail.text = prefs.get('useremail');
    _textPhone.text = prefs.get('phone');

   // print(prefs.get('province'));
    prefs.get('isSupplier');
    prefs.get('credits');
    _mySelection=prefs.get('province');
   print('*seclectionProvince'+prefs.get('province'));
   if(_mySelection=='0')
     {
       _mySelection='1';
     }
    print(prefs.get('userid'));
    pathImage = prefs.get('thumbnailimage');
  }
}
