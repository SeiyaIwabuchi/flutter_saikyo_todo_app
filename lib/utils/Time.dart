import 'package:flutter/material.dart';
import 'package:frontend/utils/Hour.dart';
import 'package:frontend/utils/Minutes.dart';
import 'package:frontend/utils/Second.dart';

class Time {
  final Hour _hour;
  final Minutes _minutes;
  final Second _second;

  Time(this._hour, this._minutes, this._second);

  Second get second => _second;

  Minutes get minutes => _minutes;

  Hour get hour => _hour;

  factory Time.of(int hour, int minute, int second) {
    return Time(Hour(hour), Minutes(minute), Second(second));
  }

  factory Time.from(TimeOfDay timeOfDay) {
    return Time(Hour(timeOfDay.hour), Minutes(timeOfDay.minute), Second(0));
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: _hour.hour, minute: _minutes.minutes);
  }

  String format(String format) {
    return format
        .replaceAll("hh", _hour.hour.toString().padLeft(2, "0"))
        .replaceAll("mm", _minutes.minutes.toString().padLeft(2, "0"))
        .replaceAll("ss", _second.second.toString().padLeft(2, "0"));
  }
}
