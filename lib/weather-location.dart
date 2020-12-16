import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/single-weather.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class WeatherLocation extends StatelessWidget {
int index =0;
WeatherLocation();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context,StateSetter setState) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 130, left: 20),
              child: Row(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: index == 0 ? 12 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.white : Colors.white
                          .withOpacity(0.54),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    // ignore: missing_identifier
                    duration: Duration(milliseconds: 150),
                    margin: EdgeInsets.only(left: 10),
                    width: index == 1 ? 12 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Colors.white.withOpacity(0.54)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),


                ],
              ),
            ),
            PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                // ignore: use_of_void_result
                onPageChanged: (i){
                  setState((){
                    index=i;
                  });
                },
                itemBuilder: (context,i)=>SingleWeather(i)
            ),
          ],
        );
      }
    );
  }
}
