import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../style/style.dart';

class ButtonDashboard extends StatelessWidget {
  final Function onPressed;
  final String text;

  ButtonDashboard({
    @required this.text,
    @required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 80,
      child: ElevatedButton(
        child: Text(this.text),
        style: ElevatedButton.styleFrom(
          primary: LightStyle.paleta['Primaria'],
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: LightStyle.paleta['Branco'],
            letterSpacing: 0,
          ),
          shadowColor: LightStyle.paleta['Secundaria'],
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}