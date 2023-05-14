import 'package:flutter/material.dart';
import 'package:weatherapp_proj/api/Get.dart';

class Currently extends StatefulWidget {
  String text;
  final textColor;
  String latitude;
  String longitude;
  Currently(
      {super.key,
      required this.text,
      this.textColor,
      required this.latitude,
      required this.longitude});

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  //fetch data at the begginin
  String temp = "";
  String windSpeed = "";
  @override
  void initState() {
    // TODO: implement initState
    getCurrentWeather(widget.longitude, widget.latitude).then((value) {
      setState(() {
        temp = value["current_weather"]["temperature"].toString();
        windSpeed = value["current_weather"]["windspeed"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: getCurrentWeather(widget.longitude, widget.latitude),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(color: widget.textColor, fontSize: 15),
                  ),
                  Text(
                    "$temp °C",
                    style: TextStyle(color: widget.textColor, fontSize: 15),
                  ),
                  Text(
                    "$windSpeed km/h",
                    style: TextStyle(color: widget.textColor, fontSize: 15),
                  ),
                ],
              ));
            } else if (snapshot.hasError) {
              
              return const Text("error while connectiong to server",style: TextStyle(color: Colors.red),);
              
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
