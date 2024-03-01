
import 'package:flutter/foundation.dart';

import '../../models/story.dart';

class StoryProvider extends ChangeNotifier{
  List<Story> stories = [];



  void updateFavorites(int position){
    stories[position].isFavorite = !stories[position].isFavorite;
    notifyListeners();
  }

}