String formatText(String text){
  return text.replaceAll('&#x2F;', "/").replaceAll('&#x27;', "'");
}

bool isFirstDayOfMonth(){
  int today = DateTime.now().day;
  return today==1;
}