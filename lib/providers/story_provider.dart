
import 'package:flutter/foundation.dart';

import '../../models/story.dart';

class StoryProvider extends ChangeNotifier{
  List<Story> stories = [];
  List<Story> subList = [];
  List<Story> initialList = [];

  void updateFavorites(int position){
    stories[position].isFavorite = !stories[position].isFavorite;
    notifyListeners();
  }
  initializing(List<Story> list){
    initialList = [];
    for (Story story in list){
      initialList.add(story);
    }
    subList = stories;
  }

  void searching(String pattern){
    subList = initialList;
    subList = stories.where((story) => story.title.toLowerCase().contains(pattern.toLowerCase())).toList();
    notifyListeners();
  }

}