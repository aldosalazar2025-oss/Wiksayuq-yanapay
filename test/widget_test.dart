import 'package:wiksayuq_yanapay/alarm_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiksayuq_yanapay/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('Bienvenida completa y navegación a información original', (
    tester,
  ) async {
    await tester.pumpWidget(const YanapayApp());
    final appearance = find.byKey(const Key('splash-fade'));
    expect(tester.widget<FadeTransition>(appearance).opacity.value, 0);
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.widget<FadeTransition>(appearance).opacity.value,
        greaterThan(0));
    expect(
        tester.widget<FadeTransition>(appearance).opacity.value, lessThan(1));
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.getCenter(find.byKey(const Key('splash-title'))),
        const Offset(400, 300));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido a\nWiksayuq Yanapay'), findsOneWidget);
    expect(find.text('Reconoce a tiempo'), findsOneWidget);
    expect(
        find.text(
            'Bienvenida, mamá. Este aplicativo te ayudará a reconocer los signos de alarma y saber qué hacer para proteger tu salud y la de tu bebé.'),
        findsOneWidget);
    expect(find.byKey(const Key('maternal-illustration')), findsOneWidget);
    await tester.tap(find.text('SIGUIENTE'));
    await tester.pumpAndSettle();
    expect(find.text('Decide con seguridad'), findsOneWidget);
    expect(
        find.text(
            'Ante la duda, te guiamos paso a paso para evaluar la situación y ayudarte a decidir con calma si es momento de buscar ayuda.'),
        findsOneWidget);
    expect(find.byKey(const Key('ultrasound-illustration')), findsOneWidget);
    final back = find.byTooltip('Regresar');
    expect(tester.getCenter(back).dy, tester.getCenter(find.text('Omitir')).dy);
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('Reconoce a tiempo'), findsOneWidget);
    await tester.tap(find.text('SIGUIENTE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SIGUIENTE'));
    await tester.pumpAndSettle();
    expect(find.text('Conéctate al instante'), findsOneWidget);
    expect(
        find.text(
            'Localiza y contacta rápidamente al centro de salud más cercano. Sin perder tiempo valioso cuando cada segundo cuenta.'),
        findsOneWidget);
    expect(find.byKey(const Key('map-illustration')), findsOneWidget);
    expect(tester.getCenter(find.byTooltip('Regresar')).dy,
        tester.getCenter(find.text('Omitir')).dy);
    await tester.tap(find.byTooltip('Regresar'));
    await tester.pumpAndSettle();
    expect(find.text('Decide con seguridad'), findsOneWidget);
    await tester.tap(find.text('SIGUIENTE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('COMENZAR'));
    await tester.pumpAndSettle();
    expect((await SharedPreferences.getInstance()).getBool('completed_welcome'),
        true);
    await tester.pumpWidget(YanapayApp(key: UniqueKey()));
    await tester.pump();
    expect(find.byKey(const Key('splash')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido a\nWiksayuq Yanapay'), findsNothing);

    expect(find.text('Aprender signos de alarma'), findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byKey(const Key('home-signs')),
        matching: find.text('Iniciar')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sangrado vaginal'));
    await tester.pumpAndSettle();
    expect(find.text('Sangrado vaginal'), findsOneWidget);
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'bleeding');
    expect(
        find.textContaining(
            'El sangrado por la vagina durante el embarazo NUNCA es normal.'),
        findsOneWidget);
    expect(find.text('Buscar atención'), findsOneWidget);
    expect(find.byKey(const Key('medical-poster')), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
    final viewer = tester
        .widget<InteractiveViewer>(find.byKey(const Key('medical-poster')));
    expect(viewer.transformationController!.value.getMaxScaleOnAxis(),
        greaterThan(1));
    await tester.tap(find.byTooltip('Restablecer vista'));
    await tester.pumpAndSettle();
    expect(viewer.transformationController!.value.getMaxScaleOnAxis(), 1);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Buscar atención'), -200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Signos muestra las ocho opciones en el orden de las capturas',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    const labels = [
      'Sangrado vaginal',
      'Dolor de cabeza, zumbidos de oído y dolor en la boca de estomago',
      'Fiebre',
      'Pérdida de líquido',
      'Disminución del movimiento del bebé',
      'Hinchazón de pies, cara y manos',
      'Nauseas y vomitos',
      'Disminución o ausencia de los movimientos fetales',
    ];
    for (var i = 0; i < labels.length; i++) {
      final card = find.byKey(ValueKey('alarm-option-$i'));
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      expect(find.descendant(of: card, matching: find.text(labels[i])),
          findsOneWidget);
    }
    await tester.tap(find.byKey(const ValueKey('alarm-option-7')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fetal-media-carousel')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Dolor de cabeza abre su descripción y video', (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.tap(find.byKey(const ValueKey('alarm-option-1')));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Dolor de cabeza, zumbidos de oído y dolor en la boca de estomago'),
        findsOneWidget);
    expect(find.textContaining('pueden ser señales de preeclampsia'),
        findsOneWidget);
    expect(find.byKey(const Key('headache-media-carousel')), findsOneWidget);
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Fiebre abre la descripción, lámina ampliable y atención',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.tap(find.byKey(const ValueKey('alarm-option-2')));
    await tester.pumpAndSettle();
    expect(find.text('Fiebre'), findsOneWidget);
    expect(find.textContaining('No te automediques.'), findsOneWidget);
    final preview = find.byKey(const Key('fever-poster-preview'));
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();
    await tester.tap(preview);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<InteractiveViewer>(find.byKey(const Key('medical-poster')))
            .transformationController!
            .value
            .getMaxScaleOnAxis(),
        greaterThan(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Pérdida de líquido abre su lámina y atención', (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.tap(find.byKey(const ValueKey('alarm-option-3')));
    await tester.pumpAndSettle();
    expect(find.text('Pérdida de líquido'), findsOneWidget);
    expect(
        find.textContaining('El líquido amniótico rodea y protege a tu bebé.'),
        findsOneWidget);
    final preview = find.byKey(const Key('section-media-photo-0'));
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();
    await tester.tap(preview);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<InteractiveViewer>(find.byKey(const Key('medical-poster')))
            .transformationController!
            .value
            .getMaxScaleOnAxis(),
        greaterThan(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('section-media-pages')));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Video 1 de 1'), findsOneWidget);
    expect(find.byKey(const Key('fluid-loss-video')), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Buscar atención'), -200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Disminución del movimiento abre su guía y atención',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.ensureVisible(find.byKey(const ValueKey('alarm-option-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('alarm-option-4')));
    await tester.pumpAndSettle();
    expect(find.text('Disminución del movimiento del bebé'), findsOneWidget);
    expect(
        find.textContaining(
            'Es la reducción en la frecuencia, intensidad o duración'),
        findsOneWidget);
    final preview = find.byKey(const Key('baby-movement-poster-preview'));
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();
    await tester.tap(preview);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<InteractiveViewer>(find.byKey(const Key('medical-poster')))
            .transformationController!
            .value
            .getMaxScaleOnAxis(),
        greaterThan(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Hinchazón abre su lámina y atención', (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.ensureVisible(find.byKey(const ValueKey('alarm-option-5')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('alarm-option-5')));
    await tester.pumpAndSettle();
    expect(find.text('Hinchazón de pies, cara y manos'), findsOneWidget);
    expect(find.textContaining('La hinchazón repentina de pies, manos o cara'),
        findsOneWidget);
    final preview = find.byKey(const Key('swelling-poster-preview'));
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();
    await tester.tap(preview);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<InteractiveViewer>(find.byKey(const Key('medical-poster')))
            .transformationController!
            .value
            .getMaxScaleOnAxis(),
        greaterThan(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Náuseas y vómitos abre su descripción y video', (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.ensureVisible(find.byKey(const ValueKey('alarm-option-6')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('alarm-option-6')));
    await tester.pumpAndSettle();
    expect(find.text('Nauseas y vomitos'), findsOneWidget);
    expect(find.textContaining('pueden causar deshidratación'), findsOneWidget);
    expect(find.byKey(const Key('nausea-media-carousel')), findsOneWidget);
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Ausencia de movimientos fetales abre su video y atención',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'signs'));
    await tester.ensureVisible(find.byKey(const ValueKey('alarm-option-7')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('alarm-option-7')));
    await tester.pumpAndSettle();
    expect(find.text('Disminución o ausencia de los movimientos fetales'),
        findsOneWidget);
    expect(find.textContaining('No esperes al día siguiente para consultar.'),
        findsOneWidget);
    expect(find.byKey(const Key('fetal-media-carousel')), findsOneWidget);
    await tester.tap(find.text('Buscar atención'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'search');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Carrusel fetal muestra foto antes del video y permite volver',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'fetalMovement'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('section-media-photo-0')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Video 1 de 1'), findsOneWidget);
    expect(find.byKey(const Key('fetal-movement-video')), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Carrusel de náuseas conserva foto antes del video',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'nausea'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('section-media-photo-0')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Video 1 de 1'), findsOneWidget);
    expect(find.byKey(const Key('nausea-video')), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Carrusel de dolor de cabeza muestra foto antes del video',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'headache'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('section-media-photo-0')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Video 1 de 1'), findsOneWidget);
    expect(find.byKey(const Key('headache-video')), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Carrusel de sangrado conserva foto antes del video',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'bleeding'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('section-media-photo-0')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('section-media-photo-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('medical-poster')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Video 1 de 1'), findsOneWidget);
    expect(find.byKey(const Key('bleeding-video')), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('section-media-pages')), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1 de 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Buscar atención tiene tres imágenes y documentos informativos',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'search'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué hacer?'), findsOneWidget);
    expect(find.text('Antes de salir'), findsOneWidget);
    for (final label in [
      'Llevar DNI',
      'Carnet prenatal',
      'Resultados médicos (opcional)'
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(Radio), findsNothing);
    final strip = find.byKey(const Key('attention-images'));
    expect(find.byKey(const Key('attention-image-0')), findsOneWidget);
    await tester.drag(strip, const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('attention-image-1')), findsOneWidget);
    await tester.drag(strip, const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('attention-image-2')), findsOneWidget);
    await tester.tap(find.text('Contactar al centro de salud'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'contact');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Contactar copia todos los textos de la referencia',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'contact'));
    await tester.pumpAndSettle();
    expect(find.text('Contactar'), findsOneWidget);
    expect(find.text('Telefono'), findsOneWidget);
    expect(find.text('Dr. Lorem Ipsum is simply dummy'), findsNWidgets(4));
    expect(find.text('ubicación'), findsOneWidget);
    expect(find.text('Mariano ignacio Prado S/N Chilca,\nChilca, Perú'),
        findsOneWidget);
    expect(find.text('Horario de atención'), findsOneWidget);
    expect(find.text('Lunes a viernes: 08:00 am - 05:30 pm'), findsNWidgets(2));
    await tester.scrollUntilVisible(
        find.text('“TE RECOMENDAMOS EL CENTRO DE SALUD DE CHILCA”'), 200);
    expect(find.text('“TE RECOMENDAMOS EL CENTRO DE SALUD DE CHILCA”'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Consulta fiebre valida, alerta, reinicia y vuelve a opciones',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'consultation'));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Selecciona una prueba.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('test-fever')));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(
        find.textContaining('Ingresa una temperatura válida'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('temperature-input')), '38,2');
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('test-fever')), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('38,2'), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Señal de alarma: fiebre'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Iniciar otra prueba'), 160);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar otra prueba'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('temperature-input')), findsOneWidget);
    expect(
        tester
            .widget<TextField>(find.byKey(const Key('temperature-input')))
            .controller!
            .text,
        isEmpty);
    await tester.enterText(find.byKey(const Key('temperature-input')), '36.8');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(
        find.text('No se detectó fiebre con esta temperatura'), findsOneWidget);
    final alert =
        tester.widget<Container>(find.byKey(const Key('consultation-alert')));
    expect((alert.decoration as BoxDecoration).color, const Color(0xFFDFF5FF));
    await tester.scrollUntilVisible(find.text('Volver'), 160);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('test-headache')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Consulta sangrado requiere preguntas y permite contactar',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'consultation'));
    await tester.tap(find.byKey(const ValueKey('test-bleeding')));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('answer-bleeding-yes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('answer-heavy-yes')));
    await tester.ensureVisible(find.byKey(const ValueKey('answer-pain-no')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('answer-pain-no')));
    await tester.scrollUntilVisible(find.text('Continuar'), 160);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Señal de alarma'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.text('Contactar al centro de salud'), 160);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contactar al centro de salud'));
    await tester.pumpAndSettle();
    expect((tester.state(find.byType(AppShell)) as dynamic).page, 'contact');
    expect(tester.takeException(), isNull);
  });
  for (final scenario in ['headache', 'movement', 'swelling']) {
    testWidgets(
        'Consulta $scenario completa los tres pasos en pantalla pequeña',
        (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Future<void> tapVisible(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await tester.pumpWidget(const YanapayApp(initialPage: 'consultation'));
      await tapVisible(find.byKey(ValueKey('test-$scenario')));
      await tapVisible(find.text('Continuar'));
      if (scenario == 'movement') {
        await tester.enterText(find.byKey(const Key('weeks-input')), '28');
        await tapVisible(find.byKey(const ValueKey('answer-usual-yes')));
        await tapVisible(find.byKey(const ValueKey('answer-changed-no')));
      } else {
        final ids = scenario == 'headache'
            ? ['headache', 'vision', 'associated']
            : ['sudden', 'leg', 'associated'];
        for (final id in ids) {
          await tapVisible(find.byKey(ValueKey('answer-$id-no')));
        }
      }
      await tapVisible(find.text('Continuar'));
      expect(find.text('No se detectó esta señal de alarma'), findsOneWidget);
      await tapVisible(find.text('Volver'));
      expect(find.byKey(const ValueKey('test-fever')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Menú abre tres ventanas con fondo difuminado y texto exacto',
      (tester) async {
    await tester.pumpWidget(const YanapayApp(initialPage: 'menu'));
    expect(find.text('Versión 1.0.2'), findsOneWidget);
    expect(find.textContaining('Prototipo'), findsNothing);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(ValueKey('menu-option-$i')));
      await tester.pumpAndSettle();
      final dialog = find.byKey(const Key('menu-information-dialog'));
      expect(dialog, findsOneWidget);
      expect(find.byKey(const Key('menu-background-blur')), findsOneWidget);
      if (i == 0) {
        expect(
            find.descendant(
                of: dialog,
                matching: find.text(
                    'Ayuda a reconocer signos de alarma durante el embarazo y actuar oportunamente.')),
            findsOneWidget);
        expect(find.text('Mujeres gestantes.'), findsOneWidget);
        expect(find.text('Asistir a controles prenatales.'), findsOneWidget);
        expect(find.text('No automedicarse.'), findsOneWidget);
        expect(find.text('Alimentación saludable.'), findsOneWidget);
      } else if (i == 1) {
        expect(find.text('Aplicación desarrollado por:'), findsOneWidget);
        expect(find.text('Agradecimiento:'), findsOneWidget);
        expect(find.text('Dr. Lorem Ipsum is simply dummy'), findsNWidgets(4));
      } else {
        expect(
            find.textContaining(
                'Lorem Ipsum is simply dummy text of the printing'),
            findsOneWidget);
        expect(find.textContaining('It was popularised in the 1960s'),
            findsOneWidget);
      }
      await tester.tap(find.byTooltip('Cerrar ventana'));
      await tester.pumpAndSettle();
      expect(dialog, findsNothing);
      expect((tester.state(find.byType(AppShell)) as dynamic).page, 'menu');
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
      'Las ocho pantallas usan el título completo de su tarjeta sin recorte',
      (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    for (var i = 0; i < AlarmCatalog.routes.length; i++) {
      await tester.pumpWidget(YanapayApp(
          key: ValueKey('header-$i'), initialPage: AlarmCatalog.routes[i]));
      await tester.pumpAndSettle();
      final title = find.text(AlarmCatalog.titles[i]);
      expect(title, findsOneWidget);
      final text = tester.widget<Text>(title);
      expect(text.maxLines, isNull);
      expect(text.overflow, TextOverflow.visible);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(tester.getSize(title).height,
          lessThanOrEqualTo(appBar.toolbarHeight!));
      expect(tester.takeException(), isNull, reason: AlarmCatalog.routes[i]);
    }
  });
  testWidgets('Pantallas principales no desbordan un teléfono pequeño', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final route in [
      'onboarding',
      'home',
      'signs',
      'signDetail',
      'bleeding',
      'headache',
      'fever',
      'fluidLoss',
      'babyMovement',
      'swelling',
      'nausea',
      'fetalMovement',
      'search',
      'contact',
      'menu',
      'menuDisclaimer',
      'consultation',
    ]) {
      await tester.pumpWidget(
        YanapayApp(key: ValueKey(route), initialPage: route),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
    }
  });
}
