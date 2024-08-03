import '../../data/model/news_model.dart';
import '../../utility/urls/urls.dart';
import '../api_service/network_caller.dart';

class StoryRepository {
  Future<List<int>?> fetchTopStories() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.getStoriesID);
      if (response.isSuccess) {
        if (response.data is List<dynamic>) {
          return List<int>.from(response.data);
        } else {
         // print('Unexpected data format: ${response.data}');
          return [];
        }
      } else {
        //print('Failed to fetch top stories: ${response.message}');
        return [];
      }
    } catch (e) {
      //print('Error fetching top stories: $e');
      return [];
    }
  }

  Future<Story?> fetchStoryDetails(int id) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.getStoryDetails(id));
      if (response.isSuccess) {
        return Story.fromJson(response.data);
      } else {
      //  print('Failed to fetch story details for ID $id: ${response.message}');
        return null;
      }
    } catch (e) {
     // print('Error fetching story details for ID $id: $e');
      return null;
    }
  }
}
