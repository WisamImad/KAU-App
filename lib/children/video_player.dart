import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:kau_app/utils/sizeConfig.dart';

class YoutubeAppDemo extends StatefulWidget {
  String? url;
  YoutubeAppDemo({this.url});
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  YoutubePlayerController? _controller;
  String getYoutubeVideoId(String url) {
    RegExp regExp = new RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url)!.group(1); // <- This is the fix
    String? str = match;
    return str!;
  }

  @override
  void initState() {
    super.initState();
    // String videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=BBAyRBTfsOU")
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url!)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Stack(
        children: [
          YoutubePlayerBuilder(
              player: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.pink,
                  bottomActions: [
                    const SizedBox(width: 14.0),
                    CurrentPosition(),
                    const SizedBox(width: 8.0),
                    ProgressBar(
                      isExpanded: true,
                    ),
                    RemainingDuration(),
                    // const PlaybackSpeedButton(),
                  ]),
              builder: (context, player) {
                return Column(
                  children: [
                    player,
                  ],
                );
              }),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Image.asset(
                    "assets/children/back_icon.png",
                    height: SizeConfig.safeBlockVertical! * 10,
                    width: SizeConfig.safeBlockHorizontal! * 7,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

///
// class Controls extends StatelessWidget {
//   ///
//   const Controls();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _space,
//           MetaDataSection(),
//           _space,
//           SourceInputSection(),
//           _space,
//           PlayPauseButtonBar(),
//           _space,
//           VolumeSlider(),
//           _space,
//           PlayerStateSection(),
//         ],
//       ),
//     );
//   }
//
//   Widget get _space => const SizedBox(height: 10);
// }
