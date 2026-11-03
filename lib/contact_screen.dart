import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  static const coral = Color(0xFFFF5F73);

  Widget section(IconData icon, String heading, Widget content) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: coral, size: 21),
          const SizedBox(width: 24),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(heading,
                    style: const TextStyle(
                        color: coral,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 22),
                content,
              ])),
        ]),
      );
  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('contact-information'),
        primary: false,
        padding: const EdgeInsets.fromLTRB(16, 36, 20, 28),
        children: [
          section(
              Icons.call,
              'Telefono',
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (var i = 0; i < 4; i++)
                  const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Text('Dr. Lorem Ipsum is simply dummy',
                          style: TextStyle(fontSize: 13, color: Colors.black))),
              ])),
          section(
              Icons.location_on,
              'ubicación',
              const SizedBox(
                  width: double.infinity,
                  child: Text('Mariano ignacio Prado S/N Chilca,\nChilca, Perú',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Colors.black, height: 1.4)))),
          section(
              Icons.more_time,
              'Horario de atención',
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (var i = 0; i < 2; i++)
                  const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Text('Lunes a viernes: 08:00 am - 05:30 pm',
                          style: TextStyle(fontSize: 13, color: Colors.black))),
              ])),
          const SizedBox(height: 44),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('“TE RECOMENDAMOS EL CENTRO DE SALUD DE CHILCA”',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: coral,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 32),
        ],
      );
}
