import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_flow_screens/single_establishment_screen.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/pojo/home_datamodel.dart';
import 'package:flutter_fazal_test/pojo/newdatamodel/datamodel_sub_categories.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/listing_screen.dart';

import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;

class SubCategoryScreen extends StatefulWidget {
  SubCategoryScreen(this.titleText);
  final String titleText;
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState(titleText);
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  _SubCategoryScreenState(this.titleText);
  final String titleText;
  TextEditingController _searchingController = TextEditingController();

  List<dynamic> listSearched = List();
  bool _isSearching;
  String _searchText;

  @override
  void initState() {
    super.initState();
    print('I am SubCat Screen');
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
    for (int index = 0; index < ConstantsVariable.subCatList.length; index++) {
      String data = ConstantsVariable.subCatList[index]['establishmentname'];
  print(data);
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        listSearched.add(ConstantsVariable.subCatList[index]);
        print(listSearched[0].toString());
      }
    }
    print(listSearched.length);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: UserTopMenu(_searchingController,(value) => {
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
                _buildListView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchSubCat(String catId) async {
    ShowLoadingDialog.showAlertDialog(context);
    print(catId.toString() + '*subCatid');
    final response = await http.get(
        'https://shoutout.arcticapps.dev/admin/api/getsubcategories?catid=' +
            catId);
    var responceJson = await json.decode(response.body);
    print(responceJson.toString());
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: ListingScreen(titleText)));
  }

  Widget getBody()
  {
    if(ConstantsVariable.subCatList.length>0)
      {
        return  ListView.builder(
            itemCount: ConstantsVariable.subCatList.length == null
                ? 0
                : ConstantsVariable.subCatList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ConstantsVariable.establishmentId =
                  ConstantsVariable.subCatList[index]
                  ['establishmentid'];


                  return Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ListingScreen(  ConstantsVariable.subCatList[index]
                          ['establishmentname'])));
                  // ConstantsVariable.idForSingleEstablishment = ConstantsVariable.subCatList[index]['catid'];
                  // Navigator.pushReplacement(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.rightToLeft,
                  //         child: SingleEstablishmentScreen()));
                },
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      left: 12, right: 12, bottom: 15),
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        // for(String name in names) Cards(unit:name)

                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 320,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    ConstantsVariable
                                        .subCatList[index]
                                    ['establishmentimage'],
                                  ))),
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
                                    alignment: Alignment.bottomCenter,
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Text(
                                      ConstantsVariable.subCatList[index]
                                      ['establishmentname'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.josefinSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )))
                      ]),
                ),
              );
            });
      }
    else{
      Container(height:200,width: 200,child: Center(child: Text('No records found'),));
    }
  }
  Widget _buildListView() {
    if (!_isSearching) {

      return  Expanded(
        flex: 10,
        child:getBody(),
      );
    }
    else{
      return  Expanded(
        flex: 10,
        child: ListView.builder(
            itemCount:listSearched.length == null
                ? 0
                : listSearched.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ConstantsVariable.establishmentId =
                  listSearched[index]['establishmentid'];


                  return Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ListingScreen(  listSearched[index]
                          ['establishmentname'])));
                  // ConstantsVariable.idForSingleEstablishment = ConstantsVariable.subCatList[index]['catid'];
                  // Navigator.pushReplacement(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.rightToLeft,
                  //         child: SingleEstablishmentScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: 12, right: 12, bottom: 15),
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        // for(String name in names) Cards(unit:name)

                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 320,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    listSearched[index]
                                    ['establishmentimage'],
                                  ))),
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
                                    alignment: Alignment.bottomCenter,
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Text(
                                      listSearched[index]
                                      ['establishmentname'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.josefinSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )))
                      ]),
                ),
              );
            }),
      );
    }
    }
}
