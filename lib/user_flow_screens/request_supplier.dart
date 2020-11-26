import 'dart:convert';

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';

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
import 'package:google_maps_webservice/places.dart';

class RequestSupplier extends StatefulWidget {
  @override
  _RequestSupplierState createState() => _RequestSupplierState();
}

class _RequestSupplierState extends State<RequestSupplier> {
  final _formKey = GlobalKey<FormState>();
  String _selectionRegion;
  String _selectionCat;
  TextEditingController _textBudget = TextEditingController();
  TextEditingController _textTimeFrame = TextEditingController();
  TextEditingController _textDesc = TextEditingController();
  TextEditingController _textCityArea = TextEditingController();
  String latlng;
  String city = '';
  String address = '';
  String kGoogleApiKey = "AIzaSyC7e8yNmrrAcBWoCh6m7Qazz83AJiLU48s";
  var first;
  Future fetchDropDown() async {
    final response = await http.get(ApiUrls.BASE_API_URL + 'getdropdownapi');
    var responceJson = json.decode(response.body);
    if (responceJson['status']) {
      setState(() {
        ConstantsVariable.dropDownListRegion = responceJson['region'];
        ConstantsVariable.dropDownListCategories = responceJson['categories'];
      });
      print('*****REgion' + ConstantsVariable.dropDownListRegion.toString());

      return ConstantsVariable.dropDownListRegion;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    if (ConstantsVariable.dropDownListRegion.length == 0) {
      fetchDropDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    print('*bottom' + bottom.toString());

    /*onWillPop: () {
      return Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight, child: HomeScreen()));
    },*/
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: HomeScreen()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: UserTopMenuWithBack(),
          drawer: MyCustomScaffold.getDrawer(context),
          body: Builder(
            builder: (context) => ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor('#B1B1B1'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropDownCat(
                              ConstantsVariable.dropDownListCategories)),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textBudget,
                            keyboardType: TextInputType.number,
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
                              ), hintText: r"Budget ($)",
                              fillColor: HexColor('#B1B1B1'),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textTimeFrame,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Timeframe Required';
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
                              hintText: 'Timeframe (When Do You Need It?)',
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          googlePlacePicker();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: TextFormField(
                              enabled: false,
                              onTap: () {
                                googlePlacePicker();
                              },
                              controller: _textCityArea,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Search Area/City';
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
                                hintText: 'Search Area/City',
                                fillColor: HexColor('#B1B1B1'),
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textDesc,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Description Required';
                              }
                              return null;
                            },
                            maxLines: 8,
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
                              hintText: 'Description',
                              fillColor: HexColor('#B1B1B1'),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                      EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 15),
                  child: RaisedButton(
                      child: Text(
                        'SEND REQUEST',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: HexColor('#2B748D'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#2B748D'))),
                      onPressed: () {
                        {
                          if (_formKey.currentState.validate()) {
                            RequestSupplier();
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

  // Widget DropDownRegions(List data) {
  //   if (data != null) {
  //     return DropdownButtonHideUnderline(
  //       child: DropdownButton(
  //         items: data.map((item) {
  //           return new DropdownMenuItem(
  //             child: new Text(
  //               item['regionname'],
  //               style: TextStyle(fontSize: 14.0),
  //             ),
  //             value: item['id'].toString(),
  //           );
  //         }).toList(),
  //         hint: Text(
  //           "Search Area/City",
  //           style: TextStyle(
  //             color: HexColor('#B1B1B1'),
  //           ),
  //         ),
  //         onChanged: (newVal) {
  //           setState(() {
  //             _selectionRegion = newVal;
  //             print('_mySelection:' + _selectionRegion.toString());
  //           });
  //         },
  //         value: _selectionRegion,
  //       ),
  //     );
  //   } else {
  //     return new Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  // }

  Widget DropDownCat(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: new Text(
                  " " + item['cat_name'],
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              value: item['cat_id'].toString(),
            );
          }).toList(),
          hint: Text(
            "   Search By Category",
            style: TextStyle(
              color: Colors.grey[20],
            ),
          ),
          onChanged: (newVal) {
            setState(() {
              _selectionCat = newVal;
              print('_mySelection:' + _selectionCat.toString());
            });
          },
          value: _selectionCat,
        ),
      );
    } else {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  getLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    setState(() {
      latlng = '(' +
          position.latitude.toString() +
          ', ' +
          position.longitude.toString() +
          ')';
    });

    // '(-33.956409, 25.599670)'
  }

  RequestSupplier() async {
    ShowLoadingDialog.showAlertDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userid = sharedPreferences.get('userid');
    String myurl = ApiUrls.BASE_API_URL + "requestforsupplier";

    await http.post(myurl, headers: {
      'Accept': 'application/json',
    }, body: {
      "userid": userid,
      "searchedcategory": _selectionCat.toString(),
      "budgetrange": _textBudget.text,
      "timeframe": _textTimeFrame.text,
      "latlng": latlng,
      "requestdescription": _textDesc.text,
      'address': address.toString(),
      'city': city
    }).then((response) {
      // print(response.statusCode);
      print(response.body);
      var jsArray = json.decode(response.body);
      String status = jsArray['message'];
      print(status);
      Navigator.pop(context);
      if (status == 'Request created.') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'CONGRATULATIONS!',
                  'Request Successfully Sent To All Local Suppliers In Your Area! Check Your Inbox For Updates On Replies..',
                  'VIEW REQUESTS',
                  InboxScreen());
            });
      } else if (status ==
          'Request created. But no supplier found in your mentioned address') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'CONGRATULATIONS!',
                  'Request Successfully Sent To All Local Suppliers In Your Area! Check Your Inbox For Updates On Replies..',
                  'VIEW REQUESTS',
                  InboxScreen());
            });
      }
    });
  }

  googlePlacePicker() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.fullscreen,
      // Mode.fullscreen
      language: "en",
      onError: (value) => print(value.toString()),
    );
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    print(detail.result.formattedAddress);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;


    Coordinates coordinates=Coordinates(detail.result.geometry.location.lat,detail.result.geometry.location.lng);
    var mainAddress = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     first = mainAddress.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    print('**name' + detail.result.name.toString());
    print('**adrAddress' + detail.result.vicinity);
    print('**formattedAddress===> address' + detail.result.formattedAddress);
    print('**formattedAddress' + detail.result.vicinity);

    print('**result' + detail.result.toString());
    setState(() {
      _textCityArea.text = detail.result.name;
      city = first.locality;
      address = detail.result.vicinity;
      latlng = '(' + lat.toString() + ', ' + lng.toString() + ')';
    });
  }
}
