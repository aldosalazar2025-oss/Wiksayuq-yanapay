import 'package:flutter/material.dart';

class MedicalPoster extends StatefulWidget {
  const MedicalPoster({super.key, required this.asset, required this.label});
  final String asset, label;
  @override
  State<MedicalPoster> createState() => _MedicalPosterState();
}

class _MedicalPosterState extends State<MedicalPoster> {
  final transform = TransformationController();
  @override
  void dispose() {
    transform.dispose();
    super.dispose();
  }

  void zoom(double factor, Size viewport) {
    final scale =
        (transform.value.getMaxScaleOnAxis() * factor).clamp(1.0, 6.0);
    transform.value = Matrix4.identity()
      ..setEntry(0, 0, scale)
      ..setEntry(1, 1, scale)
      ..setEntry(0, 3, viewport.width * (1 - scale) / 2)
      ..setEntry(1, 3, viewport.height * (1 - scale) / 2);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          final viewport = constraints.biggest;
          return Stack(children: [
            Positioned.fill(
                child: InteractiveViewer(
              key: const Key('medical-poster'),
              transformationController: transform,
              minScale: 1,
              maxScale: 6,
              child: SizedBox.expand(
                  child: Image.asset(widget.asset,
                      fit: BoxFit.contain, semanticLabel: widget.label)),
            )),
            Positioned(
                right: 8,
                bottom: 8,
                child: Material(
                  color: Colors.white,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        tooltip: 'Reducir',
                        onPressed: () => zoom(1 / 1.5, viewport),
                        icon: const Icon(Icons.remove)),
                    IconButton(
                        tooltip: 'Restablecer vista',
                        onPressed: () => transform.value = Matrix4.identity(),
                        icon: const Icon(Icons.fit_screen)),
                    IconButton(
                        tooltip: 'Ampliar',
                        onPressed: () => zoom(1.5, viewport),
                        icon: const Icon(Icons.add)),
                  ]),
                )),
          ]);
        })),
        const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Amplía la imagen con dos dedos o con los botones.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey))),
      ]);
}
