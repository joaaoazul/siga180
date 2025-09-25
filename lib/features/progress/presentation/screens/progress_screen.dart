// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Progresso',
      subtitle: 'Acompanhar evolução dos atletas',
      icon: Icons.bar_chart_rounded,
    );
  }
}