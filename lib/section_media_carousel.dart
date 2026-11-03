import 'page_app_bar.dart';
import 'package:flutter/material.dart';
import 'asset_video_player.dart';
import 'medical_poster.dart';

/// Siempre presenta las fotos antes de los videos, en el orden recibido.
class SectionMediaCarousel extends StatefulWidget {
  const SectionMediaCarousel(
      {super.key,
      required this.title,
      required this.photos,
      required this.videos,
      this.videoKeyPrefix = 'section-video'});
  final String title, videoKeyPrefix;
  final List<String> photos, videos;
  @override
  State<SectionMediaCarousel> createState() => _SectionMediaCarouselState();
}

class _SectionMediaCarouselState extends State<SectionMediaCarousel> {
  final pages = PageController();
  int selected = 0;
  int get count => widget.photos.length + widget.videos.length;
  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  void move(int index) => pages.animateToPage(index,
      duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  void openPhoto(String asset) =>
      Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          appBar: pageAppBar(context,
              leading: const BackButton(), title: widget.title),
          body:
              SafeArea(child: MedicalPoster(asset: asset, label: widget.title)),
        ),
      ));
  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final isPhoto = selected < widget.photos.length;
    final label = isPhoto
        ? 'Foto ${selected + 1} de ${widget.photos.length}'
        : 'Video ${selected - widget.photos.length + 1} de ${widget.videos.length}';
    return LayoutBuilder(
        builder: (context, constraints) => Column(children: [
              SizedBox(
                  height: (constraints.maxWidth * .95).clamp(250.0, 420.0),
                  child: PageView.builder(
                    key: const Key('section-media-pages'),
                    controller: pages,
                    itemCount: count,
                    onPageChanged: (index) => setState(() => selected = index),
                    itemBuilder: (context, index) {
                      if (index < widget.photos.length) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Material(
                              color: const Color(0xFFFF5F73),
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                  key: ValueKey('section-media-photo-$index'),
                                  onTap: () => openPhoto(widget.photos[index]),
                                  child: Column(children: [
                                    Expanded(
                                        child: ColoredBox(
                                            color: Colors.white,
                                            child: SizedBox.expand(
                                                child: Image.asset(
                                                    widget.photos[index],
                                                    fit: BoxFit.contain,
                                                    semanticLabel:
                                                        widget.title)))),
                                    const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.zoom_in,
                                                  color: Colors.white,
                                                  size: 20),
                                              SizedBox(width: 8),
                                              Flexible(
                                                  child: Text(
                                                      'Toca para ampliar',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13)))
                                            ])),
                                  ])),
                            ));
                      }
                      final videoIndex = index - widget.photos.length;
                      return AssetVideoPlayer(
                        key: ValueKey(videoIndex == 0
                            ? widget.videoKeyPrefix
                            : '${widget.videoKeyPrefix}-$videoIndex'),
                        asset: widget.videos[videoIndex],
                        active: selected == index,
                      );
                    },
                  )),
              const SizedBox(height: 8),
              Row(children: [
                IconButton(
                    tooltip: 'Recurso anterior',
                    onPressed: selected > 0 ? () => move(selected - 1) : null,
                    icon: const Icon(Icons.chevron_left)),
                Expanded(
                    child: Text(label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600))),
                IconButton(
                    tooltip: 'Recurso siguiente',
                    onPressed:
                        selected < count - 1 ? () => move(selected + 1) : null,
                    icon: const Icon(Icons.chevron_right)),
              ]),
              if (count > 1)
                const Text('Desliza para ver más',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
            ]));
  }
}
