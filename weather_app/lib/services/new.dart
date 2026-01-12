// test/weather_model_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart'; // Adjust path if needed

void main() {
  group('Weather.fromJson', () {
    test('should correctly parse a valid JSON response', () {
      // Realistic sample JSON from OpenWeatherMap for Manila
      const String jsonString = '''
      {
        "coord": {"lon": 120.98, "lat": 14.6},
        "weather": [{"id": 803, "main": "Clouds", "description": "broken clouds", "icon": "04n"}],
        "base": "stations",
        "main": {"temp": 28.6, "feels_like": 33.03, "temp_min": 27.78, "temp_max": 29, "pressure": 1009, "humidity": 79},
        "visibility": 10000,
        "wind": {"speed": 3.09, "deg": 210},
        "clouds": {"all": 75},
        "dt": 1673481600,
        "sys": {"type": 1, "id": 8160, "country": "PH", "sunrise": 1673475459, "sunset": 1673516569},
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      }
      ''';

      // 1. Decode the JSON
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // 2. Call the fromJson factory
      final weather = Weather.fromJson(jsonMap);

      // 3. Assert and verify the values
      expect(weather.city, 'Manila');
      expect(weather.temperature, 28.6);
      expect(weather.description, 'broken clouds');
      expect(weather.humidity, 79);
      expect(weather.windSpeed, 3.09);
    });

    test('should throw an error if required fields are missing', () {
      // JSON missing the entire 'main' and 'wind' objects
      const String incompleteJsonString = '''
      {
        "name": "Nowhere",
        "weather": [{"description": "clear sky", "icon": "01d"}]
      }
      ''';

      final Map<String, dynamic> jsonMap = json.decode(incompleteJsonString);

      // Verify that calling fromJson with incomplete data throws an error.
      // A NoSuchMethodError occurs when trying to access a key (like 'temp') on a null object (like 'main').
      expect(() => Weather.fromJson(jsonMap), throwsA(isA<NoSuchMethodError>()));
    });
  });
}
