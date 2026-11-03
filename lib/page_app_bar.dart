import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Ajusta la altura al texto y al tamaño de letra elegido en el teléfono.
AppBar pageAppBar(BuildContext context,
    {required String title, Widget? leading}) {
  final style =
      (Theme.of(context).appBarTheme.titleTextStyle ?? const TextStyle())
          .copyWith(fontSize: 18, fontWeight: FontWeight.w600, height: 1.25);
  final text = TextPainter(
    text: TextSpan(text: title, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout(maxWidth: math.max(1.0, MediaQuery.sizeOf(context).width - 136));
  final height = math.max(kToolbarHeight, text.height + 24);
  text.dispose();
  return AppBar(
    toolbarHeight: height,
    leading: leading,
    centerTitle: true,
    titleSpacing: 12,
    title: Text(title,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: null,
        overflow: TextOverflow.visible,
        style: style),
  );
}
