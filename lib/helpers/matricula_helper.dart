import 'package:meta/meta.dart';
import 'package:nanoid/nanoid.dart';

class MatriculaHelper {
  //qwertyuiopasdfghjklzxcvbnm
  static const String _alfabeto =
      '0123456789QWERTYUIOPASDFGHJKLZXCVBNM';
  static const int _stringLength = 4;

  //final String userCpf;
  final String userId;

  String _matricula;

  MatriculaHelper({
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

    String cpf = customAlphabet(userId, _stringLength).toUpperCase();

    String id = customAlphabet(userId, _stringLength).toUpperCase();

    _matricula = _gerarMatricula('$prefixo $cpf $id $digito');
  }

  get getMatricula => _matricula;

  String _gerarMatricula(String mat) => mat;
}
