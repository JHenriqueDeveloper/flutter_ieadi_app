import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';

String firstName(String fullName) =>
    fullName?.substring(0, fullName.indexOf(' ')) ?? '';

String formataNome(String fullName) {
  fullName.trim();
  List<String> nomes = fullName.split(' ');
  String nome = '';

  List<String> aux = [];
  for (String nome in nomes) {
    if (nome.length > 3) {
      aux.add(nome);
    }
  }
  nomes = [];
  if (aux.length >= 3) {
    for (var i = 0; i < aux.length; i++) {
      if (i != 0 && i != aux.length - 1) {
        nomes.add(aux[i].substring(0, 1));
      } else {
        nomes.add(aux[i]);
      }
    }
  } else {
    nomes = aux;
  }

  for (var i = 0; i < nomes.length; i++) {
    nome = '$nome ${nomes[i]}';
  }

  return nome;
}

formataData({
  @required DateTime data,
  String mask = 'dd MMM, yyyy',
}) {
  return DateFormat(mask, 'pt_BR').format(data);
}

String geraEmail(String nome) => '$nome@ieadi.com.br';

const String alfabeto =
    '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
String gerarPassword() => customAlphabet(alfabeto, 8);

const List<String> uf_list = [
  'AC',
  'AL',
  'AP',
  'AM',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MT',
  'MS',
  'MG',
  'PA',
  'PB',
  'PR',
  'PE',
  'PI',
  'RJ',
  'RN',
  'RS',
  'RO',
  'RR',
  'SC',
  'SP',
  'SE',
  'TO',
];

const List<String> generos_list = [
  'Masculino',
  'Feminino',
];

const List<String> civil_list = [
  'Solteiro',
  'Casado',
  'Divorciado',
  'Emancebado',
  'Viúvo',
];

const List<String> sangue_list = [
  'A+',
  'A-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

const List<String> necessidades_list = [
  'Visual',
  'Auditiva',
  'Mental',
  'Fisica',
  'Outra',
];

const List<String> tipos_membros = [
  'Membro',
  'Obreiro',
  'Pastor',
  'Criança',
  'Congregado',
  'Amigo do Evangelho',
];

const List<String> situacao_membros = [
  'Comunhão',
  'Afastado',
  'Disciplinado',
  'Mudou de Campo',
  'Mudou de Ministério',
  'Falecido',
];

const List<String> procedencias = [
  'Batizado no Campo',
  'Carta de Mudança de outro Ministério',
  'Carta de Mudança do mesmo Ministério',
  'Aclamação',
];
