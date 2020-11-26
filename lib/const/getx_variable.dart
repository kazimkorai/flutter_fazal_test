
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetXVariavleConteroller extends GetxController
{
  var  notificationCount= List<String>().obs;
  var textName = TextEditingController().obs;
  var textEmail = TextEditingController().obs;
  var textPassword = TextEditingController().obs;
  var textEditingControllerPhone=TextEditingController().obs;

  var isAcceptedClick=false.obs;


  var defualtDialerCode="ZA".obs;

  void setCount()
  {
    notificationCount.add("a");
    update(notificationCount);
  }

 String  getCount()
 {
   if(notificationCount.length!=0)
     {
       return notificationCount.length.toString();
     }
   else{
     return "";
   }
 }
}