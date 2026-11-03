import 'alarm_catalog.dart';
import 'page_app_bar.dart';
import 'menu_screen.dart';
import 'consultation_screen.dart';
import 'contact_screen.dart';
import 'search_attention_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'decision_welcome_screen.dart';
import 'connection_welcome_screen.dart';
import 'home_action_card.dart';
import 'bleeding_detail_screen.dart';
import 'headache_detail_screen.dart';
import 'fever_detail_screen.dart';
import 'fluid_loss_detail_screen.dart';
import 'baby_movement_detail_screen.dart';
import 'swelling_detail_screen.dart';
import 'nausea_detail_screen.dart';
import 'fetal_movement_detail_screen.dart';

const coral = Color(0xFFFF5F73);
const paper = Color(0xFFFBFBFB);
const ink = Color(0xFF27232C);
void main() => runApp(const YanapayApp());

class YanapayApp extends StatelessWidget {
  const YanapayApp({super.key, this.initialPage = 'splash'});
  final String initialPage;
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Wiksayuq Yanapay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: paper,
          colorScheme: ColorScheme.fromSeed(
            seedColor: coral,
            primary: coral,
            surface: paper,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: paper,
            foregroundColor: ink,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: ink,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 15, height: 1.45, color: ink),
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: coral,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE4E0E1)),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        home: AppShell(initialPage: initialPage),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.initialPage});
  final String initialPage;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late String page = widget.initialPage;
  final List<String> history = [];
  static const completedWelcomeKey = 'completed_welcome';
  late final Future<SharedPreferences> preferences;

  @override
  void initState() {
    super.initState();
    preferences = SharedPreferences.getInstance();
  }

  Future<void> finishWelcome() async {
    final storage = await preferences;
    await storage.setBool(completedWelcomeKey, true);
    if (!mounted) return;
    setState(() {
      page = 'home';
      history.clear();
    });
  }

  int intro = 0;

  String language = 'Español';
  String selectedSign = 'Dolor de cabeza';
  bool videoOpen = false;

  void go(String target) => setState(() {
        history.add(page);
        page = target;
      });
  void back() => setState(() {
        page = history.isEmpty ? 'home' : history.removeLast();
      });
  void tab(int index) => setState(() {
        history.clear();
        page = ['home', 'consultation', 'menu'][index];
      });
  void notice(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
  int get activeTab => page.startsWith('menu')
      ? 2
      : page.startsWith('consult')
          ? 1
          : 0;
  static const signs = AlarmCatalog.titles;
  @override
  Widget build(BuildContext context) {
    if (page == 'splash') {
      return SplashScreen(onFinished: () async {
        final storage = await preferences;
        if (!mounted || page != 'splash') return;
        setState(() {
          page = storage.getBool(completedWelcomeKey) == true
              ? 'home'
              : 'onboarding';
          history.clear();
        });
      });
    }
    if (page == 'onboarding') return onboarding();
    final title = switch (page) {
      'home' => 'Inicio',
      'signs' => 'Signos de alarma',
      'bleeding' => AlarmCatalog.titles[0],
      'headache' => AlarmCatalog.titles[1],
      'fever' => AlarmCatalog.titles[2],
      'fluidLoss' => AlarmCatalog.titles[3],
      'babyMovement' => AlarmCatalog.titles[4],
      'swelling' => AlarmCatalog.titles[5],
      'nausea' => AlarmCatalog.titles[6],
      'fetalMovement' => AlarmCatalog.titles[7],
      'signDetail' => '',
      'video' => 'Tenlo en cuenta',
      'search' => 'Buscar atención',
      'contact' => 'Contactar',
      'consultation' => 'Consulta',
      'consultResult' => 'Consulta',
      _ => 'Menú',
    };
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) back();
      },
      child: Scaffold(
        appBar: page == 'signDetail'
            ? null
            : pageAppBar(
                context,
                title: title,
                leading:
                    page == 'home' || page == 'consultation' || page == 'menu'
                        ? null
                        : IconButton(
                            onPressed: back,
                            icon: const Icon(Icons.chevron_left),
                          ),
              ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              key: ValueKey(page),
              constraints: const BoxConstraints(maxWidth: 480),
              child: switch (page) {
                'home' => home(),
                'signs' => signGrid(),
                'signDetail' => signDetail(),
                'bleeding' =>
                  BleedingDetailScreen(onSeekCare: () => go('search')),
                'headache' =>
                  HeadacheDetailScreen(onSeekCare: () => go('search')),
                'fever' => FeverDetailScreen(onSeekCare: () => go('search')),
                'fluidLoss' =>
                  FluidLossDetailScreen(onSeekCare: () => go('search')),
                'babyMovement' =>
                  BabyMovementDetailScreen(onSeekCare: () => go('search')),
                'swelling' =>
                  SwellingDetailScreen(onSeekCare: () => go('search')),
                'nausea' => NauseaDetailScreen(onSeekCare: () => go('search')),
                'fetalMovement' =>
                  FetalMovementDetailScreen(onSeekCare: () => go('search')),
                'video' => video(),
                'search' => search(),
                'contact' => contact(),
                'consultation' => consultation(),
                'consultResult' => consultation(),
                'menu' => menu(),
                'menuAbout' => menuArticle(0),
                'menuCredits' => menuArticle(1),
                'menuDisclaimer' => menuArticle(2),
                _ => home(),
              },
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          indicatorColor: coral.withValues(alpha: .10),
          selectedIndex: activeTab,
          onDestinationSelected: tab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: coral),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.medical_services_outlined),
              selectedIcon: Icon(Icons.medical_services_outlined, color: coral),
              label: 'Consulta',
            ),
            NavigationDestination(icon: Icon(Icons.menu), label: 'Menú'),
          ],
        ),
      ),
    );
  }

  Widget onboarding() {
    if (intro == 0) {
      return WelcomeScreen(
        onSkip: finishWelcome,
        onNext: () => setState(() => intro = 1),
      );
    }
    if (intro == 1) {
      return DecisionWelcomeScreen(
        onBack: () => setState(() => intro = 0),
        onSkip: finishWelcome,
        onNext: () => setState(() => intro = 2),
      );
    }
    return ConnectionWelcomeScreen(
      onBack: () => setState(() => intro = 1),
      onSkip: finishWelcome,
      onNext: finishWelcome,
    );
  }

  Widget home() => ListView(
        key: const PageStorageKey('home'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(14, 20, 14, 20),
        children: [
          HomeActionCard(
              key: const Key('home-signs'),
              title: 'Aprender signos de alarma',
              onStart: () => go('signs')),
          const SizedBox(height: 30),
          HomeActionCard(
              key: const Key('home-attention'),
              title: 'Decisión de buscar atención',
              onStart: () => go('search')),
          const SizedBox(height: 30),
          HomeActionCard(
              key: const Key('home-contact'),
              title: 'Contactar al centro de salud',
              onStart: () => go('contact')),
        ],
      );
  Widget signGrid() => ListView(
        key: PageStorageKey(page),
        primary: false,
        padding: const EdgeInsets.all(20),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: signs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 20,
              mainAxisExtent:
                  164 + (MediaQuery.textScalerOf(context).scale(13) - 13) * 7,
            ),
            itemBuilder: (context, i) => Material(
              key: ValueKey('alarm-option-$i'),
              color: coral,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  selectedSign = signs[i];
                  go(i == 0
                      ? 'bleeding'
                      : i == 1
                          ? 'headache'
                          : i == 2
                              ? 'fever'
                              : i == 3
                                  ? 'fluidLoss'
                                  : i == 4
                                      ? 'babyMovement'
                                      : i == 5
                                          ? 'swelling'
                                          : i == 6
                                              ? 'nausea'
                                              : 'fetalMovement');
                },
                child: Stack(children: [
                  Positioned.fill(
                    top: 12,
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Center(
                        child: Text(
                      signs[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_right,
                            color: coral, size: 27),
                      )),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            '¿Qué son los signos de alarma?',
            onPressed: () => go('signDetail'),
          ),
        ],
      );
  Widget signDetail() => ListView(
        key: PageStorageKey(page),
        primary: false,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/alarma.png',
                height: MediaQuery.sizeOf(context).width.clamp(0.0, 480.0) *
                    336 /
                    393,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: IconButton.filledTonal(
                  onPressed: back,
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 10),
            child: Text(
              '¿Qué son los signos de alarma?',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Son señales que identifican que tu salud o la de tu bebé puede estar en peligro.\nSi aparecen debes acudir inmediatamente al establecimiento de salud.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, height: 1.3),
            ),
          ),
          const Text(
            'No esperes, no te automediques.',
            textAlign: TextAlign.center,
            style: TextStyle(color: coral, fontSize: 17),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: OutlinedButton(
              onPressed: () => go('search'),
              child: const Text('Buscar atención'),
            ),
          ),
        ],
      );
  Widget video() => ListView(
        key: PageStorageKey(page),
        primary: false,
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Tenlo en cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          const Text(
            'Revisa la información de signos de alarma y ubica la sección de atención.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton('Ver información', onPressed: () => go('signDetail')),
          const SizedBox(height: 24),
          Material(
            color: coral,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {
                setState(() => videoOpen = !videoOpen);
              },
              child: SizedBox(
                height: 190,
                child: Center(
                  child: videoOpen
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'El archivo de video no está incluido en la maqueta.\n\nAquí se conectará el recurso audiovisual.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 56,
                        ),
                ),
              ),
            ),
          ),
        ],
      );
  Widget search() => SearchAttentionScreen(onContact: () => go('contact'));
  Widget contact() => const ContactScreen();
  Widget consultation() => ConsultationScreen(onContact: () => go('contact'));

  static const menuTitles = MenuScreen.labels;
  Widget menu() => const MenuScreen();
  Widget menuArticle(int index) => MenuScreen(initialArticle: index);
  Widget infoSection(IconData icon, String title, String description) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: coral, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: coral,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      );
  Widget panel(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE7E3E4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0B000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );
  void catalog() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .75,
            child: ListView(
              key: PageStorageKey(page),
              primary: false,
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Explorar la maqueta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 16),
                for (final entry in <String, String>{
                  'splash': 'Portada',
                  'onboarding': 'Bienvenida (3 pasos)',
                  'home': 'Inicio',
                  'signs': 'Signos de alarma',
                  'signDetail': 'Información de alarma',
                  'video': 'Recurso audiovisual',
                  'search': 'Buscar atención',
                  'contact': 'Contacto',
                  'consultation': 'Consulta (3 pasos)',
                  'consultResult': 'Resultado de ejemplo',
                  'menu': 'Menú',
                  'menuAbout': menuTitles[0],
                  'menuCredits': menuTitles[1],
                  'menuDisclaimer': menuTitles[2],
                }.entries)
                  ListTile(
                    title: Text(entry.value),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context);
                      go(entry.key);
                    },
                  ),
              ],
            ),
          ),
        ),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.label, {super.key, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        child: Text(label, textAlign: TextAlign.center),
      );
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    this.onTap,
  });
  final String title, subtitle;
  final IconData icon;
  final Color tone;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: tone,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 168,
              child: Stack(
                children: [
                  Positioned(
                    right: -25,
                    top: -45,
                    child: Icon(
                      icon,
                      size: 210,
                      color: Colors.white.withValues(alpha: .13),
                    ),
                  ),
                  Positioned(
                    top: 22,
                    left: 20,
                    child: Icon(icon, size: 34, color: Colors.white),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 22,
                    right: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Positioned(
                      right: 14,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: coral,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          'Ver',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}

// Ilustraciones locales de reemplazo. La ilustración de alarma sí proviene de Figma.
class Illustration extends StatelessWidget {
  const Illustration({super.key, required this.kind});
  final int kind;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 265,
              height: 265,
              decoration: BoxDecoration(
                color: [
                  const Color(0xFFE5DFFF),
                  const Color(0xFFD6F3EF),
                  const Color(0xFFFFE2DF),
                ][kind],
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              top: 38,
              right: 34,
              child: Icon(Icons.auto_awesome, color: coral, size: 32),
            ),
            Positioned(
              bottom: 45,
              left: 30,
              child: Icon(
                Icons.favorite,
                color: coral.withValues(alpha: .6),
                size: 28,
              ),
            ),
            Transform.rotate(
              angle: kind == 1 ? -.12 : .08,
              child: Container(
                width: 156,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 16,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    [
                      Icons.pregnant_woman,
                      Icons.monitor_heart_outlined,
                      Icons.map_outlined,
                    ][kind],
                    size: 118,
                    color: const Color(0xFF7760BB),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 34,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: coral,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  [Icons.favorite, Icons.check, Icons.location_on][kind],
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      );
}

class ChoiceTile extends StatelessWidget {
  const ChoiceTile(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
          leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? coral : Colors.grey),
          title: Text(label)));
}
