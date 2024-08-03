import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remote_kitchen/widgets/custom_label.dart';
import 'package:remote_kitchen/widgets/text_styles.dart';
import '../data/model/news_model.dart';
import '../presentation/screens/news_details_page.dart';

class NewsItemCard extends StatelessWidget {
  final Story newsItem;

  const NewsItemCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    newsItem.url ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 97,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.title ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              newsItem.text.isNotEmpty ? newsItem.text : 'No Description',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Lato",
                                fontSize: 14,
                                color: Color(0xff7D7D7D),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => NewsDetailsPage(newsItem: newsItem));
                            },
                            child: const Text(
                              'Read More',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Lato",
                                fontSize: 12,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(DateTime.fromMillisecondsSinceEpoch(newsItem.time * 1000)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomLabel(labelText: "Comment: ", numberText: newsItem.kids.length.toString(),
                            labelStyle: getTextStyle(),
                            requiredIndicator: true,),
                          CustomLabel(labelText: "Upvote: ", numberText: newsItem.score.toString(),
                            labelStyle: getTextStyle(),
                            requiredIndicator: true,),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
