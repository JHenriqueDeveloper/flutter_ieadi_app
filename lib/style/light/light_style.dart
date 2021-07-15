import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LightStyle {
  static const Map<String, Color> paleta = {
    'Primaria': Color(0xFF4478EE),
    'Shadow': Color(0x304478EE),
    'PrimariaClaro': Color(0xFFCBD9F7),
    'PrimariaCinza': Color(0x30C4C4C4),
    'Background': Color(0xFF1A1C28),
    'BgSecundario': Color(0x48070C13),
    'BgCard': Color(0xFFE5E5E5),
    'Secundaria': Color(0xFF316CF3),
    'Branco': Color(0xFFF6F6F6),
    'Cinza': Color(0xFF536783),
    'CinzaClaro': Color(0x60D5D7DA),
    'CinzaMedio': Color(0x30D5D7DA),
    'Erro': Color(0xFFEE4444),
    'Sucesso': Color(0xFF0FC97B),
    'Alert': Color(0xFFEEBE44),
  };

  static TextStyle textOverlinePrimary = GoogleFonts.roboto(
    fontSize: 12.sp, //16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: paleta['Primaria'],
  );

  static ThemeData themeLight() => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: paleta['Primaria'],
        primaryColorDark: paleta['Primaria'],
        backgroundColor: paleta['Background'],
        scaffoldBackgroundColor: paleta['Background'],
        canvasColor: paleta['Branco'],
        shadowColor: paleta['shadow'],
        errorColor: paleta['Erro'],
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          backgroundColor: paleta['Background'],
          elevation: 0,
          iconTheme: IconThemeData(
            color: paleta['Primaria'],
          ),
        ),
        buttonTheme: ButtonThemeData(
            //disabledColor: paleta['CinzaClaro'],
            ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: paleta['Primaria'],
        ),
        iconTheme: IconThemeData(
          size: 14.sp,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: paleta['Primaria'],
          onPrimary: paleta['Branco'],
          onSurface: paleta['Shadow'],
          textStyle: GoogleFonts.roboto(
            fontSize: 12.sp, //14,
            fontWeight: FontWeight.bold,
            color: paleta['Branco'],
            letterSpacing: 0,
          ),
          shadowColor: paleta['Secundaria'],
        )),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: paleta['Cinza'],
          textStyle: GoogleFonts.roboto(
            fontSize: 12.sp, //16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        )),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
            fontSize: 48.sp, //64.0,
            fontWeight: FontWeight.bold,
            color: paleta['Primaria'],
          ),
          headline2: GoogleFonts.roboto(
            fontSize: 24.sp, //32,
            fontWeight: FontWeight.bold,
            color: paleta['Primaria'],
          ),
          headline3: GoogleFonts.roboto(
            fontSize: 36.sp, //48,
            fontWeight: FontWeight.bold,
            color: paleta['Branco'],
            height: 1.5,
          ),
          headline4: GoogleFonts.roboto(
            fontSize: 24.sp, //36,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: paleta['Branco'],
          ),
          headline5: GoogleFonts.roboto(
            fontSize: 18.sp, //30
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: paleta['Branco'],
          ),
          headline6: GoogleFonts.roboto(
            fontSize: 18.sp, //30,
            height: 1.5,
            color: paleta['Background'],
          ),
          subtitle1: TextStyle(
            color: paleta['Branco'],
            fontSize: 14.sp, //20.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: TextStyle(
            color: paleta['Branco'],
            fontSize: 12.sp, //16.0,
            letterSpacing: 0,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
          overline: GoogleFonts.roboto(
            //texto button vermelho
            fontSize: 12.sp, //16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: paleta['Erro'],
          ),
          bodyText1: GoogleFonts.roboto(
            fontSize: 12.sp, //16,
            height: 1.5,
            letterSpacing: 0,
            color: paleta['Cinza'],
          ),
          bodyText2: GoogleFonts.roboto(
            fontSize: 12.sp, //16,
            color: paleta['Branco'],
            letterSpacing: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: paleta['BgSecundario'],
            counterStyle: TextStyle(color: Colors.transparent),
            labelStyle: GoogleFonts.roboto(
              fontSize: 12.sp, //16,
              color: paleta['Cinza'],
              letterSpacing: 0,
            ),
            hintStyle: GoogleFonts.roboto(
              fontSize: 12.sp, //16,
              color: paleta['Branco'],
              letterSpacing: 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            )),
      );
}
