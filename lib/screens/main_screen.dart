import 'dart:async';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/apis/get_meme.dart';
import 'package:memes/components/meme_card.dart';
import 'package:memes/constants.dart';
import 'package:memes/meme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compute(refresh, '');
  }

  void refresh(r) async {
    String sub = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('subreddit') ?? 'Cats';
    });
    getMemes(count: 1, subReddit: sub).then((value) async {
      await AsyncWallpaper.setWallpaper(
        value.memes![0].url!,
        AsyncWallpaper.LOCK_SCREEN,
      );
    });
    await Future.delayed(
      const Duration(hours: 12),
    );
    refresh(r);
  }

  final m = Get.put(MemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Wallpapers',
          style: GoogleFonts.patrickHand(
            color: appbarTextColor,
            fontSize: 25,
          ),
        ),
        backgroundColor: appbarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.dialog(AlertDialog(
                backgroundColor: Colors.black,
                title: const Text('Enter subreddit'),
                content: TextField(
                  onChanged: (value) {
                    m.subreddit = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter subreddit',
                    hintStyle: GoogleFonts.patrickHand(
                      color: appbarTextColor,
                      fontSize: 20,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: appbarTextColor),
                    ),
                  ),
                  style: GoogleFonts.patrickHand(
                    color: appbarTextColor,
                    fontSize: 20,
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    style: TextButton.styleFrom(
                      primary: appbarTextColor,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: const Text('Save'),
                    style: TextButton.styleFrom(
                      primary: appbarTextColor,
                    ),
                    onPressed: () async {
                      await SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('subreddit', m.subreddit);
                      });

                      m.isLoading.value = true;
                      m.reloadMemes();
                      Get.back();
                    },
                  ),
                ],
              ));
            },
          ),
        ],
      ),
      body: Obx(() {
        if (m.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Swiper(
            itemCount: m.memes.value.memes?.length ?? 0,
            containerHeight: 600,
            itemBuilder: (ctx, i) {
              return SizedBox(
                height: context.height - 300,
                child: MemeCard(
                  meme: m.memes.value.memes![i],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
