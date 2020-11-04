import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:async/async.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:flutter_fazal_test/supllier_flow/new_request_view_supplier.dart';
import 'package:flutter_fazal_test/supllier_flow/supplier_new_requests_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold%20.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
////AIzaSyD-KeEOpWSXyWZ-Ptl7LkB9wJhcKFa4enM
class RegisterEstablishmentScreen extends StatefulWidget {
  @override
  _RegisterEstablishmentScreenState createState() =>
      _RegisterEstablishmentScreenState();
}

class _RegisterEstablishmentScreenState
    extends State<RegisterEstablishmentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textName = new TextEditingController();
  TextEditingController _textEmail = new TextEditingController();
  TextEditingController _textContactNo = new TextEditingController();
  TextEditingController _textAbout = TextEditingController();
  TextEditingController _textAddress = TextEditingController();


  var imageUri;
  String kGoogleApiKey = "AIzaSyC7e8yNmrrAcBWoCh6m7Qazz83AJiLU48s";
  var firstAddress;
  List<File> imagesAll = [];
  FilePickerResult Pickerresult;
  List<String> listStrFiles = [];
  String latlng;
  String _selectionRegion='1';
  String _selectionCat;
  String streetaddress='';
  String city='';


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
  void loadAssets() async {
    Pickerresult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (Pickerresult != null) {
      setState(() {
        List<File> files =
        Pickerresult.paths.map((path) => File(path)).toList();
        for (int index = 0; index < files.length; index++) {
          imagesAll.add(files[index]);
        }
        print(files.length);
      });
    }
  }

  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) =>
      setState(() {
        rememberMe = newValue;

        if (rememberMe) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });

  @override
  void initState() {
    super.initState();

    if (ConstantsVariable.dropDownListRegion.length == 0) {
      fetchDropDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    GenericClasses.WidgetScreen = HomeScreen();
    GenericClasses.context = context;
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
            builder: (context) =>
            new ListView(
              children: [
                Container(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        margin: EdgeInsets.only(),
                        height: 200,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: imageUri == null
                            ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 200,
                              color: Colors.grey,
                            ),
                            Text(
                              'Add Banner Image',
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                            : Image.file(
                          imageUri,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getList(),
                            Container(
                              height: 22,
                              margin: EdgeInsets.only(bottom: 12),
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  loadAssets();
                                },
                                child: Icon(
                                  Icons.add,
                                  color: HexColor('#777777'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Name Required';
                              } else if (value.length >= 21) {
                                return 'Max length is 20';
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
                              hintText: 'Name',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (!EmailValidator.validate(value)) {
                                return 'Invalid Email';
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
                              hintText: 'Email',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textContactNo,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Contact Number Required';
                              } else if (value.length <= 5) {
                                return 'Length greater than 5 ';
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
                              hintText: 'Contact Number',
                            )),
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor('#B1B1B1'),
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: DropDownRegions(
                              ConstantsVariable.dropDownListRegion)),
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
                              controller: _textAddress,
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
                                hintText: 'Address',
                                focusColor: Colors.grey[25],
                              )),
                        ),
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20, top: 25),
                        child: (Text(
                          'About Establishment',
                          style: GoogleFonts.questrial(
                              color: HexColor('#777777'), fontSize: 16),
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                            controller: _textAbout,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'About Establishment Required';
                              }
                              return null;
                            },
                            maxLines: 7,
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
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 18, right: 25, top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Accept Terms And Conditions',
                              style: GoogleFonts.questrial(
                                  color: HexColor('#777777'), fontSize: 16),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              child: Checkbox(
                                onChanged: _onRememberMeChanged,
                                value: rememberMe,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                  EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 15),
                  child: RaisedButton(
                      child: Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: HexColor('#2B748D'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor('#2B748D'))),
                      onPressed: () {
                        {
                          if (_formKey.currentState.validate()) {
                            if(imagesAll.length>0)
                              {
                                if(rememberMe)
                                  {
                                    if(latlng!=null)
                                      {
                                        try{
                                          sendArrayOfimages();
                                        }
                                        catch(Exception)
                                        {
                                          print('Exception');
                                        }

                                      }
                                    else{
                                      print(latlng.toString()+'is going null');
                                    }


                                  }
                                else{
                                  Fluttertoast.showToast(
                                      msg: "Accept Terms and Conditions",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                                // sendData2();

                                //  UpdateProfileReq();
                              }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Select Image",
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
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getList() {
    if (imagesAll != null) {
      return Flexible(
        flex: 8,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imagesAll.length,
          itemBuilder: (BuildContext context, int index) =>
              Card(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                        height: 130,
                        width: 100,
                        child: Image.file(
                          File(imagesAll[index].path),
                          fit: BoxFit.cover,
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            imagesAll.removeAt(index);
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );
    } else {
      return Flexible(flex: 8, child: Container());
    }
  }

  Widget DropDownRegions(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text("  "+
                item['regionname'],
                style: TextStyle(fontSize: 14.0),
              ),
              value: item['id'].toString(),
            );
          }).toList(),
          hint: Text(
            "   Province",
            style: TextStyle(
                color: Colors.grey[25],
            ),
          ),
          onChanged: (newVal) {
            setState(() {
              _selectionRegion = newVal;
              print('_mySelection:' + _selectionRegion.toString());
            });
          },
          value: _selectionRegion,
        ),
      );
    } else {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget DropDownCat(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text('  '+
                item['cat_name'],
                style: TextStyle(fontSize: 14.0),
              ),
              value: item['cat_id'].toString(),
            );
          }).toList(),
          hint: Text(
            "  Category",
            style: TextStyle(
              color: Colors.grey[25],
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





  getImgaesLoop() {
    imagesAll.forEach((element) {
      return element;
    });
  }

  sendArrayOfimages() async {
    for (int index = 0; index < imagesAll.length; index++) {
      listStrFiles.add(imagesAll[index].path);
    }

    print('* I am Latlng'+latlng.toString()+'');
    ShowLoadingDialog.showAlertDialog(context);
    for(int index=0;index<imagesAll.length;index++)
      {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String userid = pref.get('userid');
        var request = http.MultipartRequest(
            'POST', Uri.parse(ApiUrls.BASE_API_URL + 'addsupplierestablishment'))
          ..fields['userid'] = userid
          ..fields['name'] = _textName.text
          ..fields['email'] = _textEmail.text
          ..fields['contactnumber'] = _textContactNo.text
          ..fields['province'] = _selectionRegion.toString()
          ..fields['category'] = _selectionCat.toLowerCase()
          ..fields['address'] = latlng
          ..fields['streetaddress']=streetaddress.toString()
          ..fields['city']=city
          ..fields['about'] = _textAbout.text
          ..files.add(await http.MultipartFile.fromPath(
            'files[$index]', imagesAll[index].path,

            // contentType: MediaType('application', 'x-tar')
          ));
       var  response = await request.send();

      }
    Navigator.pop(context);
    thenData();

  }
  thenData() async
  {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('isSupplier', '1');
    setState(() {
      ConstantsVariable.isSupplier='1';
      ConstantsVariable.InboxTittle='Customer Inbox';
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog.con(
              'CONGRATULATIONS!',
              'Request Successfully Sent To All Local Customer In Your Area! Check Your Inbox For Updates On Replies.',
              'VIEW REQUESTS',
              SupplierNewRequestScreen());
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
    streetaddress=detail.result.formattedAddress;
    print(streetaddress.toString());
    print('***' + lat.toString());

    Coordinates coordinates=Coordinates(detail.result.geometry.location.lat,detail.result.geometry.location.lng);
    var mainAddress = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    firstAddress = mainAddress.first;
//    print(' ${firstAddress.locality}, ${firstAddress.adminArea},${firstAddress.subLocality}, ${firstAddress.subAdminArea},${firstAddress.addressLine}, ${firstAddress.featureName},${firstAddress.thoroughfare}, ${firstAddress.subThoroughfare}');

    setState(() {
     // streetaddress = detail.result.formattedAddress;
      city = firstAddress.locality;
      streetaddress=detail.result.vicinity;
      _textAddress.text = detail.result.vicinity;
      // _textAddress.text = detail.result.name;
      latlng = '(' + lat.toString() + ', ' + lng.toString() + ')';
      print(latlng.toString());
    });
  }
}
