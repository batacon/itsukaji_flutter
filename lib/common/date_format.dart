import 'package:intl/intl.dart';

DateFormat dateFormatSlash = DateFormat('yyyy/MM/dd');
DateFormat dateFormatJp = DateFormat('yyyy年MM月dd日');

String dateFormatSlashString(final DateTime date) {
  return dateFormatSlash.format(date);
}

String dateFormatJpString(final DateTime date) {
  return dateFormatJp.format(date);
}
