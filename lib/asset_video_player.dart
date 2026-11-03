import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_previews.dart';

class AssetVideoPlayer extends StatefulWidget {
  const AssetVideoPlayer({super.key, required this.asset, this.active = true});
  final String asset;
  final bool active;
  @override
  State<AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<AssetVideoPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? controller;
  bool loading = false, failed = false, muted = false;
  VideoPreviewData? get preview => videoPreviews[widget.asset];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant AssetVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.active) controller?.pause();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) controller?.pause();
  }

  Future<bool> prepare() async {
    if (controller?.value.isInitialized == true && !failed) return true;
    if (loading) return false;
    setState(() {
      loading = true;
      failed = false;
    });
    final previous = controller;
    final player = VideoPlayerController.asset(widget.asset);
    controller = player;
    await previous?.dispose();
    try {
      await player.initialize();
      if (!mounted || controller != player) return false;
      await player.setVolume(muted ? 0 : 1);
      setState(() => loading = false);
      return true;
    } catch (_) {
      if (mounted && controller == player)
        setState(() {
          loading = false;
          failed = true;
        });
      return false;
    }
  }

  Future<void> toggle() async {
    if (!await prepare() || !mounted || !widget.active) return;
    final player = controller!;
    if (player.value.isPlaying) {
      await player.pause();
    } else {
      if (player.value.position >= player.value.duration)
        await player.seekTo(Duration.zero);
      await player.play();
    }
  }

  Future<void> seek(double fraction) async {
    if (!await prepare() || !mounted) return;
    final player = controller!;
    await player.seekTo(Duration(
        milliseconds:
            (player.value.duration.inMilliseconds * fraction).round()));
  }

  Future<void> skip(int seconds) async {
    if (!await prepare() || !mounted) return;
    await seekVideo(controller!, seconds);
  }

  void volume() {
    setState(() => muted = !muted);
    controller?.setVolume(muted ? 0 : 1);
  }

  Future<void> fullscreen() async {
    if (!await prepare() || !mounted) return;
    final player = controller!;
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  title: const Text('Video',
                      style: TextStyle(color: Colors.white))),
              body: SafeArea(
                  child: SizedBox.expand(
                      child: VideoPlaybackView(
                          controller: player,
                          onFullscreen: () => Navigator.of(context).pop(),
                          isFullscreen: true))),
            )));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : (constraints.maxWidth / (preview?.aspectRatio ?? 16 / 9))
                .clamp(230.0, 420.0);
        final player = controller;
        return SizedBox(
            width: double.infinity,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: player != null && player.value.isInitialized && !failed
                  ? VideoPlaybackView(
                      controller: player, onFullscreen: fullscreen)
                  : PlayerCanvas(
                      media: preview == null
                          ? const ColoredBox(color: Colors.black)
                          : Image.asset(preview!.image,
                              key: ValueKey('video-thumbnail-${widget.asset}'),
                              fit: BoxFit.contain,
                              semanticLabel: 'Miniatura del video'),
                      duration: preview?.duration ?? Duration.zero,
                      position: Duration.zero,
                      playing: false,
                      muted: muted,
                      loading: loading,
                      failed: failed,
                      onPlay: toggle,
                      onVolume: volume,
                      onFullscreen: fullscreen,
                      onSeek: seek,
                      onSkip: skip,
                    ),
            ));
      });
}

Future<void> seekVideo(VideoPlayerController controller, int seconds) async {
  final target = (controller.value.position.inMilliseconds + seconds * 1000)
      .clamp(0, controller.value.duration.inMilliseconds);
  await controller.seekTo(Duration(milliseconds: target));
}

