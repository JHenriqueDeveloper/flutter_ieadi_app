import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/login/cubit/login_cubit.dart';
//import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
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
                    onPressed: () => Navigator
                    .of(context)
                    .pop(),
                    //.pushNamed(IntroScreen.routeName),
                  ),
                ),
              ),
              body: SafeArea(
                minimum: EdgeInsets.fromLTRB(
                  16, 32, 16, 64,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        maxLength: 50,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2,                
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          //hintText: 'E-mail',
                        ),
                        onChanged: (value) => context
                        .read<LoginCubit>()
                        .emailChanged(value),
                        validator: (value) => !value.contains('@')
                        ? 'Informe um e-mail válido.'
                        : null,
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autocorrect: false,                  
                        maxLength: 50,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          //hintText: 'Senha',
                        ),
                        style: Theme.of(context).textTheme.bodyText2, 
                        onChanged: (value) => context
                        .read<LoginCubit>()
                        .passwordChanged(value),
                        validator: (value) => value.length < 6
                        ? 'A senha precisa ter 6 caracteres ou mais.'
                        : null, 
                      ),

            SizedBox(height: 16),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                  onPressed: () => _submitForm(
                    context,
                    state.status == LoginStatus.submitting,
                  ),
                  child: Text('Continuar'),
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
            );
          },
        ),
      ),
    );
  }
}

/*
Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Informe um e-mail válido.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Senha',
                              ),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'A senha precisa ter 6 caracteres.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () => _submitForm(
                                context,
                                state.status == LoginStatus.submitting,
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              onPressed: () => {},
                              /*
                              Navigator.of(context)
                                  .pushNamed(SignupScreen.routeName),
                              */
                              child: const Text('Não tem uma conta? Signup'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
*/
