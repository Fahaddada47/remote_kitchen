class Story {
  final dynamic by;
  final dynamic descendants;
  final dynamic id;
  final List<dynamic> kids;
  final dynamic score;
  final dynamic text;
  final dynamic time;
  final dynamic title;
  final dynamic type;
  final dynamic url;

  Story({
    required this.by,
    required this.descendants,
    required this.id,
    required this.kids,
    required this.score,
    required this.text,
    required this.time,
    required this.title,
    required this.type,
    required this.url,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      by: json['by'],
      descendants: json['descendants'],
      id: json['id'],
      kids: List<int>.from(json['kids']),
      score: json['score'],
      text: json['text'],
      time: json['time'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'by': by,
      'descendants': descendants,
      'id': id,
      'kids': kids,
      'score': score,
      'text': text,
      'time': time,
      'title': title,
      'type': type,
      'url': url,
    };
  }
}
