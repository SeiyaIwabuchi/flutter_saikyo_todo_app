import 'package:frontend/utils/Date.dart';
import 'package:frontend/utils/DateTimeEx.dart';
import 'dart:core' as DartCore;
import 'dart:core';

class Year {
  final int _year;

  Year(this._year);

  Year.of(this._year);

  int get year => _year;

  Date lastDay() {
    final d = DartCore.DateTime(_year + 1, 1, 0);
    return Date.of(d.year, d.month, d.day);
  }

}
