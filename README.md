# A Flutter package for using Jalali (Shamsi, Solar, Persian, شمسی or خورشیدی) date. You can convert, format and manipulate Jalali and Georgian dates.

[![Pub](https://img.shields.io/pub/v/shamsi_date.svg?color=blue)](https://pub.dev/packages/shamsi_date) [![Build Status](https://travis-ci.org/FatulM/shamsi_date.svg?branch=master)](https://travis-ci.org/FatulM/shamsi_date) [![codecov](https://codecov.io/gh/FatulM/shamsi_date/branch/master/graph/badge.svg)](https://codecov.io/gh/FatulM/shamsi_date)

This is a pure dart package and Algorithm is based on popular JavaScript library [jalaali-js](https://github.com/jalaali/jalaali-js) with more than 20k monthly downloads.

This package has a lot of unit tests with high test coverage for ensuring it's correctness.

If you want a Persian datetime picker there is one based on this library [persian_datetime_picker](https://pub.dev/packages/persian_datetime_picker).

## Key Features

- Convert between [Jalali][], [Gregorian][] and Flutter's [DateTime][] objects.
- Access year, month, day, weekday, Julian day number, month length and ... through getters.
- Format Jalali and Georgian dates with an easy and powerful syntax using [DateFormatter][].
- Ensure Jalali and Georgian dates validity.
- Check if a Jalali or Gregorian year is leap.
- Immutable date objects with copy methods for easy manipulation.
- Compare Dates easily with comparison operators or by using [Comparable][].
- Add or subtract days with + and - operators.
- Add years, months and days separately or as a combination with methods.
- High code coverage with a lot of unit tests.
- Null-Safe API

## Recent Changes

**BREAKING CHANGE:** As of version `0.10.0-nullsafety.0`, `shamsi_date` supports `nullsafety`. Currently you should use flutter beta channel to use nullsafety feature.

**BREAKING CHANGE:** As of version `0.10.0-nullsafety.0`, min and max static constants are renamed according to camelCase.

**BREAKING CHANGE:** As of version `0.9.0`, isValid function is removed from Jalali and Georgian dates. Now **ALL** created date instances are valid. When you are creating a new date instance if think it can be invalid or become out of computable range you should surround code block with try-catch and capture [DateException][].

Jalali and Gregorian classes both have static constants `MIN` and `MAX` which corresponds to minimum and maximum computable date.

**BREAKING CHANGE:** As of version `0.8.0`, most of the methods, constructors and factories throw `ArgumentError` with `null` arguments. This ensures partial validity of state and `non-null` getter and method outputs. Details are provided in dart docs. If you have any concerns file an issue on GitHub.

Now `DateFormatter` has some enforced limitations on dates which are being formatted. It has also some other enhancements.

`AddYears`, `AddMonths` and `AddDays` methods are introduced for adding years, months or days to dates. This methods are safe.

`withYear`,  `withMonth` and `withDay` methods are introduced for making a copy of a date with changed year, month or day.

**BREAKING CHANGE:** As of version `0.7.0`, `toString()` method output is changed to `Jalali(y,m,d)` for Jalali and `Gregorian(y,m,d)` for Gregorian. **Use** formatter for custom formatting.

## Issues and feature requests

If you want a feature or you found an issue, please make an issue on GitHub so I can see your request.

## Usage

Add it to your pubspec.yaml file:

If you want to use `nullsafety` feature:
```yaml
dependencies:
    shamsi_date: ^0.10.0-nullsafety.0
```
And for legacy non-nullsafe projects:
```yaml
dependencies:
    shamsi_date: ^0.9.1
```

[Jalali][] class is used for **Shamsi (Jalali, Persian, شمسی or خورشیدی)** date and [Gregorian][] class is used for **Gregorian (Miladi or میلادی)** date. Jalali and Gregorian classes are the subclasses of [Date][].

Jalali and Gregorian can be instantiated with providing `year`, `month` and `day` among other ways:

```dart
Jalali j = Jalali(year, month, day);
Gregorian g = Gregorian(year, month, day);
```
Month and day has default value of `1` if you don't specify them, so `Jalali(year, month)` is equivalent to `Jalali(year, month, 1)` and `Gregorian(year)` is equivalent to `Gregorian(year, 1, 1)`.

Constructor arguments should be non-null or exception will be thrown immediately. This ensures objects being in valid state when created. So year, month and day are always non-null. Almost all methods, operators, constructors and factories should have non-null arguments and they will return non-null objects. For example year, month and day getters will return non-null results. The only exception for methods which can accept null arguments are methods with optional arguments like `add(...)` and `copy(...)`. **in nullsafe version:** nullable and non-nullable argument and return types are checked statically.

All created date instances are valid. When creating a date instance either by using constructors and factories or by using methods and operators on an existing date instance, if the new date is invalid (by it's month or day being out of range) or it is out of computable range, a [DateException][] exception is thrown. So if you think the new date instance can become invalid or out of range you should soround it with try-catch and catching `DateException`. Minimum computable date is `Gregorian(560,3,20)` or equivalently `Jalali(-61,1,1)` and Maximum computable date is `Gregorian(3798,12,31)` or equivalently `Jalali(3177,10,11)`. For example:

```dart
main() {
  try {
    Jalali jv = Jalali(1398, 13, 1); // not valid!
  } on DateException catch (e) {
    // prints: DateException: Jalali month is out of valid range.
    print(e);
  }
}
```

Jalali and Gregorian objects are immutable. So using operators and methods will give you  new object and does not manipulate the object in place, like String objects. Almost all other objects in shamsi_date library are immutable too.

You can access `year`, `month`, `day` through getters on Jalali or Gregorian dates. You can get week day number of Jalali and Gregorian by using `weekDay` getter. Week days range from 1 to 7. Jalali week starts with `Shanbe` and Gregorian week starts with `Monday`. Month length can be accessed using `monthLength` getter. Month length is sensitive to leap years. you can check if the year is a leap year by `isLeapYear()` method. Julian day number is also accessible through `julianDayNumber` getter. for example:

```dart
Jalali j = Jalali(1397, 5, 6);

int jy = j.year; // jy = 1397
int jm = j.month; // jm = 5
int jd = j.day; // jd = 6

int wd = j.weekDay; // wd = 1 (Shanbe)

// month length of 1397/5
// note: day value is not important for monthLength
int ml = j.monthLength; // ml = 31

// check if 1397 is a leap year
// note: month and day values are not important for isLeapYear() method
bool ly = j.isLeapYear(); // ly = false (1397 is not leap year)

// and equivalently for Gregorian date objects ...
```

You can convert Jalali date to Gregorian by using `toGregorian()` method and convert Gregorian to Jalali date by using `toJalali()` method. There are also factory methods `Jalali.fromGregorian(...)` and `Gregorian.fromJalali(...)` which can be used alternatively.

```dart
Jalali j = Jalali(1397, 5, 6);
// convert to Gregorian:
Gregorian j2g1 = j.toGregorian(); // -> 2018/8/28
// or equivalently:
Gregorian j2g2 = Gregorian.fromJalali(j);

Gregorian g = Gregorian(2019, 10, 26);
// convert to Jalali:
Jalali g2j1 = g.toJalali(); // -> 1398/8/4
// or equivalently:
Jalali g2j2 = Jalali.fromGregorian(g);
```

You can convert [DateTime][] objects directly to Jalali or Gregorian dates by using `fromDateTime(dateTime)` static methods. And convert Jalali and Gregorian to DateTime by using `toDateTime()` method.  And you can get Jalali and Gregorian dates for now by using `now()` factory.

```dart
// convert from DateTime
Jalali j = Jalali.fromDateTime(dateTime);
Gregorian g = Gregorian.fromDateTime(dateTime);

// convert to DateTime
DateTime j2dt = j.toDateTime();
DateTime g2dt = g.toDateTime();

// get now
Jalali jNow = Jalali.now();
Gregorian gNow = Gregorian.now();
```

Jalali and Georgian dates are immutable so you can not change their properties in place. if you want only to change some fields of a Jalali or Gregorian date you can use `copy(...)` method or `withYear`, `withMonth` and `withDay` methods on an existing object. This methods can be chained. **It is recommended** to use withYear, withMonth and withDay methods over copy method. **note** that It is your responsibility to avoid month length bound (for example changing month of `31 Farvardin 1390` to `Esfand`) or leap crash (for example being in last day of year in a leap year and changing year to a non-leap one) in intermediate steps. order of operations is important. copy method order is not guarantied.

for example for getting date at start of this month in Jalali: (copy method makes another object instance and leaves the original one unchanged)

```dart
Jalali j1 = Jalali.now().withDay(1); // correct way
// or by using copy method:
Jalali j2 = Jalali.now().copy(day: 1); // also correct

// DON NOT do it like this:
Jalali j3 = Jalali(Jalali.now().year, Jalali.now().month, 1); // INCORRECT
```
Or if you want to get last day of the last month of this Jalali year:
```dart
// at first go to first day of last month: (Avoid leap crash)
Jalali tmp = Jalali.now().withDay(1).withMonth(12);
// since we can be in a leap year we use monthLength for going to last day:
Jalali j = tmp.withDay(tmp.monthLength);

// or by using copy method:
Jalali tmp1 = Jalali.now().copy(month: 12, day: 1);
Jalali j1 = tmp.copy(day: tmp1.monthLength);
```
or to find 3rd day of 2nd month of this year:
```dart
Jalali j = Jalali.now().withDay(3).withMonth(2);

// or by using copy method:
Jalali j1 = Jalali.now().copy(month: 2, day: 3);
```
or If you want your Jalali and Gregorian objects to fall back to today if null is provided as their constructor arguments you can use copy method from now factory method, for example for Jalali:
```dart
Jalali j = Jalali.now().copy(year: y, month: m, day: d);
// y, m and d can be null
```

You can add and subtract days to Jalali and Gregorian using `+` and `-` operators. It is guaranteed to give you a bound valid date. for example it will go to next month or next year if needed and they won't have leap crash.

You can add years, months or days to  Jalali and Gregorian using `addYears`, `addMonths` and `addDays`. This methods can be chained and they will not have range crash. `addDays` can change month and year. `addMonths` can change year. **note** that it is your responsibility to avoid leap crash.

If you want you can add a combination of days, months or years to a date object with `add` method. **note** that `add` method does not manipulate result to become bound valid, it is your responsibility. **It is recommended** to use addYear, addMonth and addDay methods over add method.

```dart
Jalali j1 = Jalali(1398, 8, 4);
// add days
Jalali j2 = j1 + 3; // -> 1398/8/7
// result will be manipulated to become valid:
Jalali j3 = j1 + 30; // -> 1398/9/4
Jalali j4 = j1 + 365; // -> 1399/8/4
// subtract days
Jalali j5 = j1 - 2; // -> 1398/8/2

// add years, months and days:
Jalali j6 = j1.addYears(1).addMonths(2).addDays(3); // 1399/10/7
// or:
Jalali j60 = j1.add(years: 1, months: 2, days: 3); // 1399/10/7
// add years and days only:
Jalali j7 = j1.addYears(1).addDays(3); // 1399/8/7
// or:
Jalali j70 = j1.add(years: 1, days: 3); // 1399/8/7
// add months only:
Jalali j8 = j1.addMonths(2); // 1398/10/3
// or:
Jalali j80 = j1.add(months: 2); // 1398/10/3
// if you want to subtract you can add negative value:
Jalali j9 = j1.addYears(-1); // 1397/8/3
// or:
Jalali j90 = j1.add(years: -1); // 1397/8/3

// addYears, addMonths and addDays methods are bound safe
// add(...) method is NOT bound safe
```

Date formatting is easy. You should make a function for custom formatting and then pass your Jalali or Gregorian dates to this function.

For example if you want to format as `WeekDayName Day MonthName TwoDigitYear` you make a function for it:

```dart
String format1(Date d) {
  final f = d.formatter;

  return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
}

// example output for Jalali: "پنج شنبه 21 دی 91"
// example output for Gregorian: "Thursday 10 January 13"
```
Or if you want to format as `FourDigitYear/TwoDigitMonth/TwoDigitDay` or `YYYY/MM/DD`, you make a function for it:

```dart
String format2(Date d) {
  final f = d.formatter;

  return '${f.yyyy}/${f.mm}/${f.dd}';
}
```
And use it like before.

**Note** that formatter formats digits in English so if you want Persian digits you can use fonts with Persian digits or apply a simple mapping to formatter output to change English digits to Persian.

Jalali and Georgian dates support `toString()` method. For Jalali it is semantically equivalent to use
a formatter as `Jalali(Y,M,D)` which means:

```dart
String toStringFormatter(Jalali d) {
  final f = d.formatter;

  return 'Jalali(${f.y},${f.m},${f.d})';
}
```
And for Georgian, toString() is equivalent to using a formatter as `Georgian(Y,M,D)`
Note: in the following code toString() is called implicitly:

```dart
main() {
    print(Jalali.now());
    final str = 'today is: ${Georgian.now()}';
}
```
Use toString() of Jalali and Georgian dates only for development purpose, like for debugging, logging or ... **You should** use custom formatter for showing dates on UI.

**Note** also that you do not need for example to use `int.parse()` on formatter output of `Jalali.now().formatter.m` for accessing it's month, simply use `Jalali.now().month`.

[DateFormatter][] has these getters:
- y: year (whatever length it has). year should be positive.
- yy: two digit year. year should be between 1000 and 9999.
- yyyy: four digit year. year should be between 0 and 9999.
- m: month (whatever length it has).
- mm: two digit month.
- mN: month name.
- d: day (whatever length it has).
- dd: two digit day.
- wN: week day name.

You can get date formatter by using `formatter` getter on Jalali and Gregorian date objects. Simply cash this formatter in a Jalali value and then use string interpolation (as we have shown in examples) for making your desired output. This way of formatting is more powerful (and arguably easier) than using templates.

Jalali and Gregorian classes are [Comparable][] so you can compare them using `compareTo` method. You can also use comparison operators to compare them. They also support `equals` and `hashCode` functions. So you can safely use Sets and Maps of Jalali and Gregorian dates.

```dart
Jalali j1 = Jalali(1397, 1, 1);
Jalali j2 = Jalali(1397, 2, 1);

bool b1 = j1 < j2; // b1 = true
bool b2 = j1 >= j2; // b2 = false
// using Comparable's compareTo
bool b3 = j1.compareTo(j2) > 0; // b3 = false (means j1 > j2 is false)
bool b4 = j1.compareTo(j2) <= 0; // b4 = true (means j1 <= j2 is true)
bool b5 = j1 == j2; // b5 = false
bool b6 = j1 != j2; // b6 = true
```

## Example

Here is a complete example. If you did not find what you are looking for, you can check `test/shamsi_date_test.dart` file which includes unit tests.

```dart
import 'package:shamsi_date/shamsi_date.dart';

main() {
  // Gregorian to Jalali conversion
  Gregorian g1 = Gregorian(2013, 1, 10);
  Jalali j1 = g1.toJalali();
  print('$g1 == $j1');
  // prints: Gregorian(2013,1,10) == Jalali(1391,10,21)
  // you can write Jalali.fromGregorian(g1) instead of g1.toJalali()

  // access year, month and day through getters
  // for Jalali:
  int j1y = j1.year; // j1y = 1391
  int j1m = j1.month; // j1m = 10
  int j1d = j1.day; // j1d = 21
  // and for Gregorian:
  int g1y = g1.year; // g1y = 2013
  int g1m = g1.month; // g1m = 1
  int g1d = g1.day; // g1d = 10

  // Jalali to Gregorian conversion
  Jalali j2 = Jalali(1391, 10, 21);
  Gregorian g2 = j1.toGregorian();
  print('$j2 == $g2');
  // prints: Jalali(1391,10,21) == Gregorian(2013,1,10)
  // also can use Gregorian.fromJalali(j1) instead of j1.toGregorian()

  // find weekDay
  print('$j1 has weekDay ${j1.weekDay}'); // -> 6
  // 6 means "پنج شنیه"
  print('$g1 has weekDay ${g1.weekDay}'); // -> 4
  // 4 means "Thursday"

  // find month length
  print('Jalali 1390/12 month length? '
      '${Jalali(1390, 12).monthLength}'); // -> 29
  print('Gregorian 2000/2 month length? '
      '${Gregorian(2000, 2).monthLength}'); // -> 29

  // check leap year
  print('1390 Jalali is leap year? '
      '${Jalali(1390).isLeapYear()}'); // -> false
  print('2000 Gregorian is leap year? '
      '${Gregorian(2000).isLeapYear()}'); // -> true

  // validity:
  // ALL created instances are considered VALID
  // if you think a date might invalid, use try-catch:
  try {
    Jalali jv = Jalali(1398, 13, 1); // not valid!
  } on DateException catch (e) {
    // prints: DateException: Jalali month is out of valid range.
    print(e);
  }
  // making leap crash will also throw exception:
  // for ex: Jalali(1394, 12, 30) will crash, since
  //  1394 is not leap year
  // creating dates out of computable range also throws DateException.

  // convert DateTime object to Jalali and Gregorian
  DateTime dateTime = DateTime.now();
  print('now is $dateTime');
  print('now is ${Gregorian.fromDateTime(dateTime)} in Gregorian');
  print('now is ${Jalali.fromDateTime(dateTime)} in Jalali');
  // convert to DateTime
  print('$j1 is ${j1.toDateTime()}');
  print('$g1 is ${g1.toDateTime()}');

  // convert Jalali and Gregorian to DateTime
  print('$j1 as DateTime is ${j1.toDateTime()}');
  print('$g1 as DateTime is ${g1.toDateTime()}');

  // find today with now() factory method
  print('now is ${Gregorian.now()} in Gregorian');
  print('now is ${Jalali.now()} in Jalali');
  // find out which jalali year is this year:
  int thisJalaliYear = Jalali.now().year;

  // copy method
  print('$j1 with year = 1300 is ${j1.copy(year: 1300)}');
  // prints: 1391/10/21 with year = 1300 is 1300/10/21
  print('$g1 with month = 1 and day = 2 is ${g1.copy(month: 1, day: 2)}');
  // prints: 2013/1/10 with month = 1 and day = 2 is 2013/1/2

  // withYear, withMonth and withDay methods:
  // these methods can be chained
  // it is recommended to use these methods over copy method
  print('$j1 with year = 1300 is ${j1.withYear(1300)}');
  // prints: 1391/10/21 with year = 1300 is 1300/10/21
  print('$g1 with month = 1 and day = 2 is ${g1.withDay(2).withMonth(1)}');
  // prints: 2013/1/10 with month = 1 and day = 2 is 2013/1/2

  // for example for getting date at start of this month in Jalali:
  print(Jalali.now().copy(day: 1));
  // for example to find 3rd day of 2nd month of this year:
  print(Jalali.now().copy(month: 2, day: 3));
  // DON NOT do it like this:
  print(Jalali(Jalali.now().year, Jalali.now().month, 1)); // INCORRECT
  // for example if you want to get last day of the last month of this Jalali year:
  Jalali tmp = Jalali.now().copy(month: 12, day: 1);
  // since we can be in a leap year we use monthLength:
  print(tmp.copy(day: tmp.monthLength));

  // add and subtract days
  Jalali d1 = Jalali(1398, 8, 4);
  // add days
  print(d1 + 3); // -> 1398/8/7
  // result will be manipulated to become valid:
  print(d1 + 30); // -> 1398/9/4
  print(d1 + 365); // -> 1399/8/4
  // subtract days
  print(d1 - 2); // -> 1398/8/2
  // add years, months and days:
  print(d1.add(years: 1, months: 2, days: 3)); // 1399/10/7
  // add years and days only:
  print(d1.add(years: 1, days: 3)); // 1399/8/7
  // add months only:
  print(d1.add(months: 2)); // 1398/10/3
  // if you want to subtract you can add negative value:
  print(d1.add(years: -1)); // 1397/8/3
  // and also for Gregorian

  // or you can use addYears, addMonths and addDays method
  // it is recommended to use these methods over add method
  // these methods are bound valid which means result will be
  //  manipulated to become valid, but add method is not
  print(d1.addDays(30)); // -> 1398/9/4
  print(d1.addDays(365)); // -> 1399/8/4
  print(d1.addYears(1).addMonths(2).addDays(3)); // 1399/10/7
  print(d1.addYears(1).addDays(3)); // 1399/8/7
  print(d1.addMonths(2)); // 1398/10/3
  print(d1.addYears(-1)); // 1397/8/3

  // formatting examples:

  // example one:
  String format1(Date d) {
    final f = d.formatter;

    return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
  }

  print(format1(j1)); // prints: پنج شنبه 21 دی 91
  print(format1(g1)); // prints: Thursday 10 January 13

  // example one:
  String format2(Date d) {
    final f = d.formatter;

    return '${f.dd}/${f.mm}/${f.yyyy}';
  }

  print(format2(j1)); // prints: 21/10/1391
  print(format2(g1)); // prints: 10/01/2013

  // DO NOT use formatter for accessing year, month or other properties
  // of date objects they are available as getters on date objects
  // INCORRECT EXAMPLE, DO NOT USE THIS:
  int ty1 = int.parse(Jalali.now().formatter.yyyy); // INCORRECT
  // use this:
  int ty2 = Jalali.now().year; // correct
  // also using toString() for showing dates on UI is not recommended,
  // use custom formatter.

  // comparing dates examples:
  print(j1 > j2); // -> false
  print(j1.compareTo(j2) > 0); // -> false
  print(j1 <= j2); // -> true
  print(j1.compareTo(j2) <= 0); // -> true
  print(g1 >= g2); // -> true
  print(g1.compareTo(g2)); // -> 0
  print(g1 == g2); // -> true
  print(g1 != g1); // -> false

  // if you want to compare Jalali with Georgian you can convert one type to another,
  // for example:
  print(j1.toGregorian() == g1); // -> true
  // but if you don't want to convert them you can use julianDayNumber
  // (this approach is not recommended)
  print(j1.julianDayNumber == g1.julianDayNumber); // -> true
  // this means that they are equal
  // you can also use other comparison operators
}
```

[Jalali]: https://pub.dev/documentation/shamsi_date/latest/shamsi_date/Jalali-class.html
[Gregorian]: https://pub.dev/documentation/shamsi_date/latest/shamsi_date/Gregorian-class.html
[DateTime]: https://api.flutter.dev/flutter/dart-core/DateTime-class.html
[Date]: https://pub.dev/documentation/shamsi_date/latest/shamsi_date/Date-class.html
[DateFormatter]: https://pub.dev/documentation/shamsi_date/latest/shamsi_date/DateFormatter-class.html
[Comparable]: https://api.flutter.dev/flutter/dart-core/Comparable-class.html
[DateException]: https://pub.dev/documentation/shamsi_date/latest/shamsi_date/DateException-class.html
