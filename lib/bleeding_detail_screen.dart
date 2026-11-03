import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'section_media_carousel.dart';

class BleedingDetailScreen extends StatelessWidget {
  const BleedingDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;

  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('bleeding-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'El sangrado por la vagina durante el embarazo NUNCA es normal. No importa si es solo una mancha leve o una pérdida abundante: siempre es una emergencia médica.',
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
            key: Key('bleeding-media-carousel'),
            title: AlarmCatalog.titles[0],
            photos: ['assets/images/sangrado_vaginal.jpeg'],
            videos: ['assets/videos/sangrado_vaginal.mp4'],
            videoKeyPrefix: 'bleeding-video',
          ),
        ],
      );
}
