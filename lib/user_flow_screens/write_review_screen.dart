import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_view.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'awarded_request_view.dart';
class WriteReviewScreen extends StatefulWidget {
  WriteReviewScreen(this.requestid,this.supplierid);
  final String requestid;
  final String supplierid;
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState(requestid,supplierid);
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  _WriteReviewScreenState(this.requestid,this.supplierid);
  final String requestid;
  final String supplierid;
  double _rating = 0.0;
  final _formKey=GlobalKey<FormState>();

  TextEditingController _textDesc = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {

        return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new NewRequestViewScreen(requestid,supplierid,_rating.toString())));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => new ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          controller: _textDesc,
                          validator: (value){
                            if(value.isEmpty)
                              {
                                return 'Description';
                              }
                            return null;
                          },
                            maxLines: 8,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              hintText: 'Description',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 75, right: 75, top: 15),
                        alignment: Alignment.center,
                        height: 35,
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        child: RatingBar(
                          onRatingChanged: (rating) =>
                              setState(() => _rating = rating),
                          initialRating: 5,
                          maxRating: 5,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          halfFilledIcon: Icons.star_half,
                          isHalfAllowed: true,
                          filledColor: Colors.white,
                          emptyColor: Colors.grey,
                          halfFilledColor: Colors.white,
                          size: 25,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                      EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 15),
                  child: RaisedButton(
                      child: Text(
                        'SEND REVIEW',
                        style: GoogleFonts.josefinSans(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      color: HexColor('#2B748D'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#2B748D'))),
                      onPressed: () {
                        {
                          if(_formKey.currentState.validate())
                            {

                              GiveReview();
                            }

                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  GiveReview() async
  {
    ShowLoadingDialog.showAlertDialog(context);
    SharedPreferences pref=await SharedPreferences.getInstance();
    String userid=pref.get('userid');
    String myurl = ApiUrls.BASE_API_URL+"submitreview";
    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      "supplierid": supplierid,
      "requestid": requestid,
      'reviewtext':_textDesc.text,
      "stars": _rating.toString()[0]+_rating.toString()[1]+_rating.toString()[2],
      // ${mystring[0]}
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];
      print(status);
      Navigator.pop(context);
      if(status=='Review Submitted')
      {
        showDialog(context: context,builder: (BuildContext context){

          return    CustomDialog.con('Hello '+ ConstantsVariable.userName+'!','Your Review has been sent successfully!','CONTINUE',HomeScreen());

      });
      }

    });
  }
}
