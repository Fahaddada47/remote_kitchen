import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/news_item_card.dart';
import '../controller/news_controller.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final StoryController storyController = Get.put(StoryController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final RxBool isSearching = false.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search News...',
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    searchFocusNode.unfocus();
                    isSearching.value = false;
                    storyController.searchNews('');
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  isSearching.value = false;
                } else {
                  isSearching.value = true;
                }
                storyController.searchNews(value);
              },
              onTap: () {
                isSearching.value = true;
              },
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (storyController.isLoading.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (storyController.filteredNews.isEmpty) {
            return Center(child: Text('No news found.'));
          }
          return ListView.builder(
            itemCount: storyController.filteredNews.length,
            itemBuilder: (context, index) {
              final newsItem = storyController.filteredNews[index];
              return NewsItemCard(newsItem: newsItem);
            },
          );
        }),
      ),
    );
  }
}
