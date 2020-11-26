import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import 'package:flutter_fazal_test/utils/page_transition.dart';
// code for calling 1 button dialog
// CustomDialogOneButton.showDialogs(context,"assets/images/img_warning_message_dialog.png","Confirm card deletion ","This action cannot be reversed.","Cancel", UserMessages());

// for one button
class CustomDialogOneButton extends StatefulWidget {
  String dialogImage, dialogTitle, dialogDescription, dialogBtnText;
  Widget widgetGoToPage;

  CustomDialogOneButton(this.dialogImage, this.dialogTitle,
      this.dialogDescription, this.dialogBtnText, this.widgetGoToPage);

  static void showDialogs(BuildContext context, dialogImage, dialogTitle,
      dialogDescription, dialogBtnText, widgetGoToPage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: CustomDialogOneButton(dialogImage, dialogTitle,
                dialogDescription, dialogBtnText, widgetGoToPage),
          );
        });
  }

  @override
  CustomDialogOneButtonState createState() => CustomDialogOneButtonState();
}

class CustomDialogOneButtonState extends State<CustomDialogOneButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// To make the card compact
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      widget.dialogImage,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.dialogTitle,
                      style: GoogleFonts.raleway(
                          color: HexColor('#484040'),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.dialogDescription,
                textAlign: TextAlign.left,
                style: GoogleFonts.raleway(
                    fontSize: 15,
                    color: HexColor('#484040'),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.widgetGoToPage.toString() != "Container") {

                        Get.to(widget.widgetGoToPage);
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: widget.widgetGoToPage));
                      }
                    },
                    child: Text(
                      widget.dialogBtnText,
                      style: GoogleFonts.raleway(
                          color: HexColor('#484040'),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// code for calling 2 buttons dialog
// CustomDialogTwoButtons.showDialogs(context,"assets/images/img_warning_message_dialog.png","Confirm card deletion ","This action cannot be reversed.","Cancel",UserMessages(),"Delete Now",UserMessages());

// for two buttons
class CustomDialogTwoButtons extends StatefulWidget {
  String dialogImage,
      dialogTitle,
      dialogDescription,
      dialogBtnPositiveText,
      dialogBtnNegativeText;
  Widget widgetGoToPageOnPositive, widgetGoToPageOnNegative;

  CustomDialogTwoButtons(
      this.dialogImage,
      this.dialogTitle,
      this.dialogDescription,
      this.dialogBtnPositiveText,
      this.widgetGoToPageOnPositive,
      this.dialogBtnNegativeText,
      this.widgetGoToPageOnNegative);

  static void showDialogs(
      BuildContext context,
      dialogImage,
      dialogTitle,
      dialogDescription,
      dialogBtnPositiveText,
      widgetGoToPagePositive,
      dialogBtnNegativeText,
      widgetGoToPageOnNegative) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: CustomDialogTwoButtons(
                dialogImage,
                dialogTitle,
                dialogDescription,
                dialogBtnPositiveText,
                widgetGoToPagePositive,
                dialogBtnNegativeText,
                widgetGoToPageOnNegative),
          );
        });
  }

  @override
  CustomDialogTwoButtonsState createState() => CustomDialogTwoButtonsState();
}

class CustomDialogTwoButtonsState extends State<CustomDialogTwoButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// To make the card compact
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      widget.dialogImage,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.dialogTitle,
                      style: GoogleFonts.raleway(
                          color: HexColor('#484040'),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.dialogDescription,
                textAlign: TextAlign.left,
                style: GoogleFonts.raleway(
                    fontSize: 15,
                    color: HexColor('#484040'),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.widgetGoToPageOnNegative.toString() !=
                          "Container") {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: widget.widgetGoToPageOnNegative));
                      }
                    },
                    child: Text(
                      widget.dialogBtnNegativeText,
                      style: GoogleFonts.raleway(
                          color: HexColor('#484040'),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.widgetGoToPageOnPositive.toString() !=
                          "Container") {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: widget.widgetGoToPageOnPositive));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        widget.dialogBtnPositiveText,
                        style: GoogleFonts.raleway(
                            color: HexColor('#484040'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}