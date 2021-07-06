import 'dart:io';

import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/image_helper.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';

import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';

class NavScreen extends StatefulWidget {
  NavScreen();

  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _snackBar({
    BuildContext context,
    String msg,
    bool isSuccess = true,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess
            ? LightStyle.paleta['Sucesso']
            : Theme.of(context).errorColor,
      ));

  File profileImage;
  void _selectImage(BuildContext context, auth) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Profile Image',
    );
    if (pickedFile != null) {
      //context.read<EditProfileCubit>().profileImageChanged(pickedFile);

       setState(() {
        profileImage = pickedFile;
      });

      auth.updateProfileImage(
        user: auth.user,
        image: pickedFile,
        onFail: (e) {
          print(e);
          _snackBar(
            context: context,
            msg: 'Falha ao atualizar a foto de perfil: $e',
            isSuccess: false,
          );
        },
        onSuccess: (uid) =>
            _snackBar(context: context, msg: 'Foto atualizada!'),
      );
    }
  }

  bool _showUserCard = false;
  void _handlerShowUserCard(bool isMemberCard) => isMemberCard
      ? setState(() => _showUserCard = !_showUserCard)
      : ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text:
              'Apenas membros batizados possuem cartão de membro. \nSe você é batizado, preencha seu perfil e solicite seu cartão.',
          paleta: 'Primaria',
        ));

  void _handlerShowAlerts(bool isAlerts) => isAlerts
      ? ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text:
              'Precisa implementar o sistema de avisos.',
          paleta: 'Primaria',
        ))
      : ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text:
              'Você não possui avisos.',
          paleta: 'Primaria',
        ));

  SnackBar snackBar({
    String text,
    String paleta,
  }) =>
      SnackBar(
        content: Text(text),
        backgroundColor: LightStyle.paleta[paleta],
      );

  void _handlerShowVerificado(bool isVerified) => isVerified
      ? ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text: 'Parabéns, você foi verificado!',
          paleta: 'Sucesso',
        ))
      : ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text: 'Verifique sua conta para ter acesso completo ao aplicativo.',
          paleta: 'Erro',
        ));

  bool _handlerCheckPendenciaPessoalUser(user) => user?.username == ''
      ? true
      : user?.genero == ''
          ? true
          : user?.cpf == ''
              ? true
              : user?.rg == ''
                  ? true
                  : user?.naturalidade == ''
                      ? true
                      : user?.nomePai == ''
                          ? true
                          : user?.nomeMae == ''
                              ? true
                              : user?.estadoCivil == ''
                                  ? true
                                  : user?.dataNascimento == ''
                                      ? true
                                      : user?.tipoSanguineo == ''
                                          ? true
                                          : user?.isPortadorNecessidade != null
                                              ? user?.tipoNecessidade == ''
                                                  ? true
                                                  : user?.descricaoNecessidade ==
                                                          ''
                                                      ? true
                                                      : false
                                              : false;

  bool _handlerCheckPendenciaEnderecoUser(user) => user?.cep == ''
      ? true
      : user?.uf == ''
          ? true
          : user?.cidade == ''
              ? true
              : user?.bairro == ''
                  ? true
                  : user?.logradouro == ''
                      ? true
                      : user?.complemento == ''
                          ? true
                          : user?.numero == ''
                              ? true
                              : false;

  bool _handlerCheckPendenciaCristaoUser(user) => user?.congregacao == ''
      ? true
      : user?.tipoMembro == ''
          ? true
          : user?.situacaoMembro == ''
              ? true
              : false;

  bool _handlerCheckPendenciaCurriculoUser(user) =>
      user?.isProcurandoOportunidades == true
          ? user?.profissao == ''
              ? true
              : user?.pretensaoSalarial == ''
                  ? true
                  : false
          : false;

  @override
  Widget build(BuildContext context) {
    void _handlerExit(
      bool isLoggedIn,
      AuthRepository auth,
    ) =>
        isLoggedIn
            ? auth.signOut(context)
            : Navigator.of(context).pushNamed('/intro');

    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<AuthRepository>(
        builder: (_, auth, __) {
          var user = auth.user;
          String userName =
              user?.username != '' ? firstName(user?.username) : '';

          String fullname = auth.user?.username ?? '';
          String matricula = user?.matricula != null
              ? auth.user.matricula != ''
                  ? auth.user.matricula
                  : '0000 0000 0000 0000'
              : '0000 0000 0000 0000';

          bool isLoggedIn = auth.isLoggedId;
          bool isMemberCard = auth.user?.isMemberCard ?? false;
          bool isAdmin = auth.user?.isAdmin ?? false;

          bool isPessoalPendencia = _handlerCheckPendenciaPessoalUser(user);
          bool isEnderecoPendencia = _handlerCheckPendenciaEnderecoUser(user);
          bool isCristaoPendencia = _handlerCheckPendenciaCristaoUser(user);
          bool isCurriculoPendencia = _handlerCheckPendenciaCurriculoUser(user);

          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 60.sp,
              centerTitle: false,
              title: Text(
                'Olá, ${userName ?? 'visitante'}!',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    FeatherIcons.award,
                    size: 14.sp,
                    color: LightStyle.paleta[
                        user?.isVerified == true ? 'Sucesso' : 'Shadow'],
                  ),
                  onPressed: () => _handlerShowVerificado(user.isVerified),
                ),
                IconButton(
                  icon: Icon(
                    FeatherIcons.creditCard,
                    size: 14.sp,
                    color:
                        LightStyle.paleta[isMemberCard ? 'Primaria' : 'Shadow'],
                  ),
                  onPressed: () => _handlerShowUserCard(isMemberCard),
                ),
                //TODO: DESENVOLVER O BUTTON AVISOS
                IconButton(
                  icon: Icon(
                    FeatherIcons.bell,
                    size: 14.sp,
                    color: LightStyle.paleta['Shadow'],
                  ),
                  onPressed: () => _handlerShowAlerts(false),
                ),
                isAdmin
                    ? IconButton(
                        icon: Icon(
                          FeatherIcons.sliders,
                          size: 14.sp,
                        ),
                        onPressed: () => context.read<CustomRouter>().setPage(8), //_handlerScreen(DashboardScreen()),
                        )
                    : Container(),
              ],
            ),
            body: DraggableScrollableSheet(
              initialChildSize: 1.0,
              builder: (_, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.sp),
                        topRight: Radius.circular(24.sp),
                      )),
                  //padding: const EdgeInsets.symmetric(vertical: 32),
                  child: ListView(
                    children: [
                      _showUserCard
                          ? AnimatedContainer(
                              height: _showUserCard ? 198.sp : 0,
                              duration: Duration(milliseconds: 200),
                              //color: LightStyle.paleta['Background'],

                              decoration: BoxDecoration(
                                color: LightStyle.paleta['Background'],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),

                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 32,
                                ),
                                child: UserCard(
                                  tipoCard: TiposCard.MEMBRO,
                                  username: fullname,
                                  matricula: matricula ?? '',
                                ), //UserCard(),
                              ),
                            )
                          : Container(),
                      ProfileImage(
                        radius: 120.sp,
                        profileImageUrl: user?.profileImageUrl != null
                            ? user?.profileImageUrl != ''
                                ? user?.profileImageUrl
                                : ''
                            : '',
                        profileImage: profileImage,
                        onTap: () => _selectImage(context, auth),
                      ),
                      Text(
                        user?.tipoMembro != null
                            ? user?.tipoMembro != ''
                                ? user?.tipoMembro
                                : 'Visitante'
                            : 'Visitante',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        user?.congregacao != null
                            ? user?.congregacao != ''
                                ? user?.congregacao
                                : 'Congregação não informada'
                            : 'Congregação não informada',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48),
                      ListItemMenu(
                        title: 'Serviços',
                        icon: FeatherIcons.server,
                        badge: false,
                        page: 1,
                      ),
                      ListItemMenu(
                        title: 'Informações Pessoais',
                        icon: FeatherIcons.user,
                        badge: isPessoalPendencia,
                        page: 2,
                      ),
                      ListItemMenu(
                        title: 'Endereço',
                        icon: FeatherIcons.mapPin,
                        badge: isEnderecoPendencia,
                        page: 3,
                      ),
                      ListItemMenu(
                        title: 'Contatos',
                        icon: FeatherIcons.phone,
                        badge: false,
                        page: 4,
                      ),
                      ListItemMenu(
                        title: 'Perfil Cristão',
                        icon: FeatherIcons.book,
                        badge: isCristaoPendencia,
                        page: 5,
                      ),
                      ListItemMenu(
                        title: 'Currículo',
                        icon: FeatherIcons.fileText,
                        badge: isCurriculoPendencia,
                        page: 6,
                      ),
                      /*
                      TODO: Fazer atualização de conta
                      ListItemMenu(
                        title: 'Conta',
                        icon: FeatherIcons.key,
                        badge: false,
                        page: 7,
                      ),
                      */
                      user?.isVerified != null
                          ? user?.isVerified == true
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 32,
                                    horizontal: 16,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 46,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar(
                                        text: 'Solicitação enviada.',
                                        paleta: 'Sucesso',
                                      )),
                                      child: Text('Verificar minha conta'),
                                    ),
                                  ),
                                )
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 32,
                                horizontal: 16,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar(
                                    text: 'Solicitação enviada.',
                                    paleta: 'Sucesso',
                                  )),
                                  child: Text('Verificar minha conta'),
                                ),
                              ),
                            ),
                      Container(
                        color: Colors.grey[400],
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 46,
                        child: TextButton(
                          child: Text(
                            isLoggedIn ? 'Sair' : 'Fazer Login',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          onPressed: () => _handlerExit(
                            isLoggedIn,
                            auth,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
