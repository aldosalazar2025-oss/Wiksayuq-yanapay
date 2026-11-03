import 'package:flutter/material.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({super.key, required this.title, required this.onStart});
  final String title;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.94,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/images/bebe_manta_azul.png',
                fit: BoxFit.cover,
                semanticLabel: 'Bebé dormido sobre manta azul'),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0x15000000),
                Color(0x99000000)
              ],
              stops: [0, .45, 1],
            ))),
            Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onStart,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(26, 18, 22, 22),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Text(title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        height: 1.4))),
                            const SizedBox(width: 14),
                            SizedBox(
                                height: 36,
                                child: FilledButton(
                                  onPressed: onStart,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5F73),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(64, 36),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Iniciar',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                )),
                          ],
                        )),
                  ),
                )),
          ]),
        ),
      );
}
