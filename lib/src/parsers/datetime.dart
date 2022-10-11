import 'package:mapper/src/parser.dart';

class DateTimeParser extends Parser {
  DateTime? decode(date) {
    return DateTime.tryParse(date);
  }

  String? encode(date) {
    if (date is DateTime) {
      return date.toIso8601String();
    }
    return null;
  }
}
