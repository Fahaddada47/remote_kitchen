class Urls {
  Urls._();
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const String getStoriesID = '$_baseUrl/topstories.json';
  static String getStoryDetails(int id) => '$_baseUrl/item/$id.json';
}
