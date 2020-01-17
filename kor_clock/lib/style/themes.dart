import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:weather_icons/weather_icons.dart';

enum KorTheme {
  backgroundColors,
  text,
  shadow,
  weatherIcons,
}

final lightTheme = {
  KorTheme.backgroundColors: [
    Color(0xFF204a69),
    Color(0xFF315b7a),
    Color(0xFF426c8b),
    Color(0xFF537d9c),
  ],
  KorTheme.text: Colors.white,
  KorTheme.shadow: Colors.black,
  KorTheme.weatherIcons: new Map<WeatherCondition, IconData>.from({
    WeatherCondition.sunny: WeatherIcons.day_sunny,
    WeatherCondition.cloudy: WeatherIcons.day_cloudy,
    WeatherCondition.foggy: WeatherIcons.day_fog,
    WeatherCondition.rainy: WeatherIcons.day_rain,
    WeatherCondition.snowy: WeatherIcons.day_snow,
    WeatherCondition.thunderstorm: WeatherIcons.day_thunderstorm,
    WeatherCondition.windy: WeatherIcons.day_cloudy_windy
  }),
};

final darkTheme = {
  KorTheme.backgroundColors: [
    Color(0xFF000000),
    Color(0xFF111111),
    Color(0xFF222222),
    Color(0xFF242424),
  ],
  KorTheme.text: Colors.amber,
  KorTheme.shadow: Colors.black,
  KorTheme.weatherIcons: new Map<WeatherCondition, IconData>.from({
    WeatherCondition.sunny: WeatherIcons.night_clear,
    WeatherCondition.cloudy: WeatherIcons.night_cloudy,
    WeatherCondition.foggy: WeatherIcons.night_fog,
    WeatherCondition.rainy: WeatherIcons.night_rain,
    WeatherCondition.snowy: WeatherIcons.night_snow,
    WeatherCondition.thunderstorm: WeatherIcons.night_thunderstorm,
    WeatherCondition.windy: WeatherIcons.night_cloudy_windy
  }),
};
