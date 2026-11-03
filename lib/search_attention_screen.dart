import 'package:flutter/material.dart';

class SearchAttentionScreen extends StatelessWidget {
  const SearchAttentionScreen({super.key, required this.onContact});
  final VoidCallback onContact;
  static const images = [
    ('assets/images/acudir_de_inmediato.png', 'Acudir de inmediato'),
    ('assets/images/ve_acompanado.png', 'Ve acompañado'),
    ('assets/images/lleva_tus_documentos.png', 'Lleva tus documentos'),
  ];
  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 18),
            const Center(
                child: Text('¿Qué hacer?',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            const SizedBox(height: 44),
            LayoutBuilder(builder: (context, constraints) {
              final cardWidth = constraints.maxWidth * .84;
              return SizedBox(
                  height: cardWidth * 843 / 1866,
                  child: ListView.separated(
                    key: const Key('attention-images'),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => SizedBox(
                        width: cardWidth,
                        child: ClipRRect(
                          key: ValueKey('attention-image-$index'),
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(images[index].$1,
                              fit: BoxFit.contain,
                              semanticLabel: images[index].$2),
                        )),
                  ));
            }),
            const SizedBox(height: 58),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Antes de salir',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            const SizedBox(height: 14),
            for (final label in [
              'Llevar DNI',
              'Carnet prenatal',
              'Resultados médicos (opcional)'
            ])
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                  child: Row(children: [
                    ExcludeSemantics(
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFFF5F73))))),
                    const SizedBox(width: 14),
                    Expanded(
                        child:
                            Text(label, style: const TextStyle(fontSize: 12))),
                  ])),
            const SizedBox(height: 24),
          ]),
        ))),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
            child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: onContact,
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5F73),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Contactar al centro de salud',
                      textAlign: TextAlign.center),
                ))),
      ]);
}
