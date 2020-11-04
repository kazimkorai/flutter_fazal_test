import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/user_flow_screens/single_establishment_screen.dart';
import 'package:flutter_fazal_test/utils/dialog_custom.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/loading_dialog.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fazal_test/shared_prefrence/my_sharedPrefrence.dart';
import 'package:flutter_fazal_test/user_flow_screens/sub_categories.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold .dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';
import 'home_screen.dart';

class EditEstablishmentScreen extends StatefulWidget {
  @override
  _EditEstablishmentScreenState createState() =>
      _EditEstablishmentScreenState();
}

class _EditEstablishmentScreenState extends State<EditEstablishmentScreen> {
  var imageUri;
  final _formKey = GlobalKey<FormState>();

  String kGoogleApiKey = "AIzaSyC7e8yNmrrAcBWoCh6m7Qazz83AJiLU48s";
  TextEditingController _textName = TextEditingController();
  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textContactNo = TextEditingController();
  TextEditingController _textAbout = TextEditingController();

  List<PlatformFile> imagesfilesList = List();
  List<PlatformFile> ImagesListFromUri = List();
  FilePickerResult Pickerresult;
  List dropDownListRegion;
  List dropDownListCat;
  String _mySelectionProvince;
  String _selectionCat;
  var firstAddress;
  String latlng ;
  List<String> deletedPreviousImagesListIds = [];
  List<File> imagesAll = [];
  bool isFetch = true;

  String streetaddress = '';
  String city = '';
  TextEditingController _textAddress = TextEditingController();

  Future fetchDropDown() async {
    final response = await http.get(ApiUrls.BASE_API_URL + 'getdropdownapi');
    var responceJson = json.decode(response.body);
    if (responceJson['status']) {
      dropDownListRegion = responceJson['region'];
      dropDownListCat = responceJson['categories'];

      print('*****REgion' + dropDownListRegion.toString());

      return dropDownListRegion;
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<dynamic> listOfImagesFromUrl;
  List<dynamic> listOfBasicDetails;
  String establishmentname = '';

  // String establishmentaddress;
  // String establishmentdetail;
  String supplierrating;
  int noofreviews;
  String useridFromApi;

  Future<List<dynamic>> fetchingImageSingleEstablishment() async {
    if (isFetch) {

        isFetch = false;
        SharedPreferences pref = await SharedPreferences.getInstance();
        String userid = pref.getString('userid');
        final response = await http
            .get(ApiUrls.BASE_API_URL + 'establishmentdetail?userid=${userid}');
        var responceJson = json.decode(response.body);
        _selectionCat = responceJson['detail']['basic_detail']['category'];
        _mySelectionProvince = responceJson['detail']['basic_detail']['region'];
        print(responceJson['detail']['basic_detail']);
        _textName.text = responceJson['detail']['basic_detail']['establishmentname'];
        _textAddress.text = responceJson['detail']['basic_detail']['establishmentaddress'];
        streetaddress=_textAddress.text;
        print('*getAd='+_textAddress.text.toString()+'');
      city= responceJson['detail']['basic_detail']['suppliercity'];
        print('*getAd='+city.toString()+'');
        _textContactNo.text =
        responceJson['detail']['basic_detail']['establishmentcontact'];
        _textEmail.text =
        responceJson['detail']['basic_detail']['establishmentemail'];
        _textAbout.text =
        responceJson['detail']['basic_detail']['establishmentdetail'];
        noofreviews = responceJson['detail']['basic_detail']['noofreviews'];
        supplierrating = responceJson['detail']['basic_detail']['supplierrating'];
        _textAbout.text =
        responceJson['detail']['basic_detail']['establishmentdetail'];
        useridFromApi = responceJson['detail']['basic_detail']['userid'];
        print('**' + supplierrating.toLowerCase());
        listOfImagesFromUrl = responceJson['detail']['images'];
        print(listOfImagesFromUrl.length.toString() + '**listOfImages');
        latlng =await responceJson['detail']['basic_detail']['latlng']+'';
        print('*===>' + latlng.toString()+'');

        return listOfImagesFromUrl;


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

  @override
  void initState() {
    super.initState();
    fetchDropDown();
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
          body: Container(
            child: Builder(
                builder: (context) => FutureBuilder<List<dynamic>>(
                    future: fetchingImageSingleEstablishment(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!_textName.text.isEmpty) {
                        return ListView(
                          children: [
                            Container(
                              height: 200,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: imageUri == null
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 200,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        : Image.file(
                                            imageUri,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        child: getList(),
                                      ),
                                      Container(
                                        height: 100,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            getListOfPickerImages(),
                                            Container(
                                              height: 22,
                                              margin:
                                                  EdgeInsets.only(bottom: 12),
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
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: TextFormField(
                                      enabled: false,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          hintText: 'Name',
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: TextFormField(
                                      enabled: false,
                                        controller: _textEmail,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          hintText: 'Email',
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: TextFormField(
                                      enabled: false,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          hintText: 'Contact Number',
                                        )),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: HexColor('#B1B1B1'),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child:
                                          DropDownRegion(dropDownListRegion)),
                                  InkWell(
                                    onTap: () {
                                      googlePlacePicker();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
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
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: HexColor("#B1B1B1")),
                                            ),
                                            hintText: 'Address',
                                          )),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: HexColor('#B1B1B1'),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: DropDownCat(dropDownListCat)),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(left: 20, top: 25),
                                    child: (Text(
                                      'About Establishment',
                                      style: GoogleFonts.questrial(
                                          color: HexColor('#777777'),
                                          fontSize: 16),
                                    )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: HexColor("#B1B1B1")),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 15),
                              child: RaisedButton(
                                  child: Text(
                                    'UPDATE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: HexColor('#2B748D'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: HexColor('#2B748D'))),
                                  onPressed: () {
                                    {
                                      if (_formKey.currentState.validate()) {
                                        if (imagesAll.length > 0 ) {
                                          if(latlng!=null)
                                            {
                                              UpdateEstablishment();
                                            }

                                          print('valid');
                                        }
                                        else if(listOfImagesFromUrl.length>0)
                                          {
                                            if(latlng!=null)
                                            {
                                              UpdateEstablishment();
                                            }
                                            print(latlng);
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
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
          ),
        ),
      ),
    );
  }

  UpdateEstablishment() async {
    print('*deleted' + imagesAll.toString());
    ShowLoadingDialog.showAlertDialog(context);
    if (imagesAll.length > 0) {
      for (int index = 0; index < imagesAll.length; index++) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String userid = pref.get('userid');
        var request = http.MultipartRequest(
            'POST', Uri.parse(ApiUrls.BASE_API_URL + 'updateestablishment'))
          ..fields['userid'] = userid
          ..fields['name'] = _textName.text
          ..fields['email'] = _textEmail.text
          ..fields['contactnumber'] = _textContactNo.text
          ..fields['province'] = _mySelectionProvince.toString()
          ..fields['category'] = _selectionCat.toLowerCase()
          ..fields['address'] = latlng
          ..fields['about'] = _textAbout.text
          ..fields['streetaddress']=streetaddress
          ..fields['city']=city
          ..fields['previous_images'] = deletedPreviousImagesListIds.toString()
          ..files.add(await http.MultipartFile.fromPath(
            'files[$index]',
            imagesAll[index].path,
          ));
        var response = await request.send();
        print(response);
        print(response.statusCode);
        if (response.statusCode == 200) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('isSupplier', '1');
          print(response.statusCode);
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog.con(
                    'CONGRATULATIONS!',
                    'Establishment Updated Successfully.',
                    'CONTINUE',
                    HomeScreen());
              });
        } else {
          Navigator.pop(context);
        }
        print('Uploaded!');
      }
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userid = pref.get('userid');
      var request = http.MultipartRequest(
          'POST', Uri.parse(ApiUrls.BASE_API_URL + 'updateestablishment'))
        ..fields['userid'] = userid
        ..fields['name'] = _textName.text
        ..fields['email'] = _textEmail.text
        ..fields['contactnumber'] = _textContactNo.text
        ..fields['province'] = _mySelectionProvince.toString()
        ..fields['category'] = _selectionCat.toLowerCase()
        ..fields['streetaddress']=streetaddress
        ..fields['city']=city
        ..fields['address'] = latlng
        ..fields['about'] = _textAbout.text
        ..fields['previous_images'] = deletedPreviousImagesListIds.toString();
      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      print(respStr);
      print(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('isSupplier', '1');
        print(response.statusCode);
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog.con(
                  'CONGRATULATIONS!',
                  'Establishment Updated Successfully.',
                  'CONTINUE',
                  HomeScreen());
            });
      } else {
        Navigator.pop(context);
      }
      print('Uploaded!');
    }
  }

  Widget DropDownCat(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: new Text(
                  item['cat_name'],
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              value: item['cat_id'].toString(),
            );
          }).toList(),
          hint: Text(
            "   Category",
            style: TextStyle(
              color: HexColor('#B1B1B1'),
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

  Widget getList() {
    if (listOfImagesFromUrl != null) {
      return Expanded(
        flex: 8,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listOfImagesFromUrl.length,
          itemBuilder: (BuildContext context, int index) => Card(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    height: 130, width: 100, child: setImageByType(index)),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        print(index);
                        deletedPreviousImagesListIds.add(
                            listOfImagesFromUrl[index]['imageid'].toString());listOfImagesFromUrl.removeAt(index);
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

  Widget getListOfPickerImages() {
    if (imagesAll != null) {
      return Flexible(
        flex: 8,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imagesAll.length,
          itemBuilder: (BuildContext context, int index) => Card(
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

  Widget setImageByType(int index) {
    return CachedNetworkImage(
      imageUrl: listOfImagesFromUrl[index]['establishmentimage'],
      imageBuilder: (context, imageProvider) => Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget DropDownRegion(List data) {
    if (data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: Container(
                margin: EdgeInsets.only(left: 12),
                child: new Text(
                  item['regionname'],
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              value: item['id'].toString(),
            );
          }).toList(),
          hint: Text(
            "  Search Area/City",
            style: TextStyle(
              color: HexColor('#B1B1B1'),
            ),
          ),
          onChanged: (newVal) {
            setState(() {
              _mySelectionProvince = newVal;
              print('_mySelection:' + _mySelectionProvince.toString());
            });
          },
          value: _mySelectionProvince,
        ),
      );
    } else {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
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
      city = firstAddress.locality;
      streetaddress=detail.result.vicinity;
      _textAddress.text = detail.result.vicinity;
      latlng = '(' + lat.toString() + ', ' + lng.toString() + ')';
      print(latlng.toString());
    });
  }
}
