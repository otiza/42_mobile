import 'package:flutter/material.dart';
import 'package:weatherapp_proj/api/Get.dart';
import 'package:weatherapp_proj/components/chart.dart';

class Weekly extends StatelessWidget {
  String text;
  String lat;
  String long;
  Color textColor;
  Weekly(
      {super.key,
      required this.text,
      required this.textColor,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
        future: getWeeklyWeather(long, lat),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              "Error connection to api",
              style: TextStyle(color: Colors.red),
            ));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 23, 50, 69),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // list of daily weather
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: WeeklyChart(data: snapshot.data!)),
                  ),
                  Container(
                    width: double.infinity,
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!["daily"]["time"].length,

                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          //it will be in this format "2023-05-14T00:00"
                          //split it to get hours
                          String time = snapshot.data!["daily"]["time"][index]
                              .split("-")[2];
                          time += "/" +
                              snapshot.data!["daily"]["time"][index]
                                  .split("-")[1];
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  height: 120,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                        "$time ",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 112, 10),
                                            fontWeight: FontWeight.bold),
                                      )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        codeToicon(snapshot.data!['daily']
                                            ['weathercode'][index]),
                                        color: const Color.fromARGB(
                                            255, 255, 112, 10),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                        "${snapshot.data!['daily']['temperature_2m_max'][index]} °C",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 112, 10),
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Center(
                                          child: Text(
                                              "${snapshot.data!['daily']['temperature_2m_min'][index]} °C",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 23, 50, 69),
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
