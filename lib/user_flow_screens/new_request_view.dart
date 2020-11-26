import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_for_job.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'write_review_screen.dart';
import 'view_establishment_screen.dart';

class NewRequestViewScreen extends StatefulWidget {
  NewRequestViewScreen(this.requestid, this.supplierid, this.rating);

  final String requestid;
  final String supplierid;
  final String rating;

  @override
  _NewRequestViewScreenState createState() =>
      _NewRequestViewScreenState(requestid, supplierid, rating);
}

class _NewRequestViewScreenState extends State<NewRequestViewScreen> {
  _NewRequestViewScreenState(this.requestid, this.supplierid, this.rating);

  final String requestid;
  final String supplierid;
   String rating='0';
  final _formKey = GlobalKey<FormState>();
  List<dynamic> listItems;
  TextEditingController _textName = new TextEditingController();
  TextEditingController _textPhone = new TextEditingController();
  TextEditingController _textEmail = new TextEditingController();
  TextEditingController _textCat = new TextEditingController();
  TextEditingController _textBudget = new TextEditingController();
  TextEditingController _textTime = new TextEditingController();
  TextEditingController _textAddress = new TextEditingController();
  TextEditingController _textDesc = new TextEditingController();
  String titleText = 'REVIEW PENDING';
  String btnText = 'BACK';

  getNewRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userid = sharedPreferences.get('userid');
    print('*userId' + userid);
    print('*requestId' + requestid);
    String myurl = ApiUrls.BASE_API_URL +
        "specificacceptedrequestforcustomer?requestid=${requestid}&supplierid=${supplierid}";

    final response = await http.get(myurl);
    var responceJson = json.decode(response.body);
    print(responceJson.toString());
    print(responceJson['status']);

    if (responceJson['status']) {
      setState(() {
        _textName.text = responceJson['data']['customername'];
        _textPhone.text = responceJson['data']['customerphone'];
        _textEmail.text = responceJson['data']['customeremail'];
        _textCat.text = responceJson['data']['selectedcategory'];
        _textBudget.text = responceJson['data']['jobbudget'];
        _textTime.text = responceJson['data']['jobtime'];
        _textAddress.text = responceJson['data']['jobarea'];
        _textDesc.text = responceJson['data']['jobdescription'];
        print(responceJson['requestflag'] + '**');

        if (responceJson['requestflag'] == 'accepted') {
          titleText = 'NEW REQUEST';
          btnText = 'AWARD JOB';
        }
        if (responceJson['requestflag'] == 'awarded') {
          titleText = 'AWARDED REQUEST';
          btnText = 'BACK';
        }

        if (responceJson['requestflag'] == 'Review Requested') {
          titleText = 'PENDING REVIEW';
        }
        if (responceJson['requestflag'] == 'review pending') {
          btnText = 'GIVE REVIEW';
          titleText = 'REVIEW PENDING';
        }
        if(responceJson['requestflag']=='job completed'){
        {
        titleText = 'JOB COMPLETED';
        btnText = 'BACK';
        }

        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNewRequest();
    print('I am new request view');
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = NewRequestForJob(requestid);
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: NewRequestForJob(requestid)));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: getBodyWidgets(),
        ),
      ),
    );
  }

  Widget getBodyWidgets() {
    if (!_textName.text.isEmpty) {
      return Builder(
        builder: (context) => new ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Text(
                titleText.toString(),
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
                rating.toString() + ' Rating',
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
                        controller: _textName,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: 'Name',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textPhone,
                        enabled: false,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: 'Telephone number',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textEmail,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email Required';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          suffixIcon: Container(
                            margin:
                                EdgeInsets.only(right: 5, top: 15, bottom: 15),
                            height: 10,
                            width: 10,
                            child: Image.asset(
                              'assets/images/ic_email.png',
                              height: 5,
                              width: 5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: 'Email',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textCat,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Travel(Category) Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: 'Travel (Category)',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textBudget,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Budget Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: 'R5000 - R15 000',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textTime,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Time Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: '2 Weeks',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        controller: _textAddress,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Address Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          hintText: '22 Street, Area 51',
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormField(
                        enabled: false,
                        controller: _textDesc,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description Required';
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                width: 1, color: HexColor("#B1B1B1")),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    btnText,
                    style: GoogleFonts.josefinSans(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: HexColor('#2B748D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor('#2B748D'))),
                  onPressed: () async {
                    {
                      if (btnText == 'GIVE REVIEW') {

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child:
                                    WriteReviewScreen(requestid, supplierid)));
                      }
                      if (btnText == 'BACK') {
                        return Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: NewRequestForJob(requestid)));
                      }
                      if (btnText == 'AWARD JOB') {
                        ConstantsVariable. isTabIndexNewForCust=false;
                        ShowLoadingDialog.showAlertDialog(context);
                        String myurl = ApiUrls.BASE_API_URL +
                            "awardjob?requestid=${requestid}&supplierid=${supplierid}";
                        final response = await http.get(myurl);
                        var responceJson = json.decode(response.body);
                        print(responceJson.toString());
                        Navigator.pop(context);

                        if (responceJson['message'] == 'Job Awarded') {
                          print('Awarded Job');
                          return Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: NewRequestForJob(requestid)));
                        } else {
                          print('Going Something Wrong');
                        }
                      }
                    }
                  }),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 15),
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
                    {
                      print('view establish clicked');
                      ConstantsVariable.useridForListing = supplierid;
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ViewEstablishment(
                                  requestid, supplierid, rating)));
                    }
                  }),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
