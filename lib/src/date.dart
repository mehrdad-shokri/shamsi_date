// Copyright 2018 - 2020, Amirreza Madani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library date;

import 'date_formatter.dart';

/// Super interface of Jalali and Georgian classes
abstract class Date {
  /// Minimum computable julian day number
  ///
  /// equivalent to Gregorian(560,3,20) and Jalali(-61,1,1)
  /// and julian day number of 1925675
  static const int minJulianDayNumber = 1925675;

  /// Maximum computable julian day number
  ///
  /// equivalent to Gregorian(3798,12,31) and Jalali(3177,10,11)
  /// and julian day number of 3108616
  static const int maxJulianDayNumber = 3108616;

  /// year
  int get year;

  /// month
  int get month;

  /// day
  int get day;

  /// julian day number
  int get julianDayNumber;

  /// week day number
  int get weekDay;

  /// month length
  int get monthLength;

  /// Formatter for this date object
  DateFormatter get formatter;

  /// checks if this year is a leap year
  bool isLeapYear();
}
