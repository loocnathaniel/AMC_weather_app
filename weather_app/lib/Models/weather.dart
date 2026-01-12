// lib/models/weather.dart

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon; // Added icon for displaying weather images

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  // This factory constructor is where the main error was.
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      // Handles cases where 'name' might be missing from the API response.
      cityName: json['name'] ?? 'Unknown City',

      // Access nested 'temp' value safely.
      temperature: (json['main']['temp'] as num).toDouble(),

      // Access nested 'description' value.
      description: json['weather'][0]['description'] ?? 'No description',

      // Access nested 'humidity' value.
      humidity: json['main']['humidity'] ?? 0,

      // **THE FIX:** Corrected 'todouble()' to 'toDouble()'.
      // The 'as num' cast makes it safer.
      windSpeed: (json['wind']['speed'] as num).toDouble(),

      // Access nested 'icon' value.
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}
