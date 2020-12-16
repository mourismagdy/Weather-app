import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/weather-location.dart';



class WeatherApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}
class _State extends State<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: 'assets/splash.png',
      splashIconSize: 300,
      nextScreen: AfterSplash(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
class AfterSplash extends StatelessWidget {
@override
String img =now.hour>6&&now.hour<18?'assets/sunny.jpg':'assets/night.jpg';
// ignore: implicit_this_reference_in_initializer

static DateTime now = DateTime.now();


Widget build(BuildContext context) {

      return Scaffold(
        extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Center(
            child: Text(
              '',
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.search,
              color: Colors.white,
              size: 30,
              ),
              onPressed: ()=>null,
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                onTap: ()=>null ,
                  child: SvgPicture.asset(
                    'assets/menu.svg',
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        body: WeatherLocation(),
        );
      }
}






