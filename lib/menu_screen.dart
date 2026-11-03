import 'dart:ui';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, this.initialArticle});
  final int? initialArticle;
  static const labels = [
    'Sobre la aplicación',
    'Creditos/respaldo institucional',
    'Descargo de responsabilidades'
  ];
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const coral = Color(0xFFFF5F73);
  static const doctor = 'Dr. Lorem Ipsum is simply dummy';
  static const disclaimerFirst =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
  static const disclaimerSecond =
      'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';
  @override
  void initState() {
    super.initState();
    if (widget.initialArticle != null)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) openArticle(widget.initialArticle!);
      });
  }

  @override
  Widget build(BuildContext context) => ListView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(28, 28, 24, 24),
        children: [
          for (var index = 0; index < MenuScreen.labels.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: IntrinsicHeight(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Container(
                        width: 12,
                        decoration: BoxDecoration(
                            color: coral,
                            borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 7),
                    Expanded(
                        child: FilledButton(
                      key: ValueKey('menu-option-$index'),
                      onPressed: () => openArticle(index),
                      style: FilledButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: coral,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                      child: Text(MenuScreen.labels[index],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    )),
                  ])),
            ),
          const SizedBox(height: 20),
          const Center(
              child: Text('Versión 1.0.2',
                  key: Key('app-version'),
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      );
  void openArticle(int index) => showGeneralDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Cerrar ventana',
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondary) => BackdropFilter(
          key: const Key('menu-background-blur'),
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: ColoredBox(
              color: const Color(0x55F1E8E8),
              child: Center(
                  child: Dialog(
                key: const Key('menu-information-dialog'),
                backgroundColor: const Color(0xFFFBFBFB),
                surfaceTintColor: Colors.transparent,
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                elevation: 4,
                shadowColor: Colors.black38,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: 400,
                        maxHeight: MediaQuery.sizeOf(context).height * .80),
                    child: Stack(children: [
                      SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(32, 36, 32, 40),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Center(
                                        child: Text(
                                            switch (index) {
                                              0 => 'Sobre la aplicación',
                                              1 =>
                                                'Credito/ respaldo\nInstitucional',
                                              _ =>
                                                'Descargo de\nresponsabilidad'
                                            },
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: coral,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600,
                                                height: 1.15)))),
                                const SizedBox(height: 36),
                                ...article(index),
                              ])),
                      Positioned(
                          top: 6,
                          right: 6,
                          child: IconButton(
                              tooltip: 'Cerrar ventana',
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close,
                                  color: coral, size: 26))),
                    ])),
              ))),
        ),
      );
  Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(text,
          style: const TextStyle(
              color: coral, fontSize: 15, fontWeight: FontWeight.w500)));
  Widget paragraph(String text, {double bottom = 16}) => Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Text(text,
          style:
              const TextStyle(color: Colors.black, fontSize: 12, height: 1.4)));
  List<Widget> article(int index) => switch (index) {
        0 => [
            heading('Objetivo:'),
            paragraph(
                'Ayuda a reconocer signos de alarma durante el embarazo y actuar oportunamente.',
                bottom: 24),
            heading('Público:'),
            paragraph('Mujeres gestantes.', bottom: 24),
            heading('Recomendaciones generales:'),
            paragraph('Asistir a controles prenatales.', bottom: 8),
            paragraph('No automedicarse.', bottom: 8),
            paragraph('Alimentación saludable.', bottom: 0),
          ],
        1 => [
            heading('Aplicación desarrollado por:'),
            paragraph(doctor, bottom: 12),
            paragraph(doctor, bottom: 24),
            heading('Agradecimiento:'),
            paragraph(doctor, bottom: 12),
            paragraph(doctor, bottom: 0),
          ],
        _ => [
            paragraph(disclaimerFirst, bottom: 12),
            paragraph(disclaimerSecond, bottom: 12)
          ],
      };
}
