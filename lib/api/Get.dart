
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List> getCitiesSuggestion(String pattern) async {
  final uri = Uri.parse("http://geocoding-api.open-meteo.com/v1/search?name=${pattern}&count=5&language=en&format=json");
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  //print(json["results"]);
  if(json["results"] == null) return [];
  return json["results"];
}