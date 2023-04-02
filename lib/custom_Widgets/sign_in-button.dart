import 'package:flutter/widgets.dart';

import 'common_Widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
      {required String text,
      required Color? color,
      required Color textColor,
      double height = 50,
      required VoidCallback onPressed})
      : super(
            child:
                Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
            color: color,
            onPressed: onPressed,
            height: height,
            borderRadius: 4.0);
}
