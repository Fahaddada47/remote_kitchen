class Story {
  final dynamic by;
  final dynamic id;
  final List<int> kids;
  final dynamic descendants;
  final dynamic text;
  final dynamic title;
  final dynamic time;
  final dynamic type;
  final dynamic url;
  final dynamic score;

  final List<Story> comments;

  Story({
    required this.by,
    required this.score,
    required this.id,
    required this.kids,
    required this.descendants,
    required this.text,
    required this.title,
    required this.time,
    required this.type,
    required this.url,
    this.comments = const [],
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      by: json['by'],
      score: json['score'],
      id: json['id'],
      kids: List<int>.from(json['kids'] ?? []),
      descendants: json['descendants'] ?? 0,
      text: json['text'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? 0,
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      comments: [],
    );
  }
}
