import 'package:flutter/material.dart';

import 'package:unisphere/l10n/app_localizations.dart';


class CustomOnboardButton extends StatelessWidget {
  final String? nameButton;

  const CustomOnboardButton({this.nameButton, super.key});

  @override
  Widget build(BuildContext context) {
    final buttonText = nameButton ?? AppLocalizations.of(context)?.onboarding_name_button_default ?? 'Button';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
