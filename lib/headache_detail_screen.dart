import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'section_media_carousel.dart';

class HeadacheDetailScreen extends StatelessWidget {
  const HeadacheDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;
  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('headache-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Durante el embarazo, el dolor de cabeza intenso, los zumbidos de oídos o el dolor en la boca del estómago pueden ser señales de preeclampsia. Busca atención médica de inmediato.',
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
            key: Key('headache-media-carousel'),
            title: AlarmCatalog.titles[1],
            photos: ['assets/images/dolor_cabeza_zumbidos.jpeg'],
            videos: ['assets/videos/dolor_cabeza_zumbidos.mp4'],
            videoKeyPrefix: 'headache-video',
          ),
          const SizedBox(height: 16),
          const Text('Fuente de la descripción: MINSA / INMP.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}
