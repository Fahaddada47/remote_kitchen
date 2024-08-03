import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../model/news_model.dart';
import '../controller/news_controller.dart';
import '../widgets/custom_label.dart';
import '../widgets/text_styles.dart';

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
                  Expanded(child: Text(newsItem.url ?? 'No URL provided')),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  newsItem.url ?? '',
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 190,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text(
                newsItem.title ?? 'No Title',
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
                  CustomLabel(
                    labelText: "Comments: ",
                    numberText: newsItem.kids.length.toString(),
                    labelStyle: getTextStyle(),
                    requiredIndicator: true,
                  ),
                  CustomLabel(
                    labelText: "Upvote: ",
                    numberText: newsItem.descendants.toString(),
                    labelStyle: getTextStyle(),
                    requiredIndicator: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 8.0),
                  Text(
                    newsItem.by ?? 'Unknown Author',
                    style: getTextStyle(
                      fontFamily: "Lato",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    newsItem.time != null
                        ? DateFormat.yMMMd().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            newsItem.time * 1000))
                        : 'No Date Available',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                newsItem.text ?? 'No Description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showCommentsBottomSheet(context, newsItem, storyController);
                  },
                  child: Text('Comments (${newsItem.kids.length})'),
                ),
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
                  return ListTile(
                    title: Text(comment.by ?? 'Unknown Author'),
                    subtitle: Text(comment.text ?? 'No Comment Text'),
                  );
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
