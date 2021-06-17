import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 64,
          leading: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FloatingActionButton(
                mini: true,
                child: Icon(FeatherIcons.chevronLeft),
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed('/intro'),
                ),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.fromLTRB(
            16,
            32,
            16,
            64,
          ),
          child: Form(
            key: _formKey,
            child: Consumer<AuthRepository>(
              builder: (_, authRepository, __) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
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
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      //hintText: 'E-mail',
                    ),
                    //onChanged: (value) => {},
                    validator: (email) => Validator.emailValidator(email),
                  ),

                  SizedBox(height: 8),

                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autocorrect: false,
                    maxLength: 50,
                    maxLines: 1,
                    enabled: !authRepository.isLoading,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      //hintText: 'Senha',
                    ),
                    style: Theme.of(context).textTheme.bodyText2,
                    //onChanged: (value) => {},
                    validator: (password) =>
                        Validator.passwordValidator(password),
                  ),

                  SizedBox(height: 16),

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
                                      onFail: (e) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Falha ao efetuar o login: $e'),
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
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                    ),
                  ),

                  Spacer(),
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
        ),
      ),
    );
  }
}