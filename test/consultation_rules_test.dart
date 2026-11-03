import 'package:flutter_test/flutter_test.dart';
import 'package:wiksayuq_yanapay/consultation_rules.dart';

void main() {
  test('Temperatura acepta coma y punto; rechaza lecturas inválidas', () {
    expect(parseTemperature('38,2'), 38.2);
    expect(parseTemperature(' 36.8 '), 36.8);
    for (final input in [
      '',
      'NaN',
      'Infinity',
      'abc',
      '100',
      '29',
      '46',
      '3.8',
      '38,2.1'
    ]) {
      expect(parseTemperature(input), isNull, reason: input);
    }
  });
  test('Fiebre: límites y lecturas bajas no se clasifican como normales', () {
    for (final value in [38.0, 38.2, 40.0, 45.0, 34.9, 30.0]) {
      expect(
          evaluateConsultation(ConsultationTest.fever,
              temperature: value, answers: {}).level,
          AlertLevel.urgent,
          reason: '$value');
    }
    for (final value in [35.0, 35.9]) {
      expect(
          evaluateConsultation(ConsultationTest.fever,
              temperature: value, answers: {}).level,
          AlertLevel.consult);
    }
    for (final value in [36.0, 36.8, 37.9]) {
      expect(
          evaluateConsultation(ConsultationTest.fever,
              temperature: value, answers: {}).level,
          AlertLevel.noSignal);
    }
    expect(
        () => evaluateConsultation(ConsultationTest.fever,
            temperature: double.nan, answers: {}),
        throwsArgumentError);
  });
  test(
      'Cada señal de cefalea e hinchazón requiere atención; incertidumbre consulta',
      () {
    for (final test in [ConsultationTest.headache, ConsultationTest.swelling]) {
      final questions = questionsFor(test, {});
      final none = {for (final q in questions) q.id: Answer.no};
      expect(
          evaluateConsultation(test, answers: none).level, AlertLevel.noSignal);
      for (final q in questions) {
        expect(
            evaluateConsultation(test, answers: {...none, q.id: Answer.yes})
                .level,
            AlertLevel.urgent);
        expect(
            evaluateConsultation(test, answers: {...none, q.id: Answer.unknown})
                .level,
            AlertLevel.consult);
      }
      expect(
          () => evaluateConsultation(test, answers: {}), throwsArgumentError);
    }
  });
  test(
      'Sangrado leve exige valoración y abundante o dolor exige atención inmediata',
      () {
    const test = ConsultationTest.bleeding;
    expect(
        evaluateConsultation(test, answers: {
          'bleeding': Answer.yes,
          'heavy': Answer.no,
          'pain': Answer.no
        }).level,
        AlertLevel.consult);
    expect(
        evaluateConsultation(test, answers: {
          'bleeding': Answer.yes,
          'heavy': Answer.yes,
          'pain': Answer.no
        }).level,
        AlertLevel.urgent);
    expect(
        evaluateConsultation(test, answers: {
          'bleeding': Answer.yes,
          'heavy': Answer.no,
          'pain': Answer.yes
        }).level,
        AlertLevel.urgent);
    expect(
        evaluateConsultation(test,
            answers: {'bleeding': Answer.no, 'heavy': Answer.yes}).level,
        AlertLevel.noSignal);
    expect(
        evaluateConsultation(test, answers: {'bleeding': Answer.unknown}).level,
        AlertLevel.consult);
  });
  test(
      'Movimientos: cambios urgen sin contar patadas; ausencia de inicio no da tranquilidad falsa',
      () {
    const test = ConsultationTest.movement;
    expect(
        evaluateConsultation(test,
            weeks: 28,
            answers: {'usual': Answer.yes, 'changed': Answer.yes}).level,
        AlertLevel.urgent);
    expect(
        evaluateConsultation(test,
            weeks: 28,
            answers: {'usual': Answer.yes, 'changed': Answer.no}).level,
        AlertLevel.noSignal);
    expect(
        evaluateConsultation(test, weeks: 18, answers: {'usual': Answer.no})
            .level,
        AlertLevel.undetermined);
    expect(
        evaluateConsultation(test, weeks: 24, answers: {'usual': Answer.no})
            .level,
        AlertLevel.consult);
    expect(
        evaluateConsultation(test,
            weeks: 30, answers: {'usual': Answer.unknown}).level,
        AlertLevel.consult);
    expect(
        () =>
            evaluateConsultation(test, weeks: 0, answers: {'usual': Answer.no}),
        throwsArgumentError);
  });
}
