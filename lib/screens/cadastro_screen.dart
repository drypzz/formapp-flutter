import 'package:flutter/material.dart';
import 'package:formappflutter/main.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../validators/form_validators.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers, FocusNodes e Máscaras (Mantidos iguais)
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _dataNascimentoFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmaSenhaFocus = FocusNode();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _dataNascimentoMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _termosAceitos = false;
  bool _enviando = false;
  bool _verificandoEmail = false;
  String? _emailErrorAsync;

  final List<String> _emailsCadastrados = [
    'admin@teste.com',
    'contato@empresa.com',
    'gustavo@senac.br',
  ];

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        _verificarEmailAssincrono(_emailController.text);
      }
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();

    _nomeFocus.dispose();
    _emailFocus.dispose();
    _cpfFocus.dispose();
    _telefoneFocus.dispose();
    _dataNascimentoFocus.dispose();
    _senhaFocus.dispose();
    _confirmaSenhaFocus.dispose();
    super.dispose();
  }

  // Métodos de envio e dialog mantidos iguais
  Future<void> _verificarEmailAssincrono(String email) async {
    setState(() => _verificandoEmail = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _verificandoEmail = false;
      _emailErrorAsync = _emailsCadastrados.contains(email.toLowerCase())
          ? 'Este e-mail já está em uso'
          : null;
    });
  }

  void _enviarFormulario() async {
    if (!_termosAceitos) {
      _mostrarSnackBar('Você deve aceitar os termos de uso.', Colors.redAccent);
      return;
    }

    if (_formKey.currentState!.validate() && _emailErrorAsync == null) {
      setState(() => _enviando = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _enviando = false);
      _mostrarSnackBar('Conta criada com sucesso!', Colors.green);
      _mostrarDialogConfirmacao();
    } else {
      _mostrarSnackBar(
        'Por favor, verifique os campos destacados.',
        Colors.redAccent,
      );
    }
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cor,
        behavior:
            SnackBarBehavior.floating, // Floating SnackBar para UX moderno
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _mostrarDialogConfirmacao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirmação de Cadastro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verifique seus dados:'),
            const SizedBox(height: 16),
            _buildResumoItem(Icons.person, _nomeController.text),
            _buildResumoItem(Icons.email, _emailController.text),
            _buildResumoItem(Icons.badge, _cpfController.text),
            _buildResumoItem(Icons.phone, _telefoneController.text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Editar Dados'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState!.reset();
              _nomeController.clear();
              _emailController.clear();
              _cpfController.clear();
              _telefoneController.clear();
              _dataNascimentoController.clear();
              _senhaController.clear();
              _confirmaSenhaController.clear();
              setState(() => _termosAceitos = false);
            },
            child: const Text('Tudo Certo'),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Botão para alternar entre modo claro e escuro [cite: 112, 113]
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          // Centraliza na tela (ótimo para web/desktop)
          child: ConstrainedBox(
            // Limita a largura máxima
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho da Tela
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Color(0xFF6750A4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha seus dados para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // Card do Formulário
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomeController,
                              focusNode: _nomeFocus,
                              decoration: const InputDecoration(
                                labelText: 'Nome Completo',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _emailFocus.requestFocus(),
                              validator: FormValidators.validarNome,
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                hintText: 'exemplo@dominio.com',
                                prefixIcon: const Icon(Icons.email_outlined),
                                errorText: _emailErrorAsync,
                                suffixIcon: _verificandoEmail
                                    ? const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _cpfFocus.requestFocus(),
                              validator: FormValidators.validarEmail,
                            ),
                            const SizedBox(height: 20),

                            // CPF e Telefone na mesma linha em telas maiores, ou em coluna no celular
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth > 400) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _cpfController,
                                          focusNode: _cpfFocus,
                                          inputFormatters: [_cpfMask],
                                          decoration: const InputDecoration(
                                            labelText: 'CPF',
                                            prefixIcon: Icon(
                                              Icons.badge_outlined,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              _telefoneFocus.requestFocus(),
                                          validator: FormValidators.validarCpf,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _telefoneController,
                                          focusNode: _telefoneFocus,
                                          inputFormatters: [_telefoneMask],
                                          decoration: const InputDecoration(
                                            labelText: 'Telefone',
                                            prefixIcon: Icon(
                                              Icons.phone_outlined,
                                            ),
                                          ),
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              _dataNascimentoFocus
                                                  .requestFocus(),
                                          validator:
                                              FormValidators.validarTelefone,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      TextFormField(
                                        controller: _cpfController,
                                        focusNode: _cpfFocus,
                                        inputFormatters: [_cpfMask],
                                        decoration: const InputDecoration(
                                          labelText: 'CPF',
                                          prefixIcon: Icon(
                                            Icons.badge_outlined,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            _telefoneFocus.requestFocus(),
                                        validator: FormValidators.validarCpf,
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _telefoneController,
                                        focusNode: _telefoneFocus,
                                        inputFormatters: [_telefoneMask],
                                        decoration: const InputDecoration(
                                          labelText: 'Telefone',
                                          prefixIcon: Icon(
                                            Icons.phone_outlined,
                                          ),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            _dataNascimentoFocus.requestFocus(),
                                        validator:
                                            FormValidators.validarTelefone,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _dataNascimentoController,
                              focusNode: _dataNascimentoFocus,
                              inputFormatters: [_dataNascimentoMask],
                              decoration: const InputDecoration(
                                labelText: 'Data de Nascimento',
                                hintText: 'DD/MM/AAAA',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _senhaFocus.requestFocus(),
                              validator: FormValidators.validarDataNascimento,
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _senhaController,
                              focusNode: _senhaFocus,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _confirmaSenhaFocus.requestFocus(),
                              validator: FormValidators.validarSenha,
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _confirmaSenhaController,
                              focusNode: _confirmaSenhaFocus,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirmar Senha',
                                prefixIcon: Icon(Icons.lock_reset_outlined),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              validator: (value) =>
                                  FormValidators.validarConfirmacaoSenha(
                                    value,
                                    _senhaController.text,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Checkbox e Termos
                  Row(
                    children: [
                      Checkbox(
                        value: _termosAceitos,
                        onChanged: (value) =>
                            setState(() => _termosAceitos = value ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _termosAceitos = !_termosAceitos),
                          child: const Text(
                            'Eu aceito os termos de uso e políticas de privacidade.',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão de Cadastrar
                  SizedBox(
                    height: 56, // Touch target maior e confortável
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _enviando ? null : _enviarFormulario,
                      icon: _enviando
                          ? const SizedBox.shrink()
                          : const Icon(Icons.check_circle_outline),
                      label: _enviando
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Criar Conta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
