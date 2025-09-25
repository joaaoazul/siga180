// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Nutrição',
      subtitle: 'Planos alimentares e acompanhamento',
      icon: Icons.restaurant_menu_rounded,
    );
  }
}