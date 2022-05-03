import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:memes/apis/get_meme.dart';
import 'package:memes/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MemeCard extends StatelessWidget {
  final Meme meme;
  const MemeCard({
    Key? key,
    required this.meme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    meme.url!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Title: ${meme.title!}",
              maxLines: 2,
              style: GoogleFonts.patrickHand(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: infoTextColor,
                ),
              ),
            ),
            Text(
              "Subreddit: ${meme.subreddit!}",
              style: GoogleFonts.patrickHand(
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: infoTextColor,
                ),
              ),
            ),
            Text(
              "Author: ${meme.author!}",
              style: GoogleFonts.patrickHand(
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: infoTextColor,
                ),
              ),
            ),
            Text(
              "Upvotes: ${meme.ups!}",
              style: GoogleFonts.josefinSans(
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: infoTextColor,
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.public),
                  onPressed: () async {
                    String url = Uri.encodeFull(meme.postLink!);
                    //
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      Get.snackbar('error', 'could not launch url');
                    }
                  },
                  label: const Text('Go to post'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPrimary: appbarColor,
                    primary: appbarTextColor,
                    textStyle: GoogleFonts.patrickHand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    String result;
// Platform messages may fail, so we use a try/catch PlatformException.
                    try {
                      result = await AsyncWallpaper.setWallpaper(
                        meme.url!,
                        AsyncWallpaper.LOCK_SCREEN,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wallpaper set'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to set wallpaper'),
                        ),
                      );
                      result = 'Failed to get wallpaper.';
                    }
                  },
                  label: const Text('Set as wallpaper'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPrimary: appbarColor,
                    primary: appbarTextColor,
                    textStyle: GoogleFonts.patrickHand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    try {
                      var imageId =
                          await ImageDownloader.downloadImage("${meme.url}");
                      if (imageId == null) {
                        return;
                      }

                      Get.snackbar('Successful', 'Meme downloaded');
                    } catch (error) {
                      Get.snackbar('Failed', 'Unable to download meme');
                    }
                  },
                  label: const Text('Download Image'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPrimary: appbarColor,
                    primary: appbarTextColor,
                    textStyle: GoogleFonts.patrickHand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    try {
                      var imageId =
                          await ImageDownloader.downloadImage("${meme.url}");
                      if (imageId == null) {
                        return;
                      }

                      var path = await ImageDownloader.findPath(imageId);
                      Share.shareFiles(['$path'], text: '${meme.title}');
                    } catch (error) {
                      Get.snackbar('Failed', 'Unable to share meme');
                    }
                  },
                  label: const Text('Share image'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPrimary: appbarColor,
                    primary: appbarTextColor,
                    textStyle: GoogleFonts.patrickHand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
