import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memes/apis/get_meme.dart';
import 'package:memes/components/meme_card.dart';
import 'package:memes/constants.dart';

class MemeDetails extends StatefulWidget {
  final Meme meme;
  const MemeDetails({Key? key, required this.meme}) : super(key: key);

  @override
  _MemeDetailsState createState() => _MemeDetailsState();
}

class _MemeDetailsState extends State<MemeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Memes',
          style: GoogleFonts.patrickHand(
            color: appbarTextColor,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: appbarTextColor,
        ),
        backgroundColor: appbarColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MemeCard(
                meme: widget.meme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
