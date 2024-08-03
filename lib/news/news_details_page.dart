import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/news_model.dart';
import '../controller/news_controller.dart';

class NewsDetailsPage extends StatelessWidget {
  final Story newsItem;

  NewsDetailsPage({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    final StoryController storyController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(newsItem.url.isNotEmpty ? newsItem.url : 'No URL provided')),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: newsItem.url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('URL copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                newsItem.title.isNotEmpty ? newsItem.title : 'No Title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Comments: ${newsItem.kids.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Upvotes: ${newsItem.descendants}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 8.0),
                  Text(
                    newsItem.by.isNotEmpty ? newsItem.by : 'Unknown Author',
                    style: const TextStyle(
                      fontFamily: "Lato",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    newsItem.time != 0
                        ? DateFormat.yMMMd().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            newsItem.time * 1000))
                        : 'No Date Available',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                newsItem.text.isNotEmpty ? newsItem.text : 'No Description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showCommentsBottomSheet(context, newsItem, storyController);
                },
                child: Text('Comments (${newsItem.kids.length})'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCommentsBottomSheet(BuildContext context, Story story, StoryController storyController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Obx(() {
              if (storyController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: story.comments.length,
                itemBuilder: (context, index) {
                  final comment = story.comments[index];
                  return MainCommentTile(comment: comment, depth: 0);
                },
              );
            });
          },
        );
      },
    );

    if (story.comments.isEmpty) {
      storyController.fetchComments(story);
    }
  }
}

class MainCommentTile extends StatefulWidget {
  final Story comment;
  final int depth;

  const MainCommentTile({required this.comment, required this.depth});

  @override
  _MainCommentTileState createState() => _MainCommentTileState();
}

class _MainCommentTileState extends State<MainCommentTile> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: Colors.grey[400]!,
              width: 3 + widget.depth.toDouble(), // Indentation based on depth
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    widget.comment.by.isNotEmpty ? widget.comment.by[0].toUpperCase() : 'A',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.comment.by,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMd().add_jm().format(
                      DateTime.fromMillisecondsSinceEpoch(widget.comment.time * 1000)),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(widget.comment.text),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${widget.comment.descendants}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // handle reply action
                  },
                  child: const Text('Reply', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            if (widget.comment.comments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showReplies = !showReplies;
                    });
                  },
                  child: Text(
                    showReplies ? 'Hide replies' : 'View more replies (${widget.comment.comments.length})',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            if (showReplies)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: widget.comment.comments
                      .map((reply) => MainCommentTile(comment: reply, depth: widget.depth + 1))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}
