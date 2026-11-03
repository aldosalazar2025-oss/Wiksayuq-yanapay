import 'dart:math' as math;
import 'package:flutter/material.dart';

class DecisionWelcomeScreen extends StatelessWidget {
  const DecisionWelcomeScreen(
      {super.key,
      required this.onBack,
      required this.onSkip,
      required this.onNext});
  final VoidCallback onBack, onSkip, onNext;
  static const coral = Color(0xFFFF5F73);

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) onBack();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFBFBFB),
          body: SafeArea(
              child: Center(
                  child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              tooltip: 'Regresar',
                              onPressed: onBack,
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  size: 19, color: coral)),
                          SizedBox(
                              height: 30,
                              child: FilledButton(
                                onPressed: onSkip,
                                style: FilledButton.styleFrom(
                                    minimumSize: const Size(60, 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    backgroundColor: coral,
                                    shape: const StadiumBorder(),
                                    textStyle: const TextStyle(fontSize: 12)),
                                child: const Text('Omitir'),
                              )),
                        ],
                      )),
                ),
                Expanded(child: LayoutBuilder(builder: (context, constraints) {
                  final imageSize = math.min(constraints.maxWidth * .90,
                      math.max(180.0, constraints.maxHeight * .60));
                  final gap =
                      math.max(32.0, constraints.maxHeight - imageSize - 134);
                  return SingleChildScrollView(
                      child: Column(children: [
                    const SizedBox(height: 24),
                    Image.asset('assets/images/bienvenida_ecografia.png',
                        key: const Key('ultrasound-illustration'),
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                        semanticLabel:
                            'Ilustración circular de ecografía y bebé'),
                    SizedBox(height: gap),
                    const Text('Decide con seguridad',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            height: 1.2,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Ante la duda, te guiamos paso a paso para evaluar la situación y ayudarte a decidir con calma si es momento de buscar ayuda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF27232C),
                              fontSize: 13.5,
                              height: 1.35),
                        )),
                    const SizedBox(height: 12),
                  ]));
                })),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Container(
                                  width: 21,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: index == 1
                                          ? coral
                                          : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(8)),
                                )))),
                SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                        onPressed: onNext,
                        style: FilledButton.styleFrom(
                            backgroundColor: coral,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text('SIGUIENTE',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)))),
                const SizedBox(height: 28),
              ]),
            ),
          ))),
        ),
      );
}
