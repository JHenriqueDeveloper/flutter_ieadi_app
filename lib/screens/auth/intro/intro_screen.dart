import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      appbar: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'AD Icoaraci',
            style: Theme.of(context).textTheme.headline2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.sp),
            child: Text(
              'Esteja sempre conectado com o reino.',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 46,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/login'),
              //context.read<CustomRouter>().setPage(2),
              child: Text('Entrar com e-mail'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 32.sp),
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
    );
  }
}
