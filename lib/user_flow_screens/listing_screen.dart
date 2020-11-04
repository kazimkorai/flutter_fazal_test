import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/pojo/newdatamodel/datamodel_sub_categories.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/single_establishment_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:rating_bar/rating_bar.dart';

class ListingScreen extends StatefulWidget {
  ListingScreen(this.titleText);
  final String titleText;

  @override
  _ListingScreenState createState() => _ListingScreenState(titleText);
}

class _ListingScreenState extends State<ListingScreen> {
  _ListingScreenState(this.titleText);
  final String titleText;
  List<dynamic> listResponce = [];
  TextEditingController _searchingController = TextEditingController();
  List<dynamic> listSearched = List();
  bool _isSearching;
  String _searchText;

  @override
  void initState() {
    super.initState();
    print('I am Listing Screen');
    _isSearching=false;
    _searchingController.addListener(() {
      if (_searchingController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchingController.text;
          print(_searchText);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: SubCategoryScreen(titleText)));
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: UserTopMenu(_searchingController,(value)=>{
            print(value),
            searchOperation(value)
          }),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 12, left: 30),
                      child: Text(
                        titleText,
                        style: GoogleFonts.josefinSans(
                            color: HexColor("#232323"),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                  flex: 10,
                  child: FutureBuilder<List<dynamic>>(
                      future: fetchSubCat(ConstantsVariable.establishmentId),
                      builder: (BuildContext context, AsyncSnapshot snapshot)
                      {
                        if(snapshot.hasData) {
                          return _buildListView();
                        }

                        else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 Widget _buildListView()
  {
    if(listResponce.length>0)
      {
        if(!_isSearching)
        {
          return   ListView.builder(
              itemCount: listResponce == null ? 0 : listResponce.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return InkWell(
                  onTap: () {
                    ConstantsVariable.useridForListing =
                    listResponce[index]['userid'];
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SingleEstablishmentScreen(listResponce[index]['establishmentname'])));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: CachedNetworkImage(
                              imageUrl:listResponce[index]
                              ['establishmentimage'],
                              imageBuilder:
                                  (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                              // placeholder: (context, url) =>
                              //     CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            height: 220,
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10, right: 15, left: 17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listResponce[index]['establishmentname'],
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 3),
                                    child: RatingBar.readOnly(
                                      initialRating: double.parse(listResponce[index]['establishmentrating'].toString()),
                                      maxRating: 5,
                                      filledIcon: Icons.star,
                                      emptyIcon: Icons.star_border,
                                      halfFilledIcon: Icons.star_half,
                                      isHalfAllowed: true,
                                      filledColor: Colors.white,
                                      emptyColor: Colors.grey,
                                      halfFilledColor: Colors.white,
                                      size: 25,
                                    )
                                  // Text(
                                  //   '(${listResponce[index]['establishmentrating']}  ratings)',
                                  //   style: GoogleFonts.questrial(
                                  //     color: HexColor('#777777'),
                                  //     fontSize: 16,
                                  //   ),
                                  // ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 17, top: 5,right: 15),
                            child: Text(
                              listResponce[index]['establishmentaddress'],
                              style: GoogleFonts.questrial(
                                color: HexColor('#777777'),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 17, top: 4),
                            child: Text(
                              listResponce[index]['establishmentregion'],
                              style: GoogleFonts.questrial(
                                color: HexColor('#777777'),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              height: 2,
                              color: HexColor("#707070"),
                            ),
                          )
                        ]),
                  ),
                );
              });
        }
        else{
          return    ListView.builder(
              itemCount: listSearched == null ? 0 : listSearched.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return InkWell(
                  onTap: () {
                    ConstantsVariable.useridForListing =
                    listSearched[index]['userid'];

                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SingleEstablishmentScreen(listSearched[index]['establishmentname'])));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            height: 220,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(listSearched[index]['establishmentimage']))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 15, left: 17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listSearched[index]['establishmentname'],
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: Text(
                                    '(${listSearched[index]['establishmentrating']}  ratings)',
                                    style: GoogleFonts.questrial(
                                      color: HexColor('#777777'),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 17, top: 5,right: 15),
                            child: Text(
                              listSearched[index]['establishmentaddress'],
                              style: GoogleFonts.questrial(
                                color: HexColor('#777777'),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 17, top: 4),
                            child: Text(
                              listSearched[index]['establishmentregion'],
                              style: GoogleFonts.questrial(
                                color: HexColor('#777777'),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              height: 2,
                              color: HexColor("#707070"),
                            ),
                          )
                        ]),
                  ),
                );
              });
        }
      }
    else{
      return Center(child: Text('No records found'),);
    }


  }


  Future<List<dynamic>> fetchSubCat(String catId) async {
    print(catId.toString() + '*subCatid');
    final response = await http.get(
        'https://shoutout.arcticapps.dev/admin/api/getsubcategories?catid=' +
            catId);
    var responceJson = await json.decode(response.body);

    print(responceJson.toString());
    return listResponce = await responceJson['response'];
  }

  void searchOperation(String searchText) {
    listSearched.clear();
    for (int index = 0; index <listResponce.length; index++) {
      String data = listResponce[index]['establishmentname'];
      print(data);
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        listSearched.add(listResponce[index]);
        print(listSearched[0].toString());
      }
    }
    print(listSearched.length);
  }
}
