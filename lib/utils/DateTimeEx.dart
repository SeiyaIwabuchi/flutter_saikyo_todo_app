import 'package:frontend/utils/Date.dart';
import 'package:frontend/utils/DayOfMonth.dart';
import 'package:frontend/utils/Hour.dart';
import 'package:frontend/utils/Minutes.dart';
import 'package:frontend/utils/Month.dart';
import 'package:frontend/utils/Second.dart';
import 'package:frontend/utils/Time.dart';
import 'package:frontend/utils/YearMonth.dart';
import 'dart:core' as DartCore;
import 'dart:core';

import 'Year.dart';

typedef DateTimeOrg = DartCore.DateTime;

class DateTimeEx {
  late final Date _date;
  late final Time _time;

  DateTimeEx(Date date, Time time) {
    _date = date;
    _time = time;
  }

  Time get time => _time;

  Hour get hour => _time.hour;

  Minutes get minutes => _time.minutes;

  Second get second => _time.second;

  Date get date => _date;

  DayOfMonth get dayOdMonth => _date.dayOfMonth;

  YearMonth get yearMonth => _date.yearMonth;

  Year get year => _date.year;

  Month get month => _date.month;

  factory DateTimeEx.of(
      int year, int month, int dayOfMonth, int hour, int minutes, int second) {
    return DateTimeEx(
        Date(YearMonth.of(year, month), DayOfMonth.of(dayOfMonth)),
        Time(Hour.of(hour), Minutes.of(minutes), Second.of(second)));
  }

  factory DateTimeEx.now() {
    final now = DartCore.DateTime.now();
    return DateTimeEx.of(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
  }

  DartCore.DateTime toDateTime() {
    return DartCore.DateTime(
        _date.year.year,
        _date.month.month,
        _date.dayOfMonth.dayOfMonth,
        _time.hour.hour,
        _time.minutes.minutes,
        _time.second.second);
  }
}
