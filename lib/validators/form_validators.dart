class FormValidators {
  static String? validarNome(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value.length < 3) return 'O nome deve ter no mínimo 3 caracteres';
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (!value.contains('@') || !value.contains('.')) return 'Email inválido';
    return null;
  }

  static String? validarCpf(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';

    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length != 11) return 'CPF incompleto';

    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return 'CPF inválido';

    List<int> digits = numbers.split('').map(int.parse).toList();

    int calc1 = 0;
    for (int i = 0; i < 9; i++) {
      calc1 += digits[i] * (10 - i);
    }
    calc1 = (calc1 * 10) % 11;
    if (calc1 == 10) calc1 = 0;
    if (calc1 != digits[9]) return 'CPF inválido';

    int calc2 = 0;
    for (int i = 0; i < 10; i++) {
      calc2 += digits[i] * (11 - i);
    }
    calc2 = (calc2 * 10) % 11;
    if (calc2 == 10) calc2 = 0;
    if (calc2 != digits[10]) return 'CPF inválido';

    return null;
  }

  static String? validarTelefone(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value.length != 15) return 'Telefone inválido';
    return null;
  }

  static String? validarDataNascimento(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value.length != 10) return 'Formato DD/MM/AAAA inválido';

    try {
      int dia = int.parse(value.substring(0, 2));
      int mes = int.parse(value.substring(3, 5));
      int ano = int.parse(value.substring(6, 10));

      if (mes < 1 || mes > 12) return 'Mês inválido';

      int anoAtual = DateTime.now().year;

      if (ano < (anoAtual - 100)) {
        return 'Data muito antiga (idade máxima 100 anos)';
      }

      if (ano > anoAtual) {
        return 'Ano inválido';
      }

      int diasNoMes = 31;
      if (mes == 4 || mes == 6 || mes == 9 || mes == 11) {
        diasNoMes = 30;
      } else if (mes == 2) {
        bool isBissexto = (ano % 4 == 0 && ano % 100 != 0) || (ano % 400 == 0);
        diasNoMes = isBissexto ? 29 : 28;
      }

      if (dia < 1 || dia > diasNoMes) return 'Dia inválido para este mês';

      DateTime dataInformada = DateTime(ano, mes, dia);
      if (dataInformada.isAfter(DateTime.now())) {
        return 'Data de nascimento não pode ser no futuro';
      }
    } catch (e) {
      return 'Data inválida';
    }

    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
    return null;
  }

  static String? validarConfirmacaoSenha(String? value, String senhaOriginal) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value != senhaOriginal) return 'As senhas não coincidem';
    return null;
  }
}
