import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/auth/auth_repository.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserModel user = UserModel();
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
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/intro'),
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
                      'Criar uma conta',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    maxLength: 50,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(labelText: 'Nome Completo'),
                    validator: (userName) => Validator.nameValidator(userName),
                    onSaved: (username) => user.setUsername = username,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    maxLength: 50,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(labelText: 'E-mail'),
                    validator: (email) => Validator.emailValidator(email),
                    onSaved: (email) => user.setEmail = email,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autocorrect: false,
                    maxLength: 50,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(labelText: 'Senha'),
                    style: Theme.of(context).textTheme.bodyText2,
                    validator: (password) =>
                        Validator.passwordValidator(password),
                    onSaved: (password) => user.setPassword = password,
                    controller: passwordController,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autocorrect: false,
                    maxLength: 50,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(labelText: 'Confirme a Senha'),
                    style: Theme.of(context).textTheme.bodyText2,
                    validator: (confirmPassword) =>
                        Validator.confirmPasswordValidator(
                      password: passwordController.text,
                      confirmPassword: confirmPassword,
                    ),
                    //onSaved: (password) => user.setPassword = password,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: !authRepository.isLoading
                          ? () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                context.read<AuthRepository>().signUp(
                                      user: this.user,
                                      onFail: (e) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Falha ao efetuar o cadastro: $e'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/signup/cubit/signup_cubit.dart';
import 'package:flutter_instagram/widgets/error_dialog.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
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
                              'Instagram',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Username'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .usernameChanged(value),
                              validator: (value) => value.trim().isEmpty
                                  ? 'Please enter a valid username.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () => _submitForm(
                                context,
                                state.status == SignupStatus.submitting,
                              ),
                              child: const Text('Sign Up'),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Back to Signup'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}


*/
