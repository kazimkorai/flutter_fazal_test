import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_flow_screens/listing_screen.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/main.dart';
import 'package:flutter_fazal_test/pojo/home_datamodel.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_fazal_test/controller/controller_home_cat.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  SharedPreferences prefs;
  TextEditingController _searchingController = TextEditingController();
  List<dynamic> listSearched = List();
  bool _isSearching;
  String _searchText;
  @override
  void dispose() {
    super.dispose();
    _searchingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUserFirstTime();
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

  void searchOperation(String searchText) {
    listSearched.clear();
    for (int index = 0; index < ConstantsVariable.catList.length; index++) {
      String data = ConstantsVariable.catList[index]['catname'];
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        listSearched.add(ConstantsVariable.catList[index]);
        print(listSearched[0].toString());
      }
    }
    print(listSearched.length);
  }

  void checkUserFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    bool ISFIRST = true;
    try {
      ISFIRST = prefs.getBool('ISFIRST');
      print(ISFIRST);
    } catch (Exception) {
      print(Exception + '***null');
    }
    if (prefs.getBool('ISFIRST') == null) {
      prefs.setBool('ISFIRST', false);
      print("first launch"); //se
      openAlertBox(); // tState to refresh or move to some other page
    }
  }

  openAlertBox() {

    print('*openAlertBox'+ConstantsVariable.videourlWelcome);
    YoutubePlayerController _controller;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(ConstantsVariable.videourlWelcome),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              height: 435,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Text(
                            'Welcome to \n  ShoutOut',
                            style: GoogleFonts.questrial(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: const Color(0xff3b3b3b),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 25, bottom: 15),
                        child: RaisedButton(
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: HexColor('#2B748D'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(color: HexColor('#2B748D'))),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future fetchSubCat(String catId, String catName) async {
    ShowLoadingDialog.showAlertDialog(context);
    print(catId.toString() + '*subCatid');
    final response = await http.get(
        'https://shoutout.arcticapps.dev/admin/api/getsubcategories?catid=' +
            catId);
    var responceJson = await json.decode(response.body);
    ConstantsVariable.subCatList = await responceJson['response'];

    print(ConstantsVariable.subCatList.toString());
    Navigator.pop(context);

    print(responceJson['subcat'].toString() + '*** I am Here SubCat');

    if (responceJson['subcat'] != 0) {
      print(responceJson['subcat']);
      ConstantsVariable.idForSub = catId;

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: SubCategoryScreen(catName)));
    } else {
      print(responceJson['subcat']);
      ConstantsVariable.idForSub = catId;
      ConstantsVariable.subCatList = await responceJson['response'];

      if(ConstantsVariable.subCatList.length>0)
        {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ListingScreen(catName)));
        }
      else{
        Navigator.pop(context);
        print('Not found');
        Fluttertoast.showToast(
            msg: "Subcategory not found ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
    }
  }

  Future<List<dynamic>> fetchHomeCatg() async {
    print("here");
    if(ConstantsVariable.catList.length>0)
      {
        return ConstantsVariable.catList;
      }
    final response = await http.get(ApiUrls.BASE_API_URL + 'homecategories');
    var responceJson = json.decode(response.body);
    if (responceJson['status']) {
      return ConstantsVariable.catList = responceJson['detail'];
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit an App'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () => exit(0),
                    /*Navigator.of(context).pop(true)*/
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: UserTopMenu(_searchingController, (value) => {
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
                        'Categories',
                        style: GoogleFonts.josefinSans(
                            color: HexColor("#232323"),
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                  flex: 10,
                  child:_buildListView(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody()
  {
    if(ConstantsVariable.catList.length>0)
      {
        return   ListView.builder(
            padding: EdgeInsets.only(bottom: 15),
            itemCount: ConstantsVariable.catList.length == null
                ? 0
                : ConstantsVariable.catList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print(_searchingController.text);
                  ShowLoadingDialog.showAlertDialog(context);
                  print(ConstantsVariable.catList[index]
                  ['catid']
                      .toString());
                  fetchSubCat(
                      ConstantsVariable.catList[index]
                      ['catid'],
                      ConstantsVariable.catList[index]
                      ['catname']);
                },
                child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10),
                        height: 320,
                        child: CachedNetworkImage(
                          imageUrl: ConstantsVariable
                              .catList[index]['catimage'],
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
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         fit: BoxFit.fill,
                        //         image: NetworkImage(
                        //           ConstantsVariable
                        //                   .catList[index]
                        //               ['catimage'],
                        //         ))),
                      ),
                      Container(
                          height: 27,
                          margin: EdgeInsets.only(
                              top: 0,
                              left: 10,
                              right: 10,
                              bottom: 10),
                          child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  alignment:
                                  Alignment.bottomCenter,
                                  color: Colors.grey
                                      .withOpacity(0.5),
                                  child: Text(
                                    ConstantsVariable
                                        .catList[index]
                                    ['catname'],
                                    textAlign: TextAlign.center,
                                    style:
                                    GoogleFonts.josefinSans(
                                        fontSize: 22,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ))),
                    ]),
              );
            });
      }
    else{
      return Center(child: Text('No records found'),);
    }
  }

  Widget _buildListView() {

    if (!_isSearching) {

          return FutureBuilder<List<dynamic>>(
              future: fetchHomeCatg(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return getBody();
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });

    }
    else {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: 15),
          itemCount: listSearched == null
              ? 0
              : listSearched.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(_searchingController.text);
                ShowLoadingDialog.showAlertDialog(context);
                print(listSearched[index]
                ['catid']
                    .toString());
                fetchSubCat(
                    listSearched[index]
                    ['catid'],
                    listSearched[index]
                    ['catname']);
              },
              child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 10, right: 10),
                      height: 320,
                      child: CachedNetworkImage(
                        imageUrl: listSearched[index]['catimage'],
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
                      // decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         fit: BoxFit.fill,
                      //         image: NetworkImage(
                      //           ConstantsVariable
                      //                   .catList[index]
                      //               ['catimage'],
                      //         ))),
                    ),
                    Container(
                        height: 27,
                        margin: EdgeInsets.only(
                            top: 0,
                            left: 10,
                            right: 10,
                            bottom: 10),
                        child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 5, sigmaY: 5),
                              child: Container(
                                alignment:
                                Alignment.bottomCenter,
                                color: Colors.grey
                                    .withOpacity(0.5),
                                child: Text(
                                  listSearched[index]
                                  ['catname'],
                                  textAlign: TextAlign.center,
                                  style:
                                  GoogleFonts.josefinSans(
                                      fontSize: 22,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ))),
                  ]),
            );
          });
    }
  }
}
