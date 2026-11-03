import 'package:flutter/material.dart';
import 'consultation_rules.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key, required this.onContact});
  final VoidCallback onContact;
  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  static const coral = Color(0xFFFF5F73);
  int step = 0;
  ConsultationTest? selected;
  final temperature = TextEditingController();
  final weeks = TextEditingController();
  final answers = <String, Answer>{};
  final scroll = ScrollController();
  String? error;
  ConsultationResult? result;
  @override
  void dispose() {
    temperature.dispose();
    weeks.dispose();
    scroll.dispose();
    super.dispose();
  }

  void changeStep(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      step = value;
      error = null;
    });
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  void choose(ConsultationTest test) => setState(() {
        if (selected != test) {
          answers.clear();
          temperature.clear();
          weeks.clear();
          result = null;
        }
        selected = test;
        error = null;
      });
  void calculate() {
    final test = selected!;
    final temp = parseTemperature(temperature.text);
    final week = int.tryParse(weeks.text.trim());
    String? validation;
    if (test == ConsultationTest.fever && temp == null)
      validation =
          'Ingresa una temperatura válida en °C (30 a 45). Ejemplo: 38,2.';
    if (test == ConsultationTest.movement &&
        (week == null || week < 1 || week > 45))
      validation = 'Ingresa una semana de embarazo entre 1 y 45.';
    if (questionsFor(test, answers).any((q) => answers[q.id] == null))
      validation = 'Responde todas las preguntas. Puedes elegir No sé.';
    if (validation != null) {
      setState(() => error = validation);
      return;
    }
    result = evaluateConsultation(test,
        temperature: temp, weeks: week, answers: answers);
    changeStep(2);
  }

  void restart() {
    answers.clear();
    temperature.clear();
    weeks.clear();
    result = null;
    changeStep(1);
  }

  void reset() {
    answers.clear();
    temperature.clear();
    weeks.clear();
    result = null;
    selected = null;
    changeStep(0);
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && step > 0) changeStep(step - 1);
        },
        child: ListView(
          controller: scroll,
          primary: false,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            stage(0, 'Seleccione tipo de prueba',
                step == 0 ? selectForm() : null),
            stage(1, 'Ingrese los datos', step == 1 ? inputForm() : null),
            stage(2, 'Resultados', step == 2 ? results() : null, last: true),
            if (step != 2)
              const Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                      'Orientación sobre señales de alarma durante el embarazo. No es un diagnóstico.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey))),
          ],
        ),
      );
  Widget stage(int number, String title, Widget? body, {bool last = false}) =>
      Stack(children: [
        if (!last)
          Positioned(
              left: 13,
              top: 28,
              bottom: 0,
              child: Container(width: 1, color: coral)),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 28,
              height: 28,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: coral),
              child: Center(
                  child: Text('${number + 1}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)))),
          const SizedBox(width: 18),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(bottom: last ? 0 : 44),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(title,
                                style: const TextStyle(
                                    color: coral,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                        if (body != null) ...[const SizedBox(height: 24), body],
                      ]))),
        ]),
      ]);
  Widget selectForm() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final test in ConsultationTest.values)
          Semantics(
              selected: selected == test,
              button: true,
              child: InkWell(
                key: ValueKey('test-${test.name}'),
                onTap: () => choose(test),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Icon(
                          selected == test
                              ? Icons.circle
                              : Icons.circle_outlined,
                          color: coral,
                          size: 23),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(test.label,
                              style: const TextStyle(fontSize: 12))),
                    ])),
              )),
        if (error != null) errorText(),
        const SizedBox(height: 20),
        compact('Continuar', () {
          if (selected == null) {
            setState(() => error = 'Selecciona una prueba.');
          } else {
            changeStep(1);
          }
        }),
      ]);
  Widget inputForm() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Prueba seleccionada: ${selected!.label}',
            style: const TextStyle(color: coral, fontSize: 12)),
        const SizedBox(height: 20),
        if (selected == ConsultationTest.fever)
          TextField(
              key: const Key('temperature-input'),
              controller: temperature,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Ingrese la temperatura (°C)',
                  hintText: 'Ejemplo: 38,2',
                  border: UnderlineInputBorder(),
                  filled: false),
              onSubmitted: (_) => calculate()),
        if (selected == ConsultationTest.movement) ...[
          TextField(
              key: const Key('weeks-input'),
              controller: weeks,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Semanas de embarazo',
                  border: UnderlineInputBorder(),
                  filled: false)),
          const SizedBox(height: 20),
        ],
        for (final q in questionsFor(selected!, answers)) question(q),
        if (error != null) errorText(),
        const SizedBox(height: 24),
        Wrap(spacing: 12, runSpacing: 12, children: [
          compact('Continuar', calculate),
          compact('Volver', () => changeStep(0), secondary: true)
        ]),
      ]);
  Widget question(ConsultationQuestion q) => Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(q.text, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 6, children: [
          for (final answer in Answer.values)
            ChoiceChip(
              key: ValueKey('answer-${q.id}-${answer.name}'),
              label: Text(switch (answer) {
                Answer.yes => 'Sí',
                Answer.no => 'No',
                Answer.unknown => 'No sé'
              }),
              selected: answers[q.id] == answer,
              onSelected: (_) => setState(() {
                answers[q.id] = answer;
                final visible =
                    questionsFor(selected!, answers).map((q) => q.id).toSet();
                answers.removeWhere((key, _) => !visible.contains(key));
                error = null;
              }),
              selectedColor: const Color(0xFFFFDDE3),
            )
        ]),
      ]));
  Widget results() {
    final value = result!;
    final color = switch (value.level) {
      AlertLevel.urgent => const Color(0xFFFFE0E5),
      AlertLevel.consult => const Color(0xFFFFEFBE),
      _ => const Color(0xFFDFF5FF)
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Prueba seleccionada: ${selected!.label}',
          style: const TextStyle(color: coral, fontSize: 12)),
      if (selected == ConsultationTest.fever)
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
                'Temperatura: ${parseTemperature(temperature.text)!.toStringAsFixed(1)} °C',
                style: const TextStyle(color: Colors.grey, fontSize: 12))),
      if (selected == ConsultationTest.movement)
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Semanas de embarazo: ${weeks.text}',
                style: const TextStyle(color: Colors.grey, fontSize: 12))),
      const SizedBox(height: 24),
      Container(
          key: const Key('consultation-alert'),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black26)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                  value.level == AlertLevel.urgent
                      ? Icons.warning_rounded
                      : Icons.info,
                  size: 22,
                  color: value.level == AlertLevel.urgent
                      ? const Color(0xFFAA1935)
                      : const Color(0xFF23516A)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(value.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)))
            ]),
            const SizedBox(height: 10),
            Text(value.message,
                style: const TextStyle(fontSize: 13, height: 1.4)),
          ])),
      const SizedBox(height: 16),
      const Text(
          'Resultado orientativo; no sustituye la evaluación de un profesional. Si estás preocupada o tienes otros síntomas, busca atención aunque esta prueba no marque alerta.',
          style: TextStyle(fontSize: 11, color: Colors.grey)),
      const SizedBox(height: 32),
      if (value.needsContact) ...[
        FilledButton(
            onPressed: widget.onContact,
            child: const Text('Contactar al centro de salud',
                textAlign: TextAlign.center)),
        const SizedBox(height: 18)
      ],
      Wrap(spacing: 12, runSpacing: 12, children: [
        compact('Iniciar otra prueba', restart),
        compact('Volver', reset, secondary: true)
      ]),
      if (!value.needsContact)
        TextButton(
            onPressed: widget.onContact,
            child: const Text('Contactar al centro de salud',
                textAlign: TextAlign.center)),
      const SizedBox(height: 22),
      TextButton(
          onPressed: showSources,
          child: const Text('Fuentes de esta orientación',
              style: TextStyle(fontSize: 11))),
    ]);
  }

  Widget errorText() => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(error!,
          style: const TextStyle(color: Color(0xFFB00020), fontSize: 12)));
  Widget compact(String text, VoidCallback onPressed,
          {bool secondary = false}) =>
      FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              minimumSize: const Size(105, 36),
              backgroundColor: secondary ? const Color(0xFF656565) : coral,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13)));
  void showSources() => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text('Fuentes'),
              content: const SingleChildScrollView(
                  child: Text(
                      'CDC: signos de advertencia materna.\nwww.cdc.gov/hearher/es/maternal-warning-signs/\n\nNHS: sangrado, movimientos del bebé e hipotermia.\nwww.nhs.uk/pregnancy/\nwww.nhs.uk/conditions/hypothermia/\n\nMINSA / INMP: señales de preeclampsia.\nwww.gob.pe/inmp\n\nConsultadas el 27 de octubre de 2026.')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'))
              ]));
}
