import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/config/config.dart';


class IntroScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 64,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,

            children: [
              Text(
                'IEADI', 
                style: Theme.of(context).textTheme.headline2,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Text(
                  'Esteja sempre conectado com o reino.', 
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                  //context.read<CustomRouter>().setPage(2), 
                  child: Text('Entrar com e-mail'),
                ),
              ),

              Spacer(),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: TextButton(
                  onPressed: () => 
                  Navigator.of(context).pushReplacementNamed('/signup'),
                  //context.read<CustomRouter>().setPage(3), 
                  child: Text('Criar uma conta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textH6,
                children: [
                  TextSpan(
                    text: 'Quando você se registra, aceita nossas '
                  ),
                  TextSpan(
                    text: 'Condições gerais de utilização, ',
                    style: bold,
                  ),
                  TextSpan(
                    text: 'a nossa '
                  ),
                  TextSpan(
                    text: 'Política de Privacidade ',
                    style: bold,
                  ),
                  TextSpan(
                    text: 'e a nossa '
                  ),
                  TextSpan(
                    text: 'Carta de Cookies ',
                    style: bold,
                  ),
                ],
              ),
            ),

*/
