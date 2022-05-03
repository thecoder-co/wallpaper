import 'package:http/http.dart' as http;
import 'dart:convert';

Future<MemeBig> getMemes({
  String? subReddit,
  required int count,
}) async {
  String? baseUrl = 'https://meme-api.herokuapp.com/gimme';
  if (subReddit != null) {
    baseUrl += '/$subReddit';
  }
  baseUrl += '/$count';

  Uri url = Uri.parse(baseUrl);

  http.Response response = await http.get(
    url,
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
  );
  var data = json.decode(response.body);
  if (response.statusCode == 200) {
    return memeBigFromJson(response.body);
  } else {
    print(data['message']);
    throw Exception('Unable to load data');
  }
}

MemeBig memeBigFromJson(String str) => MemeBig.fromJson(json.decode(str));

String memeBigToJson(MemeBig data) => json.encode(data.toJson());

class MemeBig {
  MemeBig({
    this.count,
    this.memes,
  });

  int? count;
  List<Meme>? memes;

  factory MemeBig.fromJson(Map<String, dynamic> json) => MemeBig(
        count: json["count"],
        memes: List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "memes": List<dynamic>.from(memes!.map((x) => x.toJson())),
      };
}

class Meme {
  Meme({
    this.postLink,
    this.subreddit,
    this.title,
    this.url,
    this.nsfw,
    this.spoiler,
    this.author,
    this.ups,
    this.preview,
  });

  String? postLink;
  String? subreddit;
  String? title;
  String? url;
  bool? nsfw;
  bool? spoiler;
  String? author;
  int? ups;
  List<String>? preview;

  factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        postLink: json["postLink"]!,
        subreddit: json["subreddit"]!!,
        title: json["title"]!,
        url: json["url"]!,
        nsfw: json["nsfw"]!,
        spoiler: json["spoiler"]!,
        author: json["author"]!,
        ups: json["ups"]!,
        preview: List<String>.from(json["preview"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "postLink": postLink,
        "subreddit": subreddit,
        "title": title,
        "url": url,
        "nsfw": nsfw,
        "spoiler": spoiler,
        "author": author,
        "ups": ups,
        "preview": List<dynamic>.from(preview!.map((x) => x)),
      };
}
