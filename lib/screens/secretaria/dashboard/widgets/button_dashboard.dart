import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../style/style.dart';

class ButtonDashboard extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;

  ButtonDashboard({
    @required this.text,
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(horizontal: 3.sp),
        child: TextButton(
          onPressed: this.onPressed,
          child: Column(
            children: [
              Container(
                child: Icon(
                  icon, 
                  color: LightStyle.paleta['Cinza'],
                ),
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: LightStyle.paleta['Shadow'],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 8.sp),
              Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.normal,
                  color: LightStyle.paleta['Cinza'],
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        )

        /*
      SizedBox(
          width: 120.sp,
          height: 46,
          child:
          */

        /*
        ElevatedButton(
          child: Text(this.text),
          style: ElevatedButton.styleFrom(
            primary: LightStyle.paleta['Primaria'],
            textStyle: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: LightStyle.paleta['Branco'],
              letterSpacing: 0,
            ),
            shadowColor: LightStyle.paleta['Secundaria'],
          ),
          onPressed: this.onPressed,
        ),
        */

        );
  }
}
