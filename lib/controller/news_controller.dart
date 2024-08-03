import 'package:get/get.dart';
import 'package:remote_kitchen/model/news_repository.dart';
import '../model/news_model.dart';

class StoryController extends GetxController {
  final StoryRepository _repository = StoryRepository();

  var topStories = <int>[].obs;
  var storiesDetails = <int, Story>{}.obs;
  var filteredNews = <Story>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchTopStories();
    super.onInit();
  }

  void fetchTopStories() async {
    isLoading(true);
    final stories = await _repository.fetchTopStories();
    if (stories != null) {
      topStories.assignAll(stories);
      fetchAllStoryDetails(stories);
    }
    isLoading(false);
  }

  void fetchAllStoryDetails(List<int> storyIds) async {
    for (var id in storyIds) {
      final story = await _repository.fetchStoryDetails(id);
      if (story != null) {
        storiesDetails[id] = story;
        filteredNews.add(story);
      }
    }
  }

  void fetchComments(Story story) async {
    isLoading(true);
    for (var commentId in story.kids) {
      final comment = await _repository.fetchStoryDetails(commentId);
      if (comment != null) {
        story.comments.add(comment);
        if (comment.kids.isNotEmpty) {
          fetchComments(comment);
        }
      }
    }
    isLoading(false);
  }

  void searchNews(String query) {
    if (query.isEmpty) {
      filteredNews.assignAll(storiesDetails.values.toList());
    } else {
      filteredNews.assignAll(
        storiesDetails.values.where((story) =>
        story.title?.toLowerCase().contains(query.toLowerCase()) ?? false).toList(),
      );
    }
  }
}
