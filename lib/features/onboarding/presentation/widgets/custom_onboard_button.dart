import 'package:flutter/material.dart';

import 'package:unisphere/l10n/app_localizations.dart';


class CustomOnboardButton extends StatelessWidget {
  final String? nameButton;
  final bool? smallPadding;

  const CustomOnboardButton({this.nameButton, this.smallPadding, super.key});

  @override
  Widget build(BuildContext context) {
    final buttonText =
        nameButton ??
        AppLocalizations.of(context)?.onboarding_button_default ??
        'Button';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: smallPadding == true ? 10.0 : 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
