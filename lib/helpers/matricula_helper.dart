import 'package:meta/meta.dart';
import 'package:nanoid/nanoid.dart';

class MatriculaHelper {
  static const String _alfabeto =
      '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  static const int _stringLength = 4;

  final String userCpf;
  final String userId;
  
  String matricula;

  MatriculaHelper({
    @required this.userCpf,
    @required this.userId,
  }) {
    String digito = customAlphabet(
      DateTime.now().millisecondsSinceEpoch.toString(),
      _stringLength,
    );

    String prefixo = customAlphabet(
      _alfabeto,
      _stringLength,
    );

    String cpf = customAlphabet(userCpf, _stringLength);

    String id = customAlphabet(userId, _stringLength);

    matricula = gerarMatricula('$prefixo $cpf $id $digito');
  }

  String gerarMatricula(String mat) => mat;

}
