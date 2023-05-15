import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> getCitiesSuggestion(String pattern) async {
  final uri = Uri.parse(
      "http://geocoding-api.open-meteo.com/v1/search?name=${pattern}&count=5&language=en&format=json");
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
//xprint(json["results"].length);
  if (json["results"] == null) return [];
  return json["results"];
}

class WatherProvider {}

Future<Map<String, dynamic>> getCurrentWeather(String long, String lat) async {
  final uri = Uri.parse(
      "http://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${long}&current_weather=true&forecast_days=1");
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  return json;
}

Future<Map<String, dynamic>> getDailyWeather(String long, String lat) async {
  final uri = Uri.parse(
      "http://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&hourly=temperature_2m,weathercode,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=Europe%2FLondon");
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  return json;
}

Future<Map<String, dynamic>> getWeeklyWeather(String long, String lat) async {
  final uri = Uri.parse(
      "http://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&daily=weathercode,temperature_2m_max,temperature_2m_min&current_weather=true&timezone=Europe%2FLondon");
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  return json;
}



String codeToDesc(int code) {
  if (code == 0) return "Clear sky";
  if (code == 1) return "Mainly clear";
  if (code == 2) return "Partly cloudy";
  if (code == 3) return "Overcast";
  if (code == 45) return "Fog";
  if (code == 48) return "Rime fog";
  if (code == 51) return "Drizzle Light";
  if (code == 53) return "Drizzle Moderate";
  if (code == 55) return "Drizzle Dense";
  if (code == 56) return "Freezing Drizzle Light";
  if (code == 57) return "Freezing Drizzle Dense";
  if (code == 61) return "Rain Slight";
  if (code == 63) return "Rain Moderate";
  if (code == 65) return "Rain Heavy";
  if (code == 66) return "Freezing Rain Light";
  if (code == 67) return "Freezing Rain Heavy";
  if (code == 71) return "Snow fall Slight";
  if (code == 73) return "Snow fall Moderate";
  if (code == 75) return "Snow fall Heavy";
  if (code == 77) return "Snow grains";
  if (code == 80) return "Rain showers Slight";
  if (code == 81) return "Rain showers Moderate";
  if (code == 82) return "Rain showers Violent";
  if (code == 85) return "Snow showers Slight";
  if (code == 86) return "Snow showers Heavy";
  if (code == 95) return "Thunderstorm Slight";
  if (code == 96) return "Thunderstorm with slight hail";
  if (code == 99) return "Thunderstorm with heavy hail";
  return "Unknown";
}

//code to icon
IconData codeToicon(int code){
    if (code == 0) return Icons.wb_sunny;
  if (code == 1) return Icons.wb_sunny;
  if (code == 2) return Icons.wb_cloudy_outlined;
  if (code == 3) return Icons.wb_cloudy_outlined;
  if (code == 45) return Icons.wb_cloudy;
  if (code == 48) return Icons.wb_cloudy;
  if (code == 51) return Icons.wb_cloudy;
  if (code == 53) return Icons.wb_cloudy;
  if (code == 55) return Icons.wb_cloudy;
  if (code == 56) return Icons.severe_cold;
  if (code == 57) return Icons.severe_cold;
  if (code == 61) return Icons.cloudy_snowing;
  if (code == 63) return Icons.cloudy_snowing;
  if (code == 65) return Icons.cloudy_snowing;
  if (code == 66) return Icons.cloudy_snowing;
  if (code == 67) return Icons.cloudy_snowing;
  if (code == 71) return Icons.cloudy_snowing;
  if (code == 73) return Icons.cloudy_snowing;
  if (code == 75) return Icons.cloudy_snowing;
  if (code == 77) return Icons.cloudy_snowing;
  if (code == 80) return Icons.cloudy_snowing;
  if (code == 81) return Icons.cloudy_snowing;
  if (code == 82) return Icons.cloudy_snowing;
  if (code == 85) return Icons.cloudy_snowing;
  if (code == 86) return Icons.cloudy_snowing;
  if (code == 95) return Icons.thunderstorm_outlined;
  if (code == 96) return Icons.thunderstorm_outlined;
  if (code == 99) return Icons.thunderstorm_outlined;
  return Icons.sunny;
}
