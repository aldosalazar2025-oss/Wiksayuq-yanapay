import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'section_media_carousel.dart';

class FetalMovementDetailScreen extends StatelessWidget {
  const FetalMovementDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;
  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('fetal-movement-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Si tu bebé se mueve menos de lo habitual, deja de moverse o cambia su patrón de movimientos, busca atención médica de inmediato. No esperes al día siguiente para consultar.',
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
            key: Key('fetal-media-carousel'),
            title: AlarmCatalog.titles[7],
            photos: ['assets/images/ausencia_movimientos_fetales.jpeg'],
            videos: ['assets/videos/disminucion_movimientos_fetales.mp4'],
            videoKeyPrefix: 'fetal-movement-video',
          ),
          const SizedBox(height: 16),
          const Text('Fuente de la descripción: NHS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}
