import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_clock_helper/model.dart';
import './style/themes.dart';

class KorClock extends StatefulWidget {
  const KorClock(this.model);

  final ClockModel model;

  @override
  _KorClockState createState() => _KorClockState();
}

class _KorClockState extends State<KorClock> with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String _separator = ":";
  final _nextAlarm = DateTime.now().add(Duration(minutes: 4));

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(KorClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  String _amPm() {
    return widget.model.is24HourFormat
        ? ""
        : (_dateTime.hour >= 12 ? "pm" : "am");
  }

  String _getHumanReadableAlarmTime() {
    if (_nextAlarm.isBefore(_dateTime)) {
      final hours = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_nextAlarm);
      final minutes = DateFormat('mm').format(_nextAlarm);

      return "Next alarm tomorrow at $hours$_separator$minutes${_amPm()}";
    }

    final nextAlarmDiff = _nextAlarm.difference(_dateTime);

    final hoursDiff = nextAlarmDiff.inHours;
    final minutesDiff = nextAlarmDiff.inMinutes % 60;

    String textualDifference;

    if (hoursDiff == 0 && minutesDiff == 0) {
      return "Ding ding ding!";
    } else if (hoursDiff == 0) {
      textualDifference = "$minutesDiff minutes";
    } else if (minutesDiff == 0) {
      textualDifference = "$hoursDiff hours";
    } else {
      textualDifference = "$hoursDiff hours and $minutesDiff minutes";
    }

    return "Next alarm in $textualDifference";
  }

  WeatherCondition _tomorrowWeather() {
    final weatherValues = WeatherCondition.values;

    final nextWeather = weatherValues.indexOf(widget.model.weatherCondition);

    return weatherValues.elementAt((nextWeather + 1) % weatherValues.length);
  }

  Row _printWeatherWidget(
      TextStyle smallFontStyle,
      Map<WeatherCondition, IconData> themeWeatherIcons,
      Map<KorTheme, Object> theme,
      double smallFontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.model.location,
          style: smallFontStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 0.0),
          child: ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              heightFactor: 1.5,
              widthFactor: 0.75,
              child: Icon(
                themeWeatherIcons[widget.model.weatherCondition],
                color: theme[KorTheme.text],
                size: smallFontSize,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: SizedBox(
            height: smallFontSize * 1.5,
            width: 2.0,
            child: Container(
              decoration: new BoxDecoration(color: theme[KorTheme.text]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 8.0),
          child: ClipRect(
            child: Align(
              alignment: Alignment(4.0, -0.5),
              heightFactor: 1.5,
              widthFactor: 0.75,
              child: Icon(
                themeWeatherIcons[_tomorrowWeather()],
                color: theme[KorTheme.text],
                size: smallFontSize,
              ),
            ),
          ),
        ),
        Text(
          "Tomorrow",
          style: smallFontStyle,
        ),
      ],
    );
  }

  Row _printClockWidget(String hours, String minutes, TextStyle amPmFontStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(hours),
        Text(_separator),
        Text(minutes),
        Text(_amPm(), style: amPmFontStyle),
      ],
    );
  }

  Row _printAlarmWidget(Map<KorTheme, Object> theme, double smallFontSize,
      TextStyle smallFontStyle) {
    return Row(
      children: <Widget>[
        Padding(
          child: Icon(
            Icons.alarm,
            color: theme[KorTheme.text],
            size: smallFontSize,
          ),
          padding: EdgeInsets.only(right: 8.0, bottom: 4.0),
        ),
        Text(
          _getHumanReadableAlarmTime(),
          style: smallFontStyle,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.light
        ? lightTheme
        : darkTheme;
    final Map<WeatherCondition, IconData> themeWeatherIcons =
        theme[KorTheme.weatherIcons];

    final hours =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minutes = DateFormat('mm').format(_dateTime);

    final fontSize = MediaQuery.of(context).size.width / 5;

    final defaultStyle = TextStyle(
      color: theme[KorTheme.text],
      fontFamily: 'Bebas',
      fontSize: fontSize,
    );

    final smallFontSize = fontSize / 8.0;
    final mediumFontSize = fontSize / 4.0;
    final smallFontStyle = TextStyle(
      fontSize: smallFontSize,
    );
    final amPmFontStyle = TextStyle(fontSize: mediumFontSize);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: theme[KorTheme.backgroundColors],
        ),
      ),
      child: DefaultTextStyle(
        style: defaultStyle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _printAlarmWidget(theme, smallFontSize, smallFontStyle),
            _printClockWidget(hours, minutes, amPmFontStyle),
            _printWeatherWidget(
                smallFontStyle, themeWeatherIcons, theme, smallFontSize),
          ],
        ),
      ),
    );
  }
}
