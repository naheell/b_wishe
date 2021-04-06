import 'package:b_wishes/pages/add.dart';
import 'package:b_wishes/pages/list.dart';
import 'package:flutter/material.dart';
import 'package:b_wishes/constant/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class WalkThrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: primaryPinkColor,
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 100.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1],
            colors: [
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            Expanded(
              child: textIntroduction(),
            ),
            Expanded(
              child: illustrationIntroduction(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                child: buttonIntroduction(context),
                padding: EdgeInsets.only(bottom: 35),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Wish',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 40,
              ),
            ),
            TextSpan(
              text: 'Birthday',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'Pacifico',
                color: primaryRainBColor,
                fontSize: 40,
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 40.0,
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text:
                  'Bienvenue, vous allez rendre heureux.se ceux qui compte vraiment pour vous et nous allons vous aider ',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 23.0,
                  fontWeight: FontWeight.w200,
                  color: primarySnowColor),
            )
          ]),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    );
  }

  Widget buttonIntroduction(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200, height: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft, child: HomeFire()));
        },
        child: Text(
          'Commencer',
          style: TextStyle(fontSize: 17.0),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryRainBColor),
        ),
      ),
    );
  }

  Widget illustrationIntroduction() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SvgPicture.asset('assets/svg/accueil.svg'),
    );
  }
}
