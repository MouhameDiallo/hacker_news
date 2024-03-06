String formatText(String text){
  return text.replaceAll('&#x2F;', "/").replaceAll('&#x27;', "'");
}
bool hasRunToday=false;
bool isFirstDayOfMonth(){
  if(!hasRunToday){
    hasRunToday = true;
    int today = DateTime.now().day;
    return today==1;
  }
  return false;
}