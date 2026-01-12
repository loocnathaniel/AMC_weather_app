import 'package:flutter/material.dart';
import 'models/weather.dart';       // Import your Weather model
import 'services/weather_service.dart'; // Import your Weather service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(), // Set your new WeatherPage as the home screen
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Controller to get text from the TextField
  final TextEditingController _cityController = TextEditingController();

  // State variables to hold the weather data, loading status, and any errors
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  // This function is called when the user presses the search button
  Future<void> _fetchWeather() async {
    // If the city name is empty, show an error and do nothing
    if (_cityController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
        _weather = null;
      });
      return;
    }

    // Set the loading state to true to show a progress indicator
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });

    try {
      // Call the weather service to get the weather data
      final weather = await WeatherService.getWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      // If an error occurs, store the error message to display to the user
      setState(() {
        _errorMessage = e.toString().replaceFirst("Exception: ", ""); // Clean up the error message
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SEARCH BAR ---
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchWeather, // Trigger fetch when icon is pressed
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchWeather(), // Also trigger fetch on keyboard submission
            ),
            const SizedBox(height: 20),

            // --- CONTENT AREA ---
            Expanded(
              child: Center(
                child: _buildWeatherContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to decide what to show in the center of the screen
  Widget _buildWeatherContent() {
    if (_isLoading) {
      return const CircularProgressIndicator(); // Show a loading spinner
    }
    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ); // Show an error message
    }
    if (_weather != null) {
      return WeatherInfoCard(weather: _weather!); // Show the weather data
    }
    // Default message before any search is made
    return const Text('Search for a city to see the weather');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cityController.dispose();
    super.dispose();
  }
}

// A separate widget to display the weather information neatly in a card.
class WeatherInfoCard extends StatelessWidget {
  final Weather weather;

  const WeatherInfoCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display the weather icon from OpenWeatherMap
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C', // Format to one decimal place
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Humidity: ${weather.humidity}%'),
                Text('Wind: ${weather.windSpeed.toStringAsFixed(1)} m/s'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
