
import 'package:flutter/foundation.dart';

import '../../models/story.dart';

class StoryProvider extends ChangeNotifier{
  List<Story> stories = [];
  List<Story> subList = [];

  void updateFavorites(int position){
    stories[position].isFavorite = !stories[position].isFavorite;
    notifyListeners();
  }


  void searching(String pattern){

    subList = stories.where((story) => story.title.toLowerCase().contains(pattern.toLowerCase())).toList();
    notifyListeners();
  }

}