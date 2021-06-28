import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String firstName(String fullName) => fullName?.substring(0, fullName.indexOf(' ')) ?? '';

formataData({
  @required DateTime data,
  String mask = 'dd MMM, yyyy',
  
}){
  return DateFormat(
    mask,
    'pt_BR'
  ).format(data);
}


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
