import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showVideoPlayer = false;
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: video != null
          ? _VideoPlayer(
              video: video!,
              onAnotherVideoTap: _onLogoClick,
            )
          : _VideoSelector(
              children: _homeView(),
            ),
    );
  }

  _homeView() {
    return [
      _Logo(
        onTap: _onLogoClick,
      ),
      SizedBox(height: 10),
      _Title(),
    ];
  }

  _onLogoClick() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    setState(() {
      this.video = video;
    });
  }
}

class _VideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onAnotherVideoTap;

  const _VideoPlayer({
    required this.video,
    required this.onAnotherVideoTap,
    super.key,
  });

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController videoPlayerCont;
  bool showIcons = true;

  @override
  void initState() {
    super.initState();
    initailizeController();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initailizeController();
    }
  }

  initailizeController() async {
    videoPlayerCont = VideoPlayerController.file(
      File(
        widget.video.path,
      ),
    );

    await videoPlayerCont.initialize();

    videoPlayerCont.addListener(() {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          showIcons = !showIcons;
        });
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: videoPlayerCont.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                videoPlayerCont,
              ),
              if(showIcons)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                ),
              if(showIcons)
              _PlayButtons(
                onRewindAgo: _onRewindAgo,
                onPlayAndStop: _onPlayAndStop,
                onRewindLate: _onRewindLate,
                isPlaying: videoPlayerCont.value.isPlaying,
              ),
              if(showIcons)
              _PlaySlide(
                videoPlayerContPosition: videoPlayerCont.value.position,
                videoPlayerContDuration: videoPlayerCont.value.duration,
                onSliderChanged: _onSliderChanged,
              ),
              if(showIcons)
              _AnotherVideo(
                onAnotherVideoTap: widget.onAnotherVideoTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRewindAgo() {
    final currentPosition = videoPlayerCont.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoPlayerCont.seekTo(position);
  }

  _onPlayAndStop() {
    setState(() {
      if (videoPlayerCont.value.isPlaying) {
        videoPlayerCont.pause();
      } else {
        videoPlayerCont.play();
      }
    });
  }

  _onRewindLate() {
    final maxPosition = videoPlayerCont.value.duration;
    final currentPosition = videoPlayerCont.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoPlayerCont.seekTo(position);
  }

  _onSliderChanged(double value) {
    final position = Duration(seconds: value.toInt());
    videoPlayerCont.seekTo(position);
  }
}

class _VideoSelector extends StatefulWidget {
  final List<Widget> children;

  const _VideoSelector({
    required this.children,
    super.key,
  });

  @override
  State<_VideoSelector> createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<_VideoSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A7C),
            Color(0xFF000118),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.children,
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  final VoidCallback onTap;

  const _Logo({
    required this.onTap,
    super.key,
  });

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Image.asset('asset/image/logo.png'),
    );
  }
}

class _Title extends StatefulWidget {
  const _Title({super.key});

  @override
  State<_Title> createState() => _TitleState();
}

class _TitleState extends State<_Title> {
  @override
  Widget build(BuildContext context) {
    final fontStyle = TextStyle(
      color: Colors.white,
      fontSize: 32,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: fontStyle.copyWith(
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          'PLAYER',
          style: fontStyle.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PlayButtons extends StatefulWidget {
  final VoidCallback onRewindAgo;
  final VoidCallback onPlayAndStop;
  final VoidCallback onRewindLate;
  final bool isPlaying;

  const _PlayButtons({
    required this.onRewindAgo,
    required this.onPlayAndStop,
    required this.onRewindLate,
    required this.isPlaying,
    super.key,
  });

  @override
  State<_PlayButtons> createState() => _PlayButtonsState();
}

class _PlayButtonsState extends State<_PlayButtons> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            color: Colors.white,
            onPressed: widget.onRewindAgo,
            icon: Icon(Icons.rotate_left),
          ),
          IconButton(
            color: Colors.white,
            onPressed: widget.onPlayAndStop,
            icon: Icon(
              widget.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          IconButton(
            color: Colors.white,
            onPressed: widget.onRewindLate,
            icon: Icon(Icons.rotate_right),
          ),
        ],
      ),
    );
  }
}

class _PlaySlide extends StatefulWidget {
  final Duration videoPlayerContPosition;
  final Duration videoPlayerContDuration;
  final ValueChanged<double> onSliderChanged;

  const _PlaySlide({
    required this.videoPlayerContPosition,
    required this.videoPlayerContDuration,
    required this.onSliderChanged,
    super.key,
  });

  @override
  State<_PlaySlide> createState() => _PlaySlideState();
}

class _PlaySlideState extends State<_PlaySlide> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          children: [
            Text(
              '${widget.videoPlayerContPosition.inHours}'
                      .toString()
                      .padLeft(2, '0') +
                  ':' +
                  '${widget.videoPlayerContPosition.inMinutes - (widget.videoPlayerContPosition.inHours * 60)}'
                      .toString()
                      .padLeft(2, '0') +
                  ':' +
                  '${widget.videoPlayerContPosition.inSeconds - (widget.videoPlayerContPosition.inMinutes * 60)}'
                      .toString()
                      .padLeft(2, '0'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: widget.videoPlayerContPosition.inSeconds.toDouble(),
                max: widget.videoPlayerContDuration.inSeconds.toDouble(),
                onChanged: widget.onSliderChanged,
              ),
            ),
            Text(
              '${(widget.videoPlayerContDuration.inHours).toString().padLeft(2, '0')}' +
                  ':' +
                  '${widget.videoPlayerContDuration.inMinutes - (widget.videoPlayerContDuration.inHours * 60)}'
                      .toString()
                      .padLeft(2, '0') +
                  ':' +
                  '${widget.videoPlayerContDuration.inSeconds - (widget.videoPlayerContDuration.inMinutes * 60)}'
                      .toString()
                      .padLeft(2, '0'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnotherVideo extends StatefulWidget {
  final VoidCallback onAnotherVideoTap;

  const _AnotherVideo({
    required this.onAnotherVideoTap,
    super.key,
  });

  @override
  State<_AnotherVideo> createState() => _AnotherVideoState();
}

class _AnotherVideoState extends State<_AnotherVideo> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        color: Colors.white,
        onPressed: widget.onAnotherVideoTap,
        icon: Icon(
          Icons.photo_camera_back,
        ),
      ),
    );
  }
}
