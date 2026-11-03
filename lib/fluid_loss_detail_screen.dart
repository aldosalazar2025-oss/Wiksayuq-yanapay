import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'section_media_carousel.dart';

class FluidLossDetailScreen extends StatelessWidget {
  const FluidLossDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;

  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('fluid-loss-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'El líquido amniótico rodea y protege a tu bebé. Si sale líquido por la vagina, puede haberse roto la bolsa amniótica. Acude lo antes posible al establecimiento de salud.',
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
            key: Key('fluid-loss-media-carousel'),
            title: AlarmCatalog.titles[3],
            photos: ['assets/images/perdida_liquido.jpeg'],
            videos: ['assets/videos/perdida_liquido_amniotico.mp4'],
            videoKeyPrefix: 'fluid-loss-video',
          ),
        ],
      );
}
