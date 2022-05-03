import 'package:get/get.dart';
import 'package:memes/apis/get_meme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemeController extends GetxController {
  var memes = MemeBig().obs;
  var subreddit = 'Cats';
  var isLoading = true.obs;
  @override
  void onInit() async {
    reloadMemes();
    super.onInit();
  }

  reloadMemes() async {
    await SharedPreferences.getInstance().then((prefs) {
      subreddit = prefs.getString('subreddit') ?? 'Cats';
    });
    memes.value = await getMemes(subReddit: subreddit, count: 50);
    isLoading.value = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('subreddit', subreddit);
    });
  }
}