class VideoPlaybackView extends StatelessWidget {
  const VideoPlaybackView(
      {super.key,
      required this.controller,
      required this.onFullscreen,
      this.isFullscreen = false});
  final VideoPlayerController controller;
  final VoidCallback onFullscreen;
  final bool isFullscreen;
  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, value, _) => PlayerCanvas(
                media: SizedBox.expand(
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                            width: value.size.width,
                            height: value.size.height,
                            child: VideoPlayer(controller)))),
                duration: value.duration,
                position: value.position,
                playing: value.isPlaying,
                muted: value.volume == 0,
                loading: value.isBuffering,
                failed: value.hasError,
                isFullscreen: isFullscreen,
                onPlay: () async {
                  if (value.isPlaying) {
                    await controller.pause();
                  } else {
                    if (value.position >= value.duration)
                      await controller.seekTo(Duration.zero);
                    await controller.play();
                  }
                },
                onVolume: () => controller.setVolume(value.volume == 0 ? 1 : 0),
                onFullscreen: onFullscreen,
                onSeek: (fraction) => controller.seekTo(Duration(
                    milliseconds:
                        (value.duration.inMilliseconds * fraction).round())),
                onSkip: (seconds) => seekVideo(controller, seconds),
              ));
}

/// Los controles son una capa sobre la imagen y nunca alargan el reproductor.
class PlayerCanvas extends StatelessWidget {
  const PlayerCanvas(
      {super.key,
      required this.media,
      required this.duration,
      required this.position,
      required this.playing,
      required this.muted,
      required this.loading,
      required this.failed,
      required this.onPlay,
      required this.onVolume,
      required this.onFullscreen,
      required this.onSeek,
      required this.onSkip,
      this.isFullscreen = false});
  final Widget media;
  final Duration duration, position;
  final bool playing, muted, loading, failed, isFullscreen;
  final VoidCallback onPlay, onVolume, onFullscreen;
  final ValueChanged<double> onSeek;
  final ValueChanged<int> onSkip;
  String time(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  Widget control(String tooltip, IconData icon, VoidCallback callback) =>
      IconButton(
          tooltip: tooltip,
          onPressed: loading ? null : callback,
          icon: Icon(icon, color: Colors.white, size: 23),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 36),
          padding: const EdgeInsets.all(6));
  @override
  Widget build(BuildContext context) => ColoredBox(
      color: Colors.black,
      child: Stack(fit: StackFit.expand, children: [
        Positioned.fill(child: media),
        if (loading)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        if (!playing && !loading)
          Align(
              alignment: const Alignment(0, -.25),
              child: IconButton(
                tooltip: failed ? 'Reintentar video' : 'Reproducir video',
                onPressed: onPlay,
                icon: Icon(failed ? Icons.refresh : Icons.play_circle_fill,
                    color: Colors.white, size: 58),
              )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              key: const Key('video-overlay-controls'),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xDD000000)],
                      stops: [0, 1])),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(children: [
                      Expanded(
                          child: Text('${time(position)} / ${time(duration)}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11))),
                      control(muted ? 'Activar sonido' : 'Silenciar',
                          muted ? Icons.volume_off : Icons.volume_up, onVolume),
                      control(
                          isFullscreen
                              ? 'Salir de pantalla completa'
                              : 'Pantalla completa',
                          isFullscreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          onFullscreen),
                    ]),
                    SizedBox(
                        height: 22,
                        child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 5),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12)),
                            child: Slider(
                              value: duration.inMilliseconds <= 0
                                  ? 0
                                  : (position.inMilliseconds /
                                          duration.inMilliseconds)
                                      .clamp(0.0, 1.0),
                              onChanged: loading ? null : onSeek,
                              activeColor: const Color(0xFFFF5F73),
                              inactiveColor: Colors.white38,
                              semanticFormatterCallback: (value) => time(
                                  Duration(
                                      milliseconds:
                                          (duration.inMilliseconds * value)
                                              .round())),
                            ))),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      control('Retroceder 10 segundos', Icons.replay_10,
                          () => onSkip(-10)),
                      control(playing ? 'Pausar' : 'Reproducir',
                          playing ? Icons.pause : Icons.play_arrow, onPlay),
                      control('Adelantar 10 segundos', Icons.forward_10,
                          () => onSkip(10)),
                    ]),
                  ])),
            )),
      ]));
}
