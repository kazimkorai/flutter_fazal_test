

import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:path/path.dart';

class GenericClasses{

  static Widget WidgetScreen;
  static BuildContext context;

  static gotoOtherpushReplacement(BuildContext context, Widget widget){

    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child: widget));
  }

  static gotoOtherScreenWithPush(BuildContext context, Widget widget){
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child: widget));
  }

}