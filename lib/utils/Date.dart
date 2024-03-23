import 'package:frontend/utils/YearMonth.dart';

import 'DayOfMonth.dart';
import 'Month.dart';
import 'Year.dart';

class Date {
  final YearMonth _yearMonth;
  final DayOfMonth _dayOfMonth;

  Date(this._yearMonth, this._dayOfMonth);

  DayOfMonth get dayOfMonth => _dayOfMonth;

  YearMonth get yearMonth => _yearMonth;

  Year get year => _yearMonth.year;

  Month get month => _yearMonth.month;

  factory Date.of(int year, int month, int date) {
    return Date(YearMonth.of(year, month), DayOfMonth.of(date));
  }
}