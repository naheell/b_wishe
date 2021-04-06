import 'package:b_wishes/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return Dialog(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitRing(
                    color: primaryRainBColor,
                    size: 40.0,
                    lineWidth: 1.0,
                  ),
                  SizedBox(height: 25.0),
                  Text(
                    'Please Wait..',
                    style: textLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  // Timer(
  //     Duration(seconds: 3),
  //     () => Navigator.push(
  //         context,
  //         PageTransition(
  //             duration: Duration(milliseconds: 600),
  //             type: PageTransitionType.fade,
  //             child: Subscription())));
}

showToast({String message, Color bgColor, Color txtColor}) {
  Fluttertoast.showToast(
    msg: '$message',
    backgroundColor: bgColor,
    textColor: txtColor,
  );
}
