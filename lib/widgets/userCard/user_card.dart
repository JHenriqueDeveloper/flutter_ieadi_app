import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TiposCard {
  MEMBRO,
  MINISTERIO,
}

class UserCard extends StatelessWidget {
  final TiposCard tipoCard;
  final String username;
  final String matricula;

  UserCard({
    @required this.tipoCard,
    @required this.username,
    @required this.matricula,
  });

  final TextStyle textCardStyle = GoogleFonts.ibmPlexMono(
    fontSize: 16,
    color: Color(0xFFF6F6F6),
    letterSpacing: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).backgroundColor,
            ]),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(10.0, 10.0),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('logo02.png'),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  this.tipoCard == TiposCard.MEMBRO ? 'Membro' : 'Ministério',
                  style: textCardStyle,
                ),
                Spacer(),
                Image.asset(
                  'logo01.png',
                  width: 64,
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.username,
                      style: textCardStyle,
                    ),
                    Text(
                      this.matricula,
                      //'6B55668R-93',
                      style: textCardStyle,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
