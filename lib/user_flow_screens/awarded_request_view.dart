import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_for_job.dart';
import 'package:flutter_fazal_test/user_flow_screens/write_review_screen.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'view_establishment_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class AwardedRequestViewScreen extends StatefulWidget {
//   AwardedRequestViewScreen(this.requestid,this.supplierid);
//   final String requestid;
//   final String supplierid;
//   @override
//   _AwardedRequestViewScreenState createState() =>
//       _AwardedRequestViewScreenState(requestid,supplierid);
// }
//
// class _AwardedRequestViewScreenState extends State<AwardedRequestViewScreen> {
//
//   _AwardedRequestViewScreenState(this.requestid,this.supplierid);
//   final String requestid;
//   final String supplierid;
//   final _formKey = GlobalKey<FormState>();
//   List listAwardedView = List();
//   String rating='0.0';
//   bool isFromAwarded=true;
//   String tittleText='AWARDED REQUEST';
//   String btnText='BACK';
//
//   TextEditingController _textName = TextEditingController();
//   TextEditingController _textPhone = TextEditingController();
//   TextEditingController _textEmail = TextEditingController();
//   TextEditingController _textTravelCat = TextEditingController();
//   TextEditingController _textBudget = TextEditingController();
//   TextEditingController _textTime = TextEditingController();
//   TextEditingController _textAddress = TextEditingController();
//   TextEditingController _textDesc = TextEditingController();
//
//   Future<List<dynamic>> FetchingListAwardedView() async {
//
//     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
//
//
//     final response = await http.get(ApiUrls.BASE_API_URL+'specificacceptedrequestforcustomer?requestid=${requestid}&supplierid=${supplierid}');
//     var responceJson = json.decode(response.body);
//     print(responceJson.toString());
//
//     if (responceJson['status']) {
//       setState(() {
//         _textName.text = responceJson['data']['customername'];
//         _textPhone.text = responceJson['data']['customerphone'];
//         _textEmail.text = responceJson['data']['customeremail'];
//         _textTravelCat.text = responceJson['data']['selectedcategory'];
//         _textBudget.text = responceJson['data']['jobbudget'];
//         _textAddress.text = responceJson['data']['jobarea'];
//         _textDesc.text = responceJson['data']['jobdescription'];
//         _textTime.text = responceJson['data']['jobtime'];
//         rating=responceJson['data']['supplierrating'];
//         if(responceJson['requestflag']=='review pending')
//           {
//             tittleText='PENDING REVIEW';
//             btnText='GIVE REVIEW';
//           }
//         if(responceJson['requestflag']=='job completed')
//           {
//             tittleText='JOB COMPLETED';
//           }
//         print(rating+'**');
//       });
//     } else {
//       throw Exception('Failed to load album');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     FetchingListAwardedView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     GenericClasses.WidgetScreen = NewRequestForJob(requestid);
//     GenericClasses.context = context;
//     return WillPopScope(
//       onWillPop: () {
//         return Navigator.pushReplacement(
//             context,
//             PageTransition(
//                 type: PageTransitionType.leftToRight,
//                 child: NewRequestForJob(requestid)));
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: UserTopMenuWithBack(),
//           drawer: MyCustomScaffold.getDrawer(context),
//           body:getBodyWidgets(),
//         ),
//       ),
//     );
//   }
//
//   Widget getBodyWidgets()
//   {
//     if(_textName.text.isNotEmpty)
//       {
//         return  Builder(
//           builder: (context) => new ListView(
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 alignment: Alignment.center,
//                 child: Text(
//                   tittleText,
//                   style: GoogleFonts.raleway(
//                       color: HexColor('#2B748D'),
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 15),
//                 alignment: Alignment.center,
//                 child: Text(
//                   rating+' Rating',
//                   style: GoogleFonts.questrial(
//                     color: HexColor('#2B748D'),
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textName,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Name Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: 'Name',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textPhone,
//                           keyboardType: TextInputType.phone,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Telephone number Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             suffixIcon: Image.asset(
//                               'assets/images/ic_phon.png',
//                               width: 18,
//                               height: 18,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: 'Telephone number',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textEmail,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Email Required';
//                             } else if (!EmailValidator.validate(value)) {
//                               return 'Invalid Email';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             suffixIcon: Container(
//                               margin: EdgeInsets.only(
//                                   right: 5, top: 15, bottom: 15),
//                               height: 10,
//                               width: 10,
//                               child: Image.asset(
//                                 'assets/images/ic_email.png',
//                                 height: 5,
//                                 width: 5,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: 'Email',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textTravelCat,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Travel(Category) Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: 'Travel (Category)',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textBudget,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Budget Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: 'R5000 - R15 000',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textTime,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Time Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: '2 Weeks',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           enabled: false,
//                           controller: _textAddress,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Address Required';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             hintText: '22 Street, Area 51',
//                           )),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: TextFormField(
//                           controller: _textDesc,
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Time Description';
//                             }
//                             return null;
//                           },
//                           maxLines: 7,
//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           decoration: new InputDecoration(
//                             hintText: 'Description',
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
//                               borderSide: BorderSide(
//                                   width: 1, color: HexColor("#B1B1B1")),
//                             ),
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 50,
//                 margin: EdgeInsets.only(top: 25, left: 25, right: 25),
//                 child: RaisedButton(
//                     child: Text(
//                       btnText,
//                       style: GoogleFonts.josefinSans(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                     color: HexColor('#2B748D'),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//                         side: BorderSide(color: HexColor('#2B748D'))),
//                     onPressed: () {
//                       {
//                        if(btnText=='BACK')
//                          {
//                            return Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                    type: PageTransitionType.leftToRight,
//                                    child: NewRequestForJob(requestid)));
//                          }
//                        else
//                          {
//                            return Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                    type: PageTransitionType.rightToLeft,
//                                    child: WriteReviewScreen(requestid,supplierid)));
//
//                          }
//                       }
//                     }),
//               ),
//               Container(
//                 height: 50,
//                 margin:
//                 EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 15),
//                 child: RaisedButton(
//                     child: Text(
//                       'VIEW ESTABLISHMENT',
//                       style: GoogleFonts.josefinSans(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                     color: HexColor('#48484A'),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//                         side: BorderSide(color: HexColor('#48484A'))),
//                     onPressed: () {
//                       {
//                         print('view establish clicked');
//                         ConstantsVariable.useridForListing=supplierid;
//                         Navigator.pushReplacement(
//                             context,
//                             PageTransition(
//                                 type: PageTransitionType.rightToLeft,
//                                 child: ViewEstablishment(requestid,supplierid,rating,)));
//                       }
//                     }),
//               )
//             ],
//           ),
//         );
//       }
//     else{
//       return Center(child: CircularProgressIndicator(),);
//     }
//   }
// }
