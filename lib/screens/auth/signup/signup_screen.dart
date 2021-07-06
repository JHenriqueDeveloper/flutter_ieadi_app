import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/auth/auth_repository.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UserModel user = UserModel();
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
                padding: EdgeInsets.only(bottom: 32.sp ),//32),
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
                enabled: !authRepository.isLoading,
                validator: (userName) => Validator.nameValidator(userName),
                onSaved: (username) => user.setUsername = username,
              ),
              SizedBox(height: 6.sp), //8
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(labelText: 'E-mail'),
                enabled: !authRepository.isLoading,
                validator: (email) => Validator.emailValidator(email),
                onSaved: (email) => user.setEmail = email,
              ),
              SizedBox(height: 6.sp),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                decoration: InputDecoration(labelText: 'Senha'),
                style: Theme.of(context).textTheme.bodyText2,
                enabled: !authRepository.isLoading,
                validator: (password) => Validator.passwordValidator(password),
                onSaved: (password) => user.setPassword = password,
                controller: passwordController,
              ),
              SizedBox(height: 6.sp),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                decoration: InputDecoration(labelText: 'Confirme a Senha'),
                style: Theme.of(context).textTheme.bodyText2,
                enabled: !authRepository.isLoading,
                validator: (confirmPassword) =>
                    Validator.confirmPasswordValidator(
                  password: passwordController.text,
                  confirmPassword: confirmPassword,
                ),
                //onSaved: (password) => user.setPassword = password,
              ),
              SizedBox(height: 16.sp),
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
                                  onFail: (e) => ScaffoldMessenger.of(context)
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
                          height: 24.sp,
                          width: 24.sp,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}