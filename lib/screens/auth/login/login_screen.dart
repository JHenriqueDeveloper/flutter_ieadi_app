import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      appbar: true,
      navigateTo: '/intro',
      child: Form(
        key: _formKey,
        child: Consumer<AuthRepository>(
          builder: (_, authRepository, __) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32.sp),
                child: Text(
                  'Efetuar login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                enabled: !authRepository.isLoading,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (email) => Validator.emailValidator(email),
              ),

              SizedBox(height: 6.sp),

              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                enabled: !authRepository.isLoading,
                textAlign: TextAlign.left,
                decoration: InputDecoration(labelText: 'Senha'),
                style: Theme.of(context).textTheme.bodyText2,
                validator: (password) => Validator.passwordValidator(password),
              ),

              SizedBox(height: 16.sp),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: ElevatedButton(
                  onPressed: !authRepository.isLoading
                      ? () {
                          if (_formKey.currentState.validate()) {
                            //_formKey.currentState.save();
                            context.read<AuthRepository>().signIn(
                                  user: UserModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                  onFail: (e) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Falha ao efetuar o login: $e'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ),
                                  ),
                                  onSuccess: (uid) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/base');
                                  },
                                );
                          }
                          //context.read<CustomRouter>().setPage(4);
                        }
                      : () {},
                  child: !authRepository.isLoading
                      ? Text('Continuar')
                      : SizedBox(
                          height: 24.sp,
                          width: 24.sp,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                ),
              ),

              //Spacer(),
              //Falta implementar a tela
              /*
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: TextButton(
                    onPressed: () => {},/*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen()
                      ),
                    )*/
                    child: Text('Recuperar a conta'),
                ),
              ),
          */
            ],
          ),
        ),
      ),
    );
  }
}