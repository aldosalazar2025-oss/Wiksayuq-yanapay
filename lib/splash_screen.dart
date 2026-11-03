import 'package:flutter/material.dart';

/// Presentación de marca: aparición, pausa y desvanecimiento.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> opacity;
  late final Animation<Offset> position;
  bool started = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onFinished();
      });
    opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 43,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 43),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 14,
      ),
    ]).animate(controller);
    position = Tween<Offset>(begin: const Offset(0, .12), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0, .43, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!started) {
      started = true;
      if (MediaQuery.disableAnimationsOf(context)) {
        controller.duration = const Duration(milliseconds: 1800);
      }
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    const title = Text(
      'Wiksayuq\nYanapay',
      key: Key('splash-title'),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 36,
        height: 1.35,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      key: const Key('splash'),
      backgroundColor: const Color(0xFFFF5F73),
      body: SizedBox.expand(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: reducedMotion
                ? title
                : FadeTransition(
                    key: const Key('splash-fade'),
                    opacity: opacity,
                    child: SlideTransition(position: position, child: title),
                  ),
          ),
        ),
      ),
    );
  }
}
