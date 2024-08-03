
import 'package:remote_kitchen/model/news_model.dart';

import '../api_service/network_caller.dart';
import '../utility/urls/urls.dart';

class StoryRepository {
  Future<List<int>?> fetchTopStories() async {
    final response = await NetworkCaller.getRequest(Urls.getStoriesID);
    if (response.isSuccess) {
      return List<int>.from(response.data);
    }
    return null;
  }

  Future<Story?> fetchStoryDetails(int id) async {
    final response = await NetworkCaller.getRequest(Urls.getStoryDetails(id));
    if (response.isSuccess) {
      return Story.fromJson(response.data);
    }
    return null;
  }
}
