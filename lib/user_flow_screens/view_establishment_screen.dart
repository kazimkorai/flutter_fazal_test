import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';

import 'package:google_fonts/google_fonts.dart';
import 'view_reviews_customer.dart';
import 'package:flutter_fazal_test/user_flow_screens/listing_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/user_flow_screens/view_reviews_screen.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'package:http/http.dart' as http;

import 'new_request_view.dart';

class ViewEstablishment extends StatefulWidget {

  ViewEstablishment(this.requestid, this.supplierid,this.rating);

  final String requestid;
  final String supplierid;
  final String rating;

  @override
  _ViewEstablishmentState createState() => _ViewEstablishmentState(requestid, supplierid,rating);
}

class _ViewEstablishmentState extends State<ViewEstablishment> {
  _ViewEstablishmentState(this.requestid, this.supplierid,this.rating);

  final String requestid;
  final String supplierid;
  final String rating;
  final String titleText='';
  double _rating = 0.0;

  List<dynamic> listOfImages;
  List<dynamic> listOfBasicDetails;
  String establishmentname='';
  String establishmentaddress;
  String establishmentdetail;
  String supplierrating;
  int noofreviews;
  String useridFromApi;
  Future<List<dynamic>> fetchingImageSingleEstablishment() async {
    final response = await http.get(
        ApiUrls.BASE_API_URL+'establishmentdetail?userid=${ConstantsVariable.useridForListing}');
    var responceJson = json.decode(response.body);
    print(responceJson['detail']['basic_detail']);
    setState(() async {
      establishmentname=   responceJson['detail']['basic_detail']['establishmentname'];
      establishmentaddress=  responceJson['detail']['basic_detail']['establishmentaddress'];
      noofreviews= responceJson['detail']['basic_detail']['noofreviews'];
      supplierrating=responceJson['detail']['basic_detail']['supplierrating'];
      establishmentdetail=responceJson['detail']['basic_detail']['establishmentdetail'];
      useridFromApi=responceJson['detail']['basic_detail']['userid'];

      print('**'+supplierrating.toLowerCase());
      listOfImages =  responceJson['detail']['images'];
      print(listOfImages.toString());
      print(listOfImages.length.toString());
    });
    return listOfImages;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen =  NewRequestViewScreen(requestid,supplierid,supplierrating);
    GenericClasses.context = context;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: NewRequestViewScreen(requestid,supplierid,supplierrating)));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => FutureBuilder<List<dynamic>>(
              future: fetchingImageSingleEstablishment(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!establishmentname.isEmpty) {
                  return Container(
                    child: ListView(
                      children: [
                        Container(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 500),
                              autoPlayCurve: Curves.fastOutSlowIn,
                            ),
                            items: listOfImages
                                .map((item) => Container(
                                      margin: EdgeInsets.only(
                                          left: 3, right: 3, top: 3),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/ic_app_place_holder.png',
                                            image: item['establishmentimage'],
                                          )),
                                    ))
                                .toList(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                establishmentname,
                                style: GoogleFonts.josefinSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 2),
                          child: Text(
                            establishmentaddress,
                            style: GoogleFonts.questrial(
                              color: HexColor('#777777'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 2),
                          child: Text(
                            'Cape Town',
                            style: GoogleFonts.questrial(
                              color: HexColor('#777777'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child:  ViewReviewsScreenCustomer(useridFromApi,requestid,supplierid,supplierrating)));
    },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Text(
                              noofreviews.toString()+ ' Reviews',
                              style: GoogleFonts.raleway(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ViewReviewsScreenCustomer(useridFromApi,requestid,supplierid,supplierrating)));
                          },
                          child: Container(
                            height: 35,
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(10))),
                            margin:
                                EdgeInsets.only(left: 75, right: 75, top: 15),
                            alignment: Alignment.center,
                            child: RatingBar.readOnly(
                              initialRating: double.parse(supplierrating),
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
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 10),
                          child: Text(
                            establishmentdetail,
                            style: GoogleFonts.questrial(
                              wordSpacing: 1,
                              color: HexColor('#777777'),
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
