import 'package:get/get.dart';
import '../controller/news_controller.dart';
import '../model/news_repository.dart';

class StateHolderBinder extends Bindings {
  @override
  void dependencies() {
    final storyRepository = StoryRepository();
    Get.put(StoryController(repository: storyRepository));
  }
}
