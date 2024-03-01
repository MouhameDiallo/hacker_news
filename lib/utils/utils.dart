String formatText(String text){
  return text.replaceAll('&#x2F;', "/").replaceAll('&#x27;', "'");
}