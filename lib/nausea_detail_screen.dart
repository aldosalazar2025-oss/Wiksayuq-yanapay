import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'section_media_carousel.dart';

class NauseaDetailScreen extends StatelessWidget {
  const NauseaDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;
  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('nausea-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Las náuseas y los vómitos intensos o persistentes pueden causar deshidratación. Si no puedes retener agua u otros líquidos, busca atención médica de inmediato.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.4),
              )),
          const SizedBox(height: 24),
          FilledButton.icon(
              onPressed: onSeekCare,
              icon: const Icon(Icons.local_hospital_outlined, size: 20),
              label: const Text('Buscar atención')),
          const SizedBox(height: 36),
          SectionMediaCarousel(
            key: Key('nausea-media-carousel'),
            title: AlarmCatalog.titles[6],
            photos: ['assets/images/nauseas_vomitos_exagerados.jpeg'],
            videos: ['assets/videos/nauseas_vomitos.mp4'],
            videoKeyPrefix: 'nausea-video',
          ),
          const SizedBox(height: 16),
          const Text('Fuente de la descripción: CDC / MedlinePlus.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}
