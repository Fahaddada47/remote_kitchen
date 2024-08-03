import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remote_kitchen/widgets/comments_tile.dart';

import '../../controller/news_controller.dart';
import '../../data/model/news_model.dart';

class NewsDetailsPage extends StatefulWidget {
  final Story newsItem;

  NewsDetailsPage({required this.newsItem});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final StoryController storyController = Get.find();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(widget.newsItem.url.isNotEmpty
                          ? widget.newsItem.url
                          : 'No URL provided')),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.newsItem.url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('URL copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                widget.newsItem.title.isNotEmpty
                    ? widget.newsItem.title
                    : 'No Title',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto",
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Comments: ${widget.newsItem.kids.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Upvotes: ${widget.newsItem.descendants}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.05),
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.01),
                  const Text("Author: "),
                  Text(
                    widget.newsItem.by.isNotEmpty
                        ? widget.newsItem.by
                        : 'Unknown Author',
                    style: const TextStyle(
                      fontFamily: "Lato",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.newsItem.time != 0
                        ? DateFormat.yMMMd().add_jm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                widget.newsItem.time * 1000))
                        : 'No Date Available',
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                widget.newsItem.text.isNotEmpty
                    ? widget.newsItem.text
                    : 'No Description',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenWidth * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showCommentsBottomSheet(
                        context, widget.newsItem, storyController);
                  },
                  child: Text('Comments (${widget.newsItem.kids.length})'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCommentsBottomSheet(
      BuildContext context, Story story, StoryController storyController) {
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
                  return CommentsTile(comment: comment, depth: 0);
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
