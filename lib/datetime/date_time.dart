// return today date as ddmmyyyy
String todayDate() {
  //today
  var today = DateTime.now();
  String day = today.day.toString();
  String month = today.month.toString();
  String year = today.year.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  if (month.length == 1) {
    month = '0$month';
  }
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}

//convert string ddmmyyyy to DateTime object
DateTime createDateObject(String ddmmyyyy) {
  int day = int.parse(ddmmyyyy.substring(0, 2));
  int month = int.parse(ddmmyyyy.substring(2, 4));
  int year = int.parse(ddmmyyyy.substring(4, 8));
  DateTime dateObject = DateTime(year, month, day);
  return dateObject;
}

//convert DateTime object to string ddmmyyyy
String createDateString(DateTime dateObject) {
  String day = dateObject.day.toString();
  String month = dateObject.month.toString();
  String year = dateObject.year.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  if (month.length == 1) {
    month = '0$month';
  }
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}
