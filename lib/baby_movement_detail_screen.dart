import 'page_app_bar.dart';
import 'alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'medical_poster.dart';

class BabyMovementDetailScreen extends StatelessWidget {
  const BabyMovementDetailScreen({super.key, required this.onSeekCare});
  final VoidCallback onSeekCare;
  static const imageAsset = 'assets/images/disminucion_movimiento_bebe.png';

  void openPoster(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        appBar: pageAppBar(context,
            leading: const BackButton(), title: AlarmCatalog.titles[4]),
        body: const SafeArea(
            child: MedicalPoster(
                asset: imageAsset,
                label: 'Lámina de Disminución del movimiento del bebé')),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('baby-movement-detail'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Es la reducción en la frecuencia, intensidad o duración de los movimientos del bebé dentro del útero. Si notas una disminución importante, busca una evaluación médica inmediata. No te automediques ni esperes a que pase.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onSeekCare,
            icon: const Icon(Icons.local_hospital_outlined, size: 20),
            label: const Text('Buscar atención'),
          ),
          const SizedBox(height: 36),
          Semantics(
            button: true,
            label:
                'Abrir lámina completa de Disminución del movimiento del bebé',
            child: Material(
              key: const Key('baby-movement-poster-preview'),
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFFF5F73),
              child: InkWell(
                onTap: () => openPoster(context),
                child: Column(children: [
                  AspectRatio(
                      aspectRatio: 1536 / 1024,
                      child: Image.asset(imageAsset,
                          fit: BoxFit.contain,
                          semanticLabel:
                              'Vista previa de la lámina de Disminución del movimiento del bebé')),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.zoom_in, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Flexible(
                                child: Text('Toca para ampliar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13))),
                          ])),
                ]),
              ),
            ),
          ),
        ],
      );
}
