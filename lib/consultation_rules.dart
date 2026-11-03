// Criterios orientativos documentados en FUENTES_CONSULTA.md.
enum ConsultationTest {
  fever('Fiebre'),
  headache('Dolor de cabeza / síntomas asociados'),
  bleeding('Sangrado vaginal'),
  movement('Movimientos del bebé'),
  swelling('Hinchazon (edema)');

  const ConsultationTest(this.label);
  final String label;
}

enum Answer { yes, no, unknown }

enum AlertLevel { urgent, consult, noSignal, undetermined }

class ConsultationQuestion {
  const ConsultationQuestion(this.id, this.text);
  final String id, text;
}

class ConsultationResult {
  const ConsultationResult(this.level, this.title, this.message);
  final AlertLevel level;
  final String title, message;
  bool get needsContact =>
      level == AlertLevel.urgent || level == AlertLevel.consult;
}

List<ConsultationQuestion> questionsFor(
        ConsultationTest test, Map<String, Answer> answers) =>
    switch (test) {
      ConsultationTest.fever => [],
      ConsultationTest.headache => const [
          ConsultationQuestion('headache',
              '¿Tienes dolor de cabeza intenso, persistente o que empeora?'),
          ConsultationQuestion(
              'vision', '¿Tienes visión borrosa, luces o manchas en la vista?'),
          ConsultationQuestion('associated',
              '¿Tienes zumbidos en los oídos o dolor en la boca del estómago?'),
        ],
      ConsultationTest.bleeding => [
          const ConsultationQuestion('bleeding',
              '¿Tienes o has tenido sangrado vaginal durante este embarazo?'),
          if (answers['bleeding'] == Answer.yes) ...const [
            ConsultationQuestion('heavy',
                '¿El sangrado es abundante y empapa rápidamente una toalla higiénica?'),
            ConsultationQuestion('pain',
                '¿Se acompaña de dolor abdominal intenso, dolor de hombro, mareos o desmayo?'),
          ],
        ],
      ConsultationTest.movement => [
          const ConsultationQuestion(
              'usual', '¿Ya sentías habitualmente los movimientos de tu bebé?'),
          if (answers['usual'] == Answer.yes)
            const ConsultationQuestion('changed',
                '¿Ahora se mueve menos, ha dejado de moverse o cambió su patrón habitual?'),
        ],
      ConsultationTest.swelling => const [
          ConsultationQuestion('sudden',
              '¿Tienes hinchazón repentina o intensa en manos o cara?'),
          ConsultationQuestion('leg',
              '¿Tienes hinchazón con dolor, calor o enrojecimiento en una sola pierna?'),
          ConsultationQuestion('associated',
              '¿La hinchazón se acompaña de dolor de cabeza intenso, visión borrosa o dolor en la boca del estómago?'),
        ],
    };

double? parseTemperature(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  if (!RegExp(r'^\d{2}(\.\d{1,2})?$').hasMatch(normalized)) return null;
  final value = double.tryParse(normalized);
  return value != null && value.isFinite && value >= 30 && value <= 45
      ? value
      : null;
}

ConsultationResult evaluateConsultation(ConsultationTest test,
    {double? temperature, int? weeks, required Map<String, Answer> answers}) {
  const urgent = ConsultationResult(AlertLevel.urgent, 'Señal de alarma',
      'Busca atención médica de inmediato. No esperes a repetir esta prueba para pedir ayuda.');
  const consult = ConsultationResult(AlertLevel.consult, 'Consulta necesaria',
      'Comunícate con tu centro de salud para recibir una valoración. Esta prueba no puede descartar un problema.');
  const noSignal = ConsultationResult(
      AlertLevel.noSignal,
      'No se detectó esta señal de alarma',
      'Según tus respuestas no se identificó la señal evaluada. Esto no confirma que todo esté normal; si te sientes mal o notas otros síntomas, busca atención.');
  if (test == ConsultationTest.fever) {
    if (temperature == null ||
        !temperature.isFinite ||
        temperature < 30 ||
        temperature > 45) throw ArgumentError('Temperatura inválida');
    if (temperature >= 38)
      return const ConsultationResult(
          AlertLevel.urgent,
          'Señal de alarma: fiebre',
          'La temperatura es de 38 °C o más. Durante el embarazo requiere atención médica de inmediato.');
    if (temperature < 35)
      return const ConsultationResult(AlertLevel.urgent, 'Temperatura muy baja',
          'Una temperatura por debajo de 35 °C requiere atención médica urgente.');
    if (temperature < 36)
      return const ConsultationResult(AlertLevel.consult, 'Revisa la medición',
          'La lectura es baja. Comprueba que el termómetro se utilizó correctamente y consulta al personal de salud si persiste o te sientes mal.');
    return const ConsultationResult(
        AlertLevel.noSignal,
        'No se detectó fiebre con esta temperatura',
        'La lectura está por debajo de 38 °C. Esto no descarta otros problemas: si te sientes mal o tienes otros signos de alarma, busca atención.');
  }
  final questions = questionsFor(test, answers);
  if (questions.any((q) => !answers.containsKey(q.id)))
    throw ArgumentError('Responde todas las preguntas');
  final values = questions.map((q) => answers[q.id]!);
  if (test == ConsultationTest.bleeding) {
    if (answers['bleeding'] == Answer.yes &&
        (answers['heavy'] == Answer.yes || answers['pain'] == Answer.yes))
      return urgent;
    if (answers['bleeding'] == Answer.yes)
      return const ConsultationResult(
          AlertLevel.consult,
          'Sangrado: requiere valoración',
          'Aunque sea un manchado leve, busca orientación médica urgente para valorar su causa. Si es abundante o hay dolor intenso, mareo o desmayo, acude a emergencias.');
    return answers['bleeding'] == Answer.unknown ? consult : noSignal;
  }
  if (test == ConsultationTest.movement) {
    if (weeks == null || weeks < 1 || weeks > 45)
      throw ArgumentError('Semana inválida');
    if (answers['usual'] == Answer.yes && answers['changed'] == Answer.yes)
      return const ConsultationResult(
          AlertLevel.urgent,
          'Cambio en los movimientos del bebé',
          'Contacta de inmediato con tu servicio de maternidad. No esperes al día siguiente ni uses un número de patadas para descartar el riesgo.');
    if (values.contains(Answer.unknown)) return consult;
    if (answers['usual'] == Answer.no) {
      if (weeks >= 24)
        return const ConsultationResult(
            AlertLevel.consult,
            'Necesitas una valoración',
            'Si a las 24 semanas aún no has sentido movimientos, comunícalo al personal de salud para que evalúe a tu bebé.');
      return const ConsultationResult(
          AlertLevel.undetermined,
          'Aún no se puede valorar un cambio',
          'Si todavía no sentías movimientos habitualmente, no es posible valorar una disminución con esta prueba. Coméntalo en tu control prenatal y consulta antes si te preocupa algo.');
    }
    return noSignal;
  }
  if (values.contains(Answer.yes)) return urgent;
  if (values.contains(Answer.unknown)) return consult;
  return noSignal;
}
