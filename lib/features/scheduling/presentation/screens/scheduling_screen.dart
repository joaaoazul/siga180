// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class SchedulingScreen extends StatelessWidget {
  const SchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Agenda',
      subtitle: 'Gerir sessões e compromissos',
      icon: Icons.calendar_today_rounded,
    );
  }
}