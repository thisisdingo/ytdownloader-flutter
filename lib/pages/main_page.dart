import 'package:flutter/material.dart';
import 'package:you_tube_test_task/components/search_component.dart';
import 'package:you_tube_test_task/components/speed_component.dart';
import 'package:you_tube_test_task/components/track_shape.dart';
import 'package:you_tube_test_task/utils/duration_formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  YoutubePlayerController? _youTubeController;

  // Флаг воспроизведения
  bool isPlaying = false;
  // Общее время
  Duration totalTime = Duration.zero;
  // Текущее время
  Duration currentTime = Duration.zero;

  @override
  void dispose() {
    _youTubeController?.removeListener(youTubeChangedListener);
    super.dispose();
  }

  youTubeChangedListener() {
    if (_youTubeController == null) {
      return;
    }
    setState(() {
      totalTime = _youTubeController!.metadata.duration;
      currentTime = _youTubeController!.value.position;
      isPlaying = _youTubeController!.value.isPlaying;
    });
  }

  // Назад
  back() {
    if (currentTime.inSeconds <= 15) {
      _youTubeController?.seekTo(const Duration(seconds: 0));
    } else {
      _youTubeController?.seekTo(Duration(seconds: currentTime.inSeconds - 15));
    }
  }

  // Вперед
  forward() {
    if (totalTime.inSeconds - currentTime.inSeconds <= 15) {
      _youTubeController?.seekTo(totalTime);
    } else {
      _youTubeController?.seekTo(Duration(seconds: currentTime.inSeconds + 15));
    }
  }

  // Плей или пауза
  playOrPause() {
    if (_youTubeController == null) {
      return;
    }
    if (isPlaying) {
      _youTubeController?.pause();
    } else {
      _youTubeController?.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            Positioned.fill(
                child: _youTubeController == null
                    ? const SizedBox()
                    : YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _youTubeController!,
                          showVideoProgressIndicator: true,
                          onReady: () {},
                        ),
                        builder: (context, player) {
                          return player;
                        },
                      )),
            Positioned(
              top: 8,
              right: orientation == Orientation.portrait
                  ? 8
                  : MediaQuery.of(context).size.width * 0.1,
              left: orientation == Orientation.portrait
                  ? 8
                  : MediaQuery.of(context).size.width * 0.1,
              child: SearchComponent(

                didLinkEntered: (String link) {
                  String? id = YoutubePlayer.convertUrlToId(link);
                  if (id == null) {
                    return;
                  }
                  setState(() {
                    currentTime = Duration.zero;
                    totalTime = Duration.zero;
                    isPlaying = true;
                  });
                  if (_youTubeController == null) {
                    setState(() {
                      _youTubeController = YoutubePlayerController(
                        flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                            controlsVisibleAtStart: false,
                            enableCaption: false,
                            hideControls: true),
                        initialVideoId: id,
                      );
                      _youTubeController!.addListener(youTubeChangedListener);
                    });
                  } else {
                    _youTubeController!.load(id);
                    _youTubeController!.play();
                  }
                },
              ),
            ),
            if (orientation == Orientation.landscape)
              Positioned.fill(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZoomTapAnimation(
                        onTap: back,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: const Color.fromRGBO(37, 37, 37, 0.82)),
                          child: Center(child: Image.asset('assets/back.png')),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    ZoomTapAnimation(
                        onTap: playOrPause,
                        child: Container(
                          height: 72,
                          width: 72,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: const Color.fromRGBO(37, 37, 37, 0.82)),
                          child: Center(
                              child: Image.asset(isPlaying
                                  ? 'assets/pause.png'
                                  : 'assets/play.png')),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    ZoomTapAnimation(
                        onTap: forward,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: const Color.fromRGBO(37, 37, 37, 0.82)),
                          child: Center(child: Image.asset('assets/force.png')),
                        ))
                  ],
                ),
              )),
            Positioned(
                bottom: 8,
                right: 8,
                left: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          DurationFormatter.formatDuration(currentTime.inSeconds),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          DurationFormatter.formatDuration(totalTime.inSeconds),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SliderTheme(
                        data: SliderThemeData(
                            overlayShape: SliderComponentShape.noOverlay,
                            trackShape: TrackShape(),
                            activeTrackColor: const Color(0xFFFF375F),
                            thumbColor: const Color(0xFFFF375F),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10)),
                        child: Slider(
                          value: currentTime.inSeconds == 0
                              ? 0
                              : currentTime.inSeconds / totalTime.inSeconds,
                          onChanged: (value) {
                            _youTubeController?.seekTo(Duration(
                                seconds:
                                    (totalTime.inSeconds * value).toInt()));
                          },
                        )),
                    if (orientation == Orientation.portrait &&
                        _youTubeController != null)
                      SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                              child: SpeedComponent(
                                didSpeedChanged: _youTubeController!.setPlaybackRate,
                              ),
                            )),
                            Expanded(
                                child: Center(
                              child: ZoomTapAnimation(
                                onTap: back,
                                child: Image.asset(
                                  'assets/back.png',
                                  height: 48,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Center(
                              child: ZoomTapAnimation(
                                onTap: playOrPause,
                                child: Image.asset(
                                  isPlaying
                                      ? 'assets/pause.png'
                                      : 'assets/play.png',
                                  height: 48,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Center(
                              child: ZoomTapAnimation(
                                onTap: forward,
                                child: Image.asset(
                                  'assets/force.png',
                                  height: 48,
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                  ],
                ))
          ],
        );
      })),
    );
  }
}


