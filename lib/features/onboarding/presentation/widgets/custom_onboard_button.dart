import 'package:flutter/material.dart';
import 'package:unisphere/l10n/app_localizations.dart';

class CustomOnboardButton extends StatelessWidget {
  final String? nameButton;
  final VoidCallback? onTap;

  const CustomOnboardButton({
    this.nameButton,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = nameButton ?? AppLocalizations.of(context)?.onboarding_button_default ?? 'Button';

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
