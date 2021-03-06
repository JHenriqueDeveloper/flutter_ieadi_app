class Validator {
  static RegExp regex = RegExp(
      r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");

  static bool emailIsValid(String email) => regex.hasMatch(email);

  static bool passwordIsValid(String password) =>
      password.length >= 6 && password.length <= 12;

  static bool nameIsValid(String name) => name.length >= 3 && name.length <= 50;

  static String passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Preencha o campo Senha.';
    } else if (password.length < 6) {
      return 'A senha informada é muito curta. Utilize no mínimo 6 caracteres.';
    } else if (password.length > 15) {
      return 'A senha informada é muito longa. Utilize no máximo 15 caracteres.';
    }
    return null;
  }

  static String confirmPasswordValidator({
    String password,
    String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return 'Preencha o campo Confirme a Senha.';
    } else if (confirmPassword != password) {
      return 'As senhas precisam ser iguais.';
    }
    return null;
  }

  static String emailValidator(String email) {
    if (email.isEmpty) {
      return 'Preencha o campo E-mail.';
    } else if (!regex.hasMatch(email)) {
      return 'Informe um E-mail válido.';
    } else if (email.length > 50) {
      return 'O e-mail está muito longo, por favor utilize um e-mail com menos de 50 caracteres.';
    }
    return null;
  }

  static String nameValidator(String name) {
    if (name.isEmpty) {
      return 'Preencha o campo Nome Completo.';
    } else if (name.trim().split(' ').length <= 1) {
      return 'É preciso inserir o nome completo';
    } else if (name.length <= 3) {
      return 'O nome está muito curto.';
    } else if (name.length > 50) {
      return 'O nome está muito longo, por favor use abreviação se possível.';
    }
    return null;
  }

  static String cpfValidator(String cpf) {
    if (cpf.isEmpty) {
      return 'Preencha o campo para salvar.';
    } else if (cpf.length < 11 || cpf.length > 14) {
      return 'Informe um CPF válido.';
    }
    return null;
  }

  static String rgValidator(String rg) {
    if (rg.isEmpty) {
      return 'Preencha o campo para salvar.';
    }
    return null;
  }

  static String tituloValidator(String titulo) {
    if (titulo.isEmpty) {
      return 'Preencha o campo para salvar.';
    } else if (titulo.length < 12) {
      return 'Informe um Título de Eleitor válido.';
    }
    return null;
  }

  static String zonaValidator(String zona) {
    if (zona.isEmpty) {
      return 'Preencha o campo para salvar.';
    }
    return null;
  }

  static String descricaoValidator(String descricao) {
    if (descricao.isEmpty) {
      return 'Preencha o campo para salvar.';
    } 
    /*else if (descricao.length > 500) {
      return 'O texto está muito longo, por favor mantenha abaixo de 500 caracteres.';
    }
    */
    return null;
  }
}
