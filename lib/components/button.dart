import 'package:flutter/material.dart';


class DefaultButton extends StatelessWidget {
  //final Icon icon;
  final String labelText;
  final TextStyle textStyle;
  final void Function()? onPressed;
  final Color backgroundColor;
  const DefaultButton(
      {super.key,
      required this.labelText,
      required this.textStyle,
      required this.onPressed,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          maximumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Custom radius
          ),
        ),
        child: Text(
          labelText,
          style: textStyle,
        ));
  }
}

class OutlineButton extends StatelessWidget {
  //final Icon icon;
  final String labelText;
  final TextStyle textStyle;
  final void Function()? onPressed;
  final Color borderColor;
  const OutlineButton(
      {super.key,
      required this.labelText,
      required this.textStyle,
      required this.onPressed,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          side: BorderSide(
              color: borderColor, width: 1.4, style: BorderStyle.solid),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          maximumSize: Size(MediaQuery.of(context).size.width, 50),
        ),
        child: Text(
          labelText,
          style: textStyle,
        ));
  }
}
