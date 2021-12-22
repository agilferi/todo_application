import 'package:intl/intl.dart';

class DateFormatHandler {
  factory DateFormatHandler() {
    return _mainDateFormatHandler;
  }

  DateFormatHandler._internal();

  static final DateFormatHandler _mainDateFormatHandler =
      DateFormatHandler._internal();

  String formatDate(String displayFormat, String dateTime,
      {String serverFormat = 'yyyy-MM-dd HH:mm:ss'}) {
    final DateFormat _serverFormater = DateFormat(serverFormat);
    final DateFormat _displayFormater = DateFormat(displayFormat);
    final String _formattedDate = _displayFormater.format(
      _serverFormater.parse(
        dateTime,
      ),
    );
    return _formattedDate;
  }
}
