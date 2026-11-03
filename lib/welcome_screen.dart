import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Primera bienvenida: textos copiados literalmente de la referencia del usuario.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onSkip, required this.onNext});
  final VoidCallback onSkip;
  final VoidCallback onNext;
  static const coral = Color(0xFFFF5F73);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 30,
                          child: FilledButton(
                            onPressed: onSkip,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(60, 30),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              backgroundColor: coral,
                              shape: const StadiumBorder(),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: const Text('Omitir'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageSize = math.min(constraints.maxWidth,
                              math.max(180.0, constraints.maxHeight * .60));
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 14),
                                  Image.asset(
                                    'assets/images/bienvenida_maternal.png',
                                    key: const Key('maternal-illustration'),
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.contain,
                                    semanticLabel:
                                        'Ilustración maternal con corazón y destellos',
                                  ),
                                  const SizedBox(height: 28),
                                  const Text(
                                    'Bienvenido a\nWiksayuq Yanapay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 28),
                                  const Text(
                                    'Reconoce a tiempo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 12),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(
                                      'Bienvenida, mamá. Este aplicativo te ayudará a reconocer los signos de alarma y saber qué hacer para proteger tu salud y la de tu bebé.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.5,
                                          height: 1.35,
                                          color: Color(0xFF27232C)),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  width: 21,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: index == 0
                                          ? coral
                                          : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(8)),
                                )),
                      ),
                    ),
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
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
