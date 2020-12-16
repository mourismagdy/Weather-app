import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

import 'check_connection.dart';

class SingleWeather extends StatefulWidget {
  int i;
  SingleWeather(this.i);

  @override
  _SingleWeatherState createState() => _SingleWeatherState();
}

class _SingleWeatherState extends State<SingleWeather> {
  String img;
  String svgimg;

  DateTime now = DateTime.now();
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }
  @override
  Widget build(BuildContext context) {

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return Center(
          child: Text(
            'Check your internet connection!',
            style: GoogleFonts.lato(
            fontSize: 20,
            color: Colors.white,
          ),),
        );
        break;
      default:
        return StatefulBuilder(
          builder: (context,StateSetter setState) {
            return Stack(
              children: <Widget>[
                getImage(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4)
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      SizedBox(height: 50,),
                      Center(
                        child: Text(
                          'Refresh',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: (){
                          setState((){
                            now = DateTime.now();
                          }
                          );},
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //City name and time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 150,
                                ),
                                CityName(
                                ),
                                Text(
                                  '${now.hour}:${now.minute}\t\t\t${now.day}-${now
                                      .month}-${now.year}',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            //tempdegree
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TempDegree(),
                                Container(
                                  height: 20,
                                  width: 20,
                                ),
                                Time(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //maxandmin
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3))
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Max',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  getMax(),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Min',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  getMin(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        );

    }
    @override
    void dispose() {
      _connectivity.disposeStream();
      super.dispose();
    }
  }

  Future<Map> getAlexData() async{
    String url='https://www.metaweather.com/api/location/1522006/';
    http.Response response=await http.get(url);
    return json.decode(response.body);
  }

  Future<Map> getCairoData() async{
    String url='https://www.metaweather.com/api/location/1521894/';
    http.Response response=await http.get(url);
    return json.decode(response.body);
  }

  Widget getMax(){
    return FutureBuilder(
        future: widget.i==0?getCairoData():widget.i==1?getAlexData():null ,
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {

          if (snapshot.hasData) {
            Map content = snapshot.data;
            double temp=content['consolidated_weather'][0]['max_temp'];
            int t=temp.round();
            String maxdegree=t.toString();
            return Text(
              maxdegree+' ℃',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  Widget getMin(){
    return FutureBuilder(
        future: widget.i==0?getCairoData():widget.i==1?getAlexData():null ,
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            double temp=content['consolidated_weather'][0]['min_temp'];
            int t=temp.round();
            String mindegree=t.toString();
            return Text(
              mindegree+' ℃',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }

          else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  Widget CityName(){
    return FutureBuilder(
        future: widget.i==0?getCairoData():widget.i==1?getAlexData():null ,
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              child: Text(
                  content['title'],
                  style: GoogleFonts.lato(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
    }
  Widget getImage(){
    return FutureBuilder(
        future: widget.i==0?getCairoData():widget.i==1?getAlexData():null ,
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            String ws= content['consolidated_weather'][0]['weather_state_name'];
            if(ws=='Clear'){
              img= 'assets/sunny.jpg';
            }
            else if(ws=='Showers'){
              img= 'assets/rainy.jpg';
            }
            else{
              img='assets/cloudy.jpeg';
            }
            return Container(
              child: Image.asset(
                img,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  Widget TempDegree(){
    return FutureBuilder(
        future: widget.i==0?getCairoData():getAlexData(),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {

          if (snapshot.hasData) {
            Map content = snapshot.data;
            double temp=content['consolidated_weather'][0]['the_temp'];
            int t=temp.round();
            String degree=t.toString();
            return Text(
              '$degree\t℃',
              style: GoogleFonts.lato(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  Widget Time(){
    return FutureBuilder(
      future: widget.i==0?getCairoData():getAlexData(),
      builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          String ws= content['consolidated_weather'][0]['weather_state_name'];
          if(ws=='Clear'){
            svgimg= 'assets/sun.svg';
          }
          else if(ws=='Showers'){
            svgimg= 'assets/rain.svg';
          }
          else{
            svgimg='assets/cloudy.svg';
          }
          return Row(
            children: <Widget>[
              SvgPicture.asset(svgimg,width: 50,height: 50,color: Colors.white,),
              SizedBox(width: 10,),
              Text(ws,style: TextStyle(color: Colors.white,fontSize: 30),),
            ],
          );
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );
  }
}