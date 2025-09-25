// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Configurações',
      subtitle: 'Personalizar a aplicação',
      icon: Icons.settings_rounded,
    );
  }
}