import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {

  static const Map<String, Color> paleta = {
    'Primaria': Color(0xFF4478EE),
    'Shadow': Color(0x304478EE),
    'PrimariaClaro': Color(0xFFCBD9F7),
    'Background': Color(0xFF1A1C28),
    'BgSecundario': Color(0x48070C13),
    'BgCard': Color(0xFFE5E5E5),
    'Secundaria': Color(0xFF316CF3),
    'Branco': Color(0xFFF6F6F6),
    'Cinza': Color(0xFF536783),
    'CinzaClaro': Color(0x60D5D7DA),
    'CinzaMedio': Color(0x30D5D7DA),
    'Erro': Color(0xFFEE4444),
    'Sucesso': Color(0xFF44EEA7),
    'Alert': Color(0xFFEEBE44),
  };


  static ThemeData themeLight() => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: paleta['Primaria'],
        primaryColorDark: paleta['Primaria'],
        backgroundColor: paleta['Background'],
        scaffoldBackgroundColor: paleta['Background'],
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          backgroundColor: paleta['Background'],
          elevation: 0,
          iconTheme: IconThemeData(
            color: paleta['Primaria'],
          ),
        ),
        buttonTheme: ButtonThemeData(

        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: paleta['Primaria'],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: paleta['Primaria'],
            textStyle: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: paleta['Branco'],
              letterSpacing: 0,
            ),
            shadowColor: paleta['Secundaria'],
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: paleta['Cinza'],
            textStyle: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          )
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
            fontSize: 64.0,
            fontWeight: FontWeight.bold,
            color: paleta['Primaria'],
          ),
          headline2: GoogleFonts.roboto(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: paleta['Primaria'],
          ),
          headline3: GoogleFonts.roboto(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: paleta['Branco'],
            height: 1.5,
          ),
          headline4: GoogleFonts.roboto(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: paleta['Branco'],
          ),
          headline5: GoogleFonts.roboto(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: paleta['Branco'],
          ),
          bodyText2: GoogleFonts.roboto(
            fontSize: 16,
            color: paleta['Branco'],
            letterSpacing: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: paleta['BgSecundario'],
          counterStyle: TextStyle(color: Colors.transparent),
          labelStyle: GoogleFonts.roboto(
            fontSize: 16,
            color: paleta['Cinza'],
            letterSpacing: 0,
          ),
          hintStyle: GoogleFonts.roboto(
            fontSize: 16,
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

/*
AppBar(
        brightness: Brightness.dark,
        backgroundColor: paleta['Background'],
        elevation: 0,
        leadingWidth: 64,
        leading: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
          ),
*/