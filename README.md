# Wiksayuq Yanapay — Versión 1.0.2

Proyecto Flutter completo con código fuente, imágenes, videos y recursos Android/web.

## Compilar

SDK recomendado y usado en las pruebas: Flutter 3.47.2 estable / Dart 3.13.2. Se requiere Android SDK y Java compatible (la configuración del proyecto usa Java 17).

Abre la carpeta `wiksayuq_yanapay` en Android Studio o VS Code y ejecuta:

```sh
flutter pub get
flutter test
flutter build apk --release
```

APK resultante: `build/app/outputs/flutter-apk/app-release.apk`.

En Windows también puedes ejecutar `compilar_android.cmd`. El script resuelve dependencias, analiza, prueba y genera el APK.

Para ejecutar en un dispositivo o en Chrome:

```sh
flutter run
flutter run -d chrome
```

Para web:

```sh
flutter build web --release
```

La carpeta `build/web` se sirve por HTTP. Para publicar en una tienda, configura tu propia firma Android; el proyecto conserva la firma de desarrollo del generador Flutter.

## Incluido

- Versión de aplicación 1.0.2 y número de compilación Android 3; el menú muestra únicamente `Versión 1.0.2`.
- Icono WY con fondo adaptativo coral y recursos web.
- Portada animada. La bienvenida se muestra hasta llegar por primera vez a Inicio; después, cada apertura reproduce la animación y va directamente a Inicio.
- Tres pantallas de bienvenida con las imágenes y textos proporcionados, Regresar, Omitir y COMENZAR.
- Inicio con tres tarjetas de fotografía y botones Iniciar.
- Ocho opciones de signos de alarma, centradas y en negrita. Se eliminó Tenlo en cuenta.
- Títulos completos en varias líneas y coincidentes con los textos de sus tarjetas, también en los visores de imágenes.
- Láminas que se abren a pantalla completa, con zoom, desplazamiento y restablecimiento.
- Carruseles horizontales: fotos antes de los videos. Todos los archivos están incluidos como assets.
- Miniaturas reales extraídas del primer segundo de los cinco videos.
- Reproductor de altura acotada con controles sobre la imagen: reproducción/pausa, sonido, avance/retroceso, barra de posición y pantalla completa. Los controles también están disponibles antes de iniciar el video. No hay desplazamiento interno para acceder a ellos.
- Buscar atención con tres imágenes deslizables y lista informativa de documentos, sin casillas seleccionables.
- Contactar con el texto solicitado de la maqueta, incluidas las líneas de ejemplo y los horarios repetidos.
- Consulta en tres pasos para las cinco opciones solicitadas: elegir, ingresar datos y resultado. Incluye Volver, repetir la prueba y Contactar.
- Menú con ventanas, fondo difuminado, cierre con X y textos de las capturas.

## Consulta y datos

La consulta es orientación sobre señales de alarma, no un diagnóstico ni una escala clínica validada. Los criterios y sus fuentes se documentan en `FUENTES_CONSULTA.md`; el equipo clínico responsable debe revisarlos antes de un uso asistencial.

Los resultados celestes indican que no se identificó la señal evaluada o que la valoración es indeterminada; no garantizan normalidad. Las respuestas No sé no se consideran negativas. El reinicio limpia los datos y vuelve al ingreso de la misma prueba; Volver en Resultados regresa a la selección.

Los datos de consulta son temporales: no se guardan ni se transmiten. Solo se guarda localmente la finalización de la bienvenida. Contactar abre la pantalla informativa; no realiza llamadas, envía mensajes ni consulta un directorio externo.

## Dependencias y estructura

- `shared_preferences`: recordar la bienvenida.
- `video_player`: reproducir los MP4 locales.
- `lib/`: pantallas, reglas y componentes.
- `assets/images/`, `assets/videos/`, `assets/video_thumbnails/`: recursos incluidos.
- `assets/branding/`: icono original y vista de control.
- `android/` y `web/`: proyectos de plataforma.
- `test/`: pruebas de reglas y de interfaz.
- `FUENTES.md` y `FUENTES_CONSULTA.md`: fuentes de los textos investigados.

## Verificación de esta entrega

27 de octubre de 2026:

- 30 pruebas aprobadas.
- Análisis de `lib` y `test`: sin incidencias de código.
- Se verificaron miniaturas y ubicación de todos los controles dentro del marco del reproductor.
- Los controles de reproducción, sonido, avance y entrada/salida de pantalla completa se probaron con un adaptador de video simulado. La decodificación real y el icono deben comprobarse en Android.
- No se compiló un APK de esta versión en esta entrega. Se entrega el proyecto para compilarlo con los comandos anteriores.

Las láminas y videos se incorporan sin modificar su contenido. Las miniaturas corresponden a fotogramas de los archivos originales.
