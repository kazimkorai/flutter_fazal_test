
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/const/getx_variable.dart';
import 'package:flutter_fazal_test/http/request.dart';
import 'package:flutter_fazal_test/pojo/dropdown_datamodel/drop_down_datamodel.dart';
import 'package:flutter_fazal_test/user_flow_screens/edit_profile_screen.dart';
import 'package:get/get.dart';

class DropDownRegionController extends GetxController
{
  var dropDownRegion = DropDownRegionModel().obs;
  @override
  void onInit() {
    super.onInit();
  }


  Future getAllChatMessages(String deviceToken,String userId) async {
    Future.delayed(
        Duration.zero,
            () => Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false));
    Request request = Request(url: ApiUrls.BASE_API_URL + 'getdropdownapi', body: null,);
    request.get().then((value) {
      dropDownRegion.value  = DropDownRegionModel.fromJson(json.decode(value.body));
      print(json.decode(value.body).toString());
      Get.back();
      Get.to(EditProfileScreen());

    }).catchError((onError) {
      print(onError);
      Get.back();
    });
  }

}