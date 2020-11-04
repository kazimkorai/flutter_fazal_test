import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/single_establishment_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'view_establishment_screen.dart';
class ViewReviewsScreenCustomer extends StatefulWidget {

  ViewReviewsScreenCustomer(this.useridFromApi,this.requestid, this.supplierid,this.rating);
  final String useridFromApi;
  final String requestid;
  final String supplierid;
  final String rating;


  @override
  _ViewReviewsScreenCustomerState createState() => _ViewReviewsScreenCustomerState(this.useridFromApi,this.requestid, this.supplierid,this.rating);
}

class _ViewReviewsScreenCustomerState extends State<ViewReviewsScreenCustomer> {

  _ViewReviewsScreenCustomerState(this.useridFromApi,this.requestid, this.supplierid,this.rating);
  final String useridFromApi;
  final String requestid;
  final String supplierid;
  final String rating;
  Future<List<dynamic>> fetchingReview() async {
    final response = await http
        .get('https://shoutout.arcticapps.dev/admin/api/myreviews?userid=${useridFromApi}');
    var responceJson = json.decode(response.body);
    print(responceJson['data']);
    return responceJson['data'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = ViewEstablishment(requestid,supplierid,rating);
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: ViewEstablishment(requestid,supplierid,rating)));
      },
      child: SafeArea(
        child: Scaffold(
            appBar: UserTopMenuWithBack(),
            drawer: MyCustomScaffold.getDrawer(context),
            body: Builder(
              builder: (context) => FutureBuilder<List<dynamic>>(
                  future: fetchingReview(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if(snapshot.data.length>0)
                        {
                          return ListView.builder(
                              itemCount: snapshot.data.length == null
                                  ? 0
                                  : snapshot.data.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 15, bottom: 5),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[index]
                                                    ['customerimage']),
                                                radius: 30.0,
                                              ),
                                              width: 60.0,
                                              height: 60.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                              )),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 12, left: 15),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshot.data[index]
                                                  ['customername'],
                                                  style: GoogleFonts.josefinSans(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 15, top: 3),
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                height: 30,
                                                decoration: new BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(5))),
                                                alignment: Alignment.center,
                                                child: RatingBar.readOnly(
                                                  initialRating: double.parse(
                                                      snapshot.data[index]
                                                      ['rating']),
                                                  maxRating: 5,
                                                  filledIcon: Icons.star,
                                                  emptyIcon: Icons.star_border,
                                                  halfFilledIcon: Icons.star_half,
                                                  isHalfAllowed: true,
                                                  filledColor: Colors.white,
                                                  emptyColor: Colors.grey,
                                                  halfFilledColor: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Container(),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 8, left: 20, right: 20),
                                      child: Text(
                                        snapshot.data[index]['review'],
                                        style: GoogleFonts.questrial(
                                            color: HexColor("#777777")),
                                      ),
                                    ),
                                    Divider(
                                      color: HexColor('#707070'),
                                    )
                                  ],
                                );
                              });
                        }
                      else{
                        return Center(child: Text('No records found'),);
                      }

                    }
                  }),
            )),
      ),
    );
  }
}
