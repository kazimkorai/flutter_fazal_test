import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/const/ConstsVariable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/utils/custom_scaffold%20.dart';
import 'package:flutter_fazal_test/utils/genericMethods.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
import 'package:flutter_fazal_test/utils/user_top_menu_with_btnback.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'login_screen.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreen createState() => _AboutUsScreen();
}

class _AboutUsScreen extends State<AboutUsScreen> {
  YoutubePlayerController _controller;

  void youtubeInit() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          ConstantsVariable.videourlAbout),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    youtubeInit();
    super.initState();
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
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Material(
            child: Scaffold(
              backgroundColor: HexColor('#454547'),
              appBar: UserTopMenuWithBack(),
              drawer: MyCustomScaffold.getDrawer(context),
              body: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ListView(
                  children: [
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
                      child: Text(
                        'About us',
                        style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      margin: EdgeInsets.only(top: 12, left: 30, right: 28),
                    ),
                    Container(
                      child: Text(
                        ConstantsVariable.aboutUs,
                        style: GoogleFonts.questrial(color: Colors.white),
                      ),
                      margin: EdgeInsets.only(top: 20, left: 28, right: 25),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
