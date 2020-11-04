import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:hexcolor/hexcolor.dart';

class MyTestMultipleImage extends StatefulWidget {
  @override
  _MyTestMultipleImageState createState() => new _MyTestMultipleImageState();
}

class _MyTestMultipleImageState extends State<MyTestMultipleImage> {
  var imageUri;
  List<PlatformFile> imagesfilesList=List();
  List<PlatformFile> imagesAll=List();
  FilePickerResult Pickerresult;


  @override
  void initState() {
    super.initState();

  }

  void loadAssets() async {
    Pickerresult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (Pickerresult != null) {
      setState(() {

        imagesfilesList=Pickerresult.files;
        for(int a=0;a<imagesfilesList.length;a++)
          {
            imagesAll.add(imagesfilesList[a]);
          }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
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
          ],
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
                    onTap: (){

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
      return Flexible(flex: 8,child: Container());
    }
  }

}
