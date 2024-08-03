import 'package:get/get.dart';

import '../data/model/news_model.dart';
import '../domain/repository/news_repository.dart';

class StoryController extends GetxController {
  final StoryRepository repository;

  StoryController({required this.repository});

  var topStories = <int>[].obs;
  var storiesDetails = <int, Story>{}.obs;
  var filteredNews = <Story>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchTopStories();
    super.onInit();
  }

  Future<void> fetchTopStories({ bool forceRefresh = false}) async {
    isLoading(true);
    try {
      final stories = await repository.fetchTopStories();
     // print("Fetched top stories: $stories");
      if (stories != null && stories.isNotEmpty) {
        topStories.assignAll(stories);
        fetchAllStoryDetails(stories);
      } else {
        topStories.clear();
        filteredNews.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllStoryDetails(List<int> storyIds) async {
    for (var id in storyIds) {
      final story = await repository.fetchStoryDetails(id);
     // print("Fetched story details for ID $id: $story");
      if (story != null) {
        storiesDetails[id] = story;
        filteredNews.add(story);
      }
    }
  }

  Future<void> fetchComments(Story story) async {
    for (var commentId in story.kids) {
      final comment = await repository.fetchStoryDetails(commentId);
      if (comment != null) {
        story.comments.add(comment);
        await fetchComments(comment);
      }
    }
  }

  void searchNews(String query) {
    if (query.isEmpty) {
      filteredNews.assignAll(storiesDetails.values.toList());
    } else {
      filteredNews.assignAll(
        storiesDetails.values.where((story) =>
            story.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}
