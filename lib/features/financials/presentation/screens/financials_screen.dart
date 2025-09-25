// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../shared/widgets/screens/screen_placeholder.dart';

class FinancialsScreen extends StatelessWidget {
  const FinancialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Financeiro',
      subtitle: 'Gestão de pagamentos e relatórios',
      icon: Icons.attach_money_rounded,
    );
  }
}