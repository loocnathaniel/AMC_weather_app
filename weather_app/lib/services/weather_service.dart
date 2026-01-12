// lib/services/weather_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  // --- FIX ---
  // The API key 'yourAPIq' is invalid.
  // You MUST replace this with your actual key from OpenWeatherMap.
  static const String apiKey = '9c706087a67d1f8305074ecd1ae73cdaq';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeather(String cityName) async {
    // A blank city name will always fail, so we can stop it here.
    if (cityName.isEmpty) {
      throw Exception('City name cannot be empty.');
    }

    final String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

    try {
      final http.Response response = await http.get(Uri.parse(url));

      // Check HTTP response status
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 401) {
        // This is a common error if the API key is wrong.
        throw Exception('Failed to load weather: Invalid API Key. Please check your key in weather_service.dart.');
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the spelling.');
      } else {
        // For other server-side errors.
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catches network errors (like no internet) or the exceptions thrown above.
      // Re-throwing the original error provides more specific details for debugging.
      throw Exception('Error fetching weather: $e');
    }
  }
}
