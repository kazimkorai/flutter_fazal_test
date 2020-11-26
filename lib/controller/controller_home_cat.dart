import 'package:connectivity/connectivity.dart';
import 'package:flutter_fazal_test/pojo/home_datamodel.dart';
import 'package:get/get.dart';
import 'package:flutter_fazal_test/http/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/pojo/homde_cat_model.dart';
import 'dart:convert';
import 'package:flutter_fazal_test/apis/ApiUrls.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
class ControllerHomeCat extends GetxController {

  var controllerHomeCat=HomeCatModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void callHomeCat(BuildContext context) async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {

      // Future.delayed(
      //   Duration.zero,
      //       () => Get.dialog(Center(child: CircularProgressIndicator()),
      //       barrierDismissible: false));
    Request request = await Request(url: ApiUrls.BASE_API_URL + 'homecategories', body: {

    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer '
    });
    request.get().then((value) {
      print(json.decode(value.body));
      controllerHomeCat.value = HomeCatModel.fromJson(json.decode(value.body));
     // Get.back();
      new Future.delayed(
          const Duration(seconds: 4),
              () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              ));
     // Get.to(WaiterAboutUs());
    }).catchError((onError) {
      print(onError);
      //Get.back();

   //   CustomDialogOneButton.showDialogs(context,"assets/images/img_warning_message_dialog.png","Error Found","Some error has been found","OK", Container());


    });

  }

  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    controllerHomeCat.close();

  }

}
