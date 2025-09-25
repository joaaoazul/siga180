import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Treinos',
      subtitle: 'Criar e gerir planos de treino',
      icon: Icons.fitness_center_rounded,
    );
  }
}