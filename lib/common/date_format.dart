import 'package:intl/intl.dart';

DateFormat dateFormatSlash = DateFormat('yyyy/MM/dd');
DateFormat dateFormatJp = DateFormat('yyyy年MM月dd日');

String dateFormatSlashString(DateTime date) {
  return dateFormatSlash.format(date);
}

String dateFormatJpString(DateTime date) {
  return dateFormatJp.format(date);
}
