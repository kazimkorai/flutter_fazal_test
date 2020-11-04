import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/supllier_flow/buy_credits_screen.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/input_otp_for_forgot_password.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewRequestViewScreenSupplier extends StatefulWidget {
  NewRequestViewScreenSupplier(this.requestid);

  final String requestid;


  @override
  _NewRequestViewScreenSupplierState createState() =>
      _NewRequestViewScreenSupplierState(requestid);
}

class _NewRequestViewScreenSupplierState
    extends State<NewRequestViewScreenSupplier> {
  _NewRequestViewScreenSupplierState(this.requestid);

  final String requestid;

  String titleText = '';
  String btnTittle = '';
  final _formKey = GlobalKey<FormState>();
  List listNewReq = new List();
  String requestflag = '';
  TextEditingController _textName = new TextEditingController();
  TextEditingController _textPhone = new TextEditingController();
  TextEditingController _textEmail = new TextEditingController();
  TextEditingController _textCat = new TextEditingController();
  TextEditingController _textBudget = new TextEditingController();
  TextEditingController _textTime = new TextEditingController();
  TextEditingController _textAddress = new TextEditingController();
  TextEditingController _textDesc = new TextEditingController();

  Future<List<dynamic>> fetchingNewReq() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.get('userid');
    final response = await http.get(ApiUrls.BASE_API_URL + 'specificrequestforsupplier?requestid=${requestid}&userid=${userId}');
    var responceJson = json.decode(response.body);
    print(responceJson.toString());

    if (responceJson['status']) {
      setState(() {
        requestflag = responceJson['requestflag'];
        _textName.text = responceJson['data']['customername'];
        _textPhone.text = responceJson['data']['customerphone'];
        _textEmail.text = responceJson['data']['customeremail'];
        _textCat.text = responceJson['data']['selectedcategory'];
        _textBudget.text = responceJson['data']['jobbudget'];
        _textTime.text = responceJson['data']['jobtime'];
        _textAddress.text = responceJson['data']['jobarea'];
        _textDesc.text = responceJson['data']['jobdescription'];

      });
      print(requestflag+'***');
      getText(requestflag);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchingNewReq();
    print('new request view supplierScreen');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: SupplierNewRequestScreen()));
      },
      child: SafeArea(
        child: Scaffold(
            appBar: UserTopMenuWithBack(),
            drawer: MyCustomScaffold.getDrawer(context),
            body: getBody()),
      ),
    );
  }

  Widget getBody() {
    if (!_textName.text.isEmpty) {
      return Builder(
        builder: (context) => new ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Text(
                titleText,
                style: GoogleFonts.raleway(
                    color: HexColor('#2B748D'),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
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
                        controller: _textDesc,
                        enabled: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description';
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
              margin: EdgeInsets.only(top: 25, left: 25, right: 25,bottom: 25),
              child: RaisedButton(
                  child: Text(
                    btnTittle,
                    style: GoogleFonts.josefinSans(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: HexColor('#2B748D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor('#2B748D'))),
                  onPressed: () async {
                    {
                      if (titleText == 'NEW REQUEST') {
                        AcceptRequest();
                      }
                       if(titleText=='ACCEPTED REQUEST'||btnTittle=='BACK')
                        {
                          return Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: SupplierNewRequestScreen()));
                        }
                       if(titleText=='AWARDED REQUEST')
                         {
                           ShowLoadingDialog.showAlertDialog(context);
                           print(requestid);
                           SharedPreferences pref=await SharedPreferences.getInstance();
                           String userid=pref.get('userid');
                           final response = await http.get(ApiUrls.BASE_API_URL +
                               'askforreview?requestid=${requestid}&supplierid=${userid}');
                           var responceJson = json.decode(response.body);
                           print(responceJson.toString());
                           Navigator.pop(context);
                           if(responceJson['message']=='Review request sent to customer')
                             {
                               print('Review Request to the Client');

                               showDialog(
                                   context: context,
                                   builder: (BuildContext context) {
                                     return CustomDialog.con(
                                         "YOU'RE ON FIRE!",
                                         'Request for review has been sent to your client.',
                                         'CONTINUE',
                                         SupplierNewRequestScreen());
                                   });
                             }
                           else
                             {
                               print('some thing wrong');
                             }

                         }
                    }
                  }),
            ),
            // getDeclineRequestWidget()
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  AcceptRequest() async {
    ShowLoadingDialog.showAlertDialog(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.get('userid');

    print(userid);
    print(requestid);
    final response = await http.get(ApiUrls.BASE_API_URL +
        'acceptrequest?requestid=${requestid}&userid=${userid}');
    var responceJson = json.decode(response.body);
    print(responceJson.toString());
    Navigator.pop(context);
    if (responceJson['message'] == 'Request accepted') {
      print(responceJson['message']);

      showDialog(context: context,builder: (BuildContext context) {
        return CustomDialog.con(
            "YOU'RE ON FIRE!", 'You sent your details', 'CONTINUE',
            SupplierNewRequestScreen());
      });

    } else if (responceJson['message'] == 'Supplier has no credit') {
      showDialog(context: context,builder: (BuildContext context)
      {
        return CustomDialog.con(
            "OOOOPS!", 'You have Insufficient Credits to accept this job.',
            'CONTINUE', BuyCreditsScreen());
      });

    }
  }

  // Widget getDeclineRequestWidget() {
  //   if (titleText == 'NEW REQUEST') {
  //     return InkWell(
  //       onTap: () {
  //
  //       },
  //       child: Container(
  //         alignment: Alignment.center,
  //         height: 50,
  //         margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
  //         child: InkWell(
  //           onTap: (){
  //             return Navigator.pushReplacement(
  //                 context,
  //                 PageTransition(
  //                     type: PageTransitionType.leftToRight,
  //                     child: SupplierNewRequestScreen()));
  //           },
  //           child: Text(
  //             'Decline Request',
  //             style: GoogleFonts.questrial(color: HexColor('#777777')),
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       height: 0,
  //       width: 0,
  //     );
  //   }
  // }

  Widget getText(String requestflag) {
    switch (requestflag) {
      case 'not accepted':
        setState(() {
          titleText = 'NEW REQUEST';
          btnTittle = 'ACCEPT REQUEST';
        });
        break;
      case 'accepted':
        {
          setState(() {
            titleText = 'ACCEPTED REQUEST';
            btnTittle='BACK';
          });
        }
        break;

      case 'accepted':
      {
        setState(() {
          titleText = 'ACCEPTED REQUEST';
          btnTittle='BACK';
        });
      }
        break;
      case 'awarded':
        {
          setState(() {
            titleText = 'AWARDED REQUEST';
            btnTittle='ASK FOR REVIEW';
          });
        }
        break;
      case 'job completed':
        {
          setState(() {
            titleText = 'JOB COMPLETED';
            btnTittle='BACK';
          });
        }
        break;
      case 'review pending':
        {
          titleText = 'PENDING REVIEW';
          btnTittle='BACK';
        }
        break;
      case 'job completed':
        {
          titleText = 'JOB COMPLETED';
        }
        break;

    }
  }
}
