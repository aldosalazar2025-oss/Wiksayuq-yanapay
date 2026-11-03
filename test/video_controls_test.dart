import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:wiksayuq_yanapay/asset_video_player.dart';
import 'package:wiksayuq_yanapay/video_previews.dart';

class FakeVideoPlatform extends VideoPlayerPlatform {
  bool playing = false;
  double volume = 1;
  Duration position = Duration.zero;
  @override
  Future<void> init() async {}
  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async => 1;
  @override
  Stream<VideoEvent> videoEventsFor(int playerId) => Stream.value(VideoEvent(
      eventType: VideoEventType.initialized,
      duration: const Duration(seconds: 44),
      size: const Size(360, 640)));
  @override
  Future<void> dispose(int playerId) async {}
  @override
  Future<void> setLooping(int playerId, bool looping) async {}
  @override
  Future<void> setVolume(int playerId, double value) async {
    volume = value;
  }

  @override
  Future<void> play(int playerId) async {
    playing = true;
  }

  @override
  Future<void> pause(int playerId) async {
    playing = false;
  }

  @override
  Future<void> seekTo(int playerId, Duration value) async {
    position = value;
  }

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}
  @override
  Future<Duration> getPosition(int playerId) async => position;
  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}
  @override
  Future<void> setAllowBackgroundPlayback(bool allow) async {}
  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      const ColoredBox(color: Color(0xFF335555));
}

void main() {
  testWidgets(
      'Los cinco videos muestran su miniatura y controles dentro de un marco fijo',
      (tester) async {
    for (final asset in videoPreviews.keys) {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: Center(
                  child: SizedBox(
                      width: 280,
                      height: 280,
                      child: AssetVideoPlayer(
                          key: ValueKey(asset), asset: asset))))));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('video-thumbnail-$asset')), findsOneWidget);
      final frame = tester.getRect(find.byType(AssetVideoPlayer));
      for (final tooltip in [
        'Pantalla completa',
        'Silenciar',
        'Reproducir',
        'Retroceder 10 segundos',
        'Adelantar 10 segundos'
      ]) {
        expect(
            frame.contains(tester.getCenter(find.byTooltip(tooltip))), isTrue,
            reason: '$asset $tooltip');
      }
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
      'Controles superpuestos reproducen, silencian, avanzan y abren pantalla completa',
      (tester) async {
    final old = VideoPlayerPlatform.instance;
    final fake = FakeVideoPlatform();
    VideoPlayerPlatform.instance = fake;
    addTearDown(() => VideoPlayerPlatform.instance = old);
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: Center(
                child: SizedBox(
                    width: 280,
                    height: 280,
                    child: AssetVideoPlayer(
                        asset: 'assets/videos/dolor_cabeza_zumbidos.mp4'))))));
    await tester.pumpAndSettle();
    // Pantalla completa funciona incluso antes de pulsar Reproducir.
    await tester.tap(find.byTooltip('Pantalla completa'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Salir de pantalla completa'), findsOneWidget);
    await tester.tap(find.byTooltip('Reproducir'));
    await tester.pumpAndSettle();
    expect(fake.playing, isTrue);
    await tester.tap(find.byTooltip('Silenciar'));
    await tester.pumpAndSettle();
    expect(fake.volume, 0);
    await tester.tap(find.byTooltip('Adelantar 10 segundos'));
    await tester.pumpAndSettle();
    expect(fake.position, const Duration(seconds: 10));
    await tester.tap(find.byTooltip('Salir de pantalla completa'));
    await tester.pumpAndSettle();
    final frame = tester.getRect(find.byType(AssetVideoPlayer));
    expect(frame.height, 280);
    expect(
        frame.contains(tester.getCenter(find.byTooltip('Pantalla completa'))),
        isTrue);
    await tester.tap(find.byTooltip('Pausar'));
    await tester.pumpAndSettle();
    expect(fake.playing, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
