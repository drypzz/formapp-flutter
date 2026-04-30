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
    if (value.length != 14) return 'CPF deve conter 11 dígitos';
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
