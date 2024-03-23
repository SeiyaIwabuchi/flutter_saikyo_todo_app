import 'package:frontend/utils/Date.dart';
import 'package:frontend/utils/DayOfMonth.dart';
import 'package:frontend/utils/Month.dart';
import 'package:frontend/utils/Year.dart';

class YearMonth {
  final Year _year;
  final Month _month;

  YearMonth(this._year, this._month);

  Month get month => _month;

  Year get year => _year;

  factory YearMonth.of(int year,int month) {
    return YearMonth(Year.of(year), Month.of(month));
  }

  Date atDay(int dayOfMonth) {
    return Date(this, DayOfMonth.of(dayOfMonth));
  }

  Date atEndOfMonth() {
    final d = DateTime(_year.year, _month.month + 1, 0);
    return Date(this, DayOfMonth.of(d.day));
  }
}
