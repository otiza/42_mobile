import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Hourly {
  final double time;
  final double temperature;

  Hourly(this.time, this.temperature);
}
class Daily{
  final double day;
  final double max;
  final double min;
  final double month;

  Daily(this.day, this.max, this.min,this.month);
}
List<Hourly> getDataSource(Map<String, dynamic> response) {
  List<double> time = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23
  ];
  List<double> temperature =
      response["hourly"]["temperature_2m"].cast<double>();
  return List.generate(
      time.length, (index) => Hourly(time[index], temperature[index]));
}



class MyChart extends StatelessWidget {
  Map<String, dynamic> data;

  MyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      
      title: ChartTitle(text: 'Hourly Temperature',textStyle: const TextStyle(color: Color.fromARGB(255, 255, 112, 10))),
      series: <ChartSeries>[
        
        LineSeries<Hourly, double>(
          
          color: const Color.fromARGB(255, 255, 112, 10),
          dataSource: getDataSource(data),
          
          xValueMapper: (Hourly hourly, _) => hourly.time,
          yValueMapper: (Hourly hourly, _) => hourly.temperature,
          markerSettings:const  MarkerSettings(isVisible: true),
        ),
      ],
      primaryYAxis: NumericAxis(labelFormat: '{value}°C',
       ),
      
      primaryXAxis: NumericAxis(labelFormat: '{value}:00'),
    );
  }
}
class WeeklyChart extends StatelessWidget {
  Map<String,dynamic> data;
  WeeklyChart({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return  SfCartesianChart(
      title: ChartTitle(text: 'Forecast Temperature',textStyle: const TextStyle(color: Color.fromARGB(255, 255, 112, 10))),
      primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
      legend: Legend(isVisible: true,position:LegendPosition.bottom,height: '5%',width: '100%'),
      series: <ChartSeries>[
        LineSeries<Daily, double>(
          color: const Color.fromARGB(255, 255, 112, 10),
          dataSource: getDailyDataSource(data),
          name: "max",
          xValueMapper: (Daily hourly, _) => hourly.day,
          yValueMapper: (Daily hourly, _) => hourly.max,
          markerSettings:const  MarkerSettings(isVisible: true),
        ),
        LineSeries<Daily, double>(
          color: const Color.fromARGB(255, 18, 23, 108),
          dataSource: getDailyDataSource(data),
          name: "min",
          xValueMapper: (Daily hourly, _) => hourly.day,
          yValueMapper: (Daily hourly, _) => hourly.min,
          markerSettings:const  MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}


List<Daily> getDailyDataSource(Map<String, dynamic> response) {
  List<double> day = [];
  List<double>month=[];
  response["daily"]["time"].forEach((element) {
    day.add(double.parse(element.split("-")[2]));
    month.add(double.parse(element.split("-")[1]));
  });
  List<double> max = response["daily"]["temperature_2m_max"].cast<double>();
  List<double> min = response["daily"]["temperature_2m_min"].cast<double>();
  return List.generate(
      day.length, (index) => Daily(day[index], max[index], min[index],month[index]));
} 