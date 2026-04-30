import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../main.dart';
import '../validators/form_validators.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _cpfFieldKey = GlobalKey<FormFieldState>();
  final _dataNascimentoFieldKey = GlobalKey<FormFieldState>();

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

  bool _verificandoCpf = false;
  String? _cpfErrorAsync;

  bool _verificandoData = false;
  String? _dataErrorAsync;

  final List<String> _emailsCadastrados = [
    'admin@teste.com',
    'contato@empresa.com',
    'gustavo@senac.br',
  ];

  bool get _isProcessando =>
      _enviando || _verificandoEmail || _verificandoCpf || _verificandoData;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        bool formatoValido = _emailFieldKey.currentState?.validate() ?? false;
        if (formatoValido && _emailController.text.isNotEmpty) {
          _verificarEmailAssincrono(_emailController.text);
        }
      }
    });

    _cpfFocus.addListener(() {
      if (!_cpfFocus.hasFocus) {
        if (_cpfController.text.isNotEmpty) {
          _verificarCpfAssincrono(_cpfController.text);
        } else {
          _cpfFieldKey.currentState?.validate();
        }
      }
    });

    _dataNascimentoFocus.addListener(() {
      if (!_dataNascimentoFocus.hasFocus) {
        if (_dataNascimentoController.text.isNotEmpty) {
          _verificarDataAssincrona(_dataNascimentoController.text);
        } else {
          _dataNascimentoFieldKey.currentState?.validate();
        }
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

  Future<void> _verificarEmailAssincrono(String email) async {
    setState(() {
      _verificandoEmail = true;
      _emailErrorAsync = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _verificandoEmail = false;
      _emailErrorAsync = _emailsCadastrados.contains(email.toLowerCase())
          ? 'Este e-mail já está em uso'
          : null;
    });
    _emailFieldKey.currentState?.validate();
  }

  Future<void> _verificarCpfAssincrono(String cpf) async {
    setState(() {
      _verificandoCpf = true;
      _cpfErrorAsync = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _verificandoCpf = false;
      _cpfErrorAsync = FormValidators.validarCpf(cpf);
    });
    _cpfFieldKey.currentState?.validate();
  }

  Future<void> _verificarDataAssincrona(String data) async {
    setState(() {
      _verificandoData = true;
      _dataErrorAsync = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _verificandoData = false;
      _dataErrorAsync = FormValidators.validarDataNascimento(data);
    });
    _dataNascimentoFieldKey.currentState?.validate();
  }

  Future<void> _enviarFormulario() async {
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(milliseconds: 100));

    if (_verificandoEmail || _verificandoCpf || _verificandoData) {
      setState(() => _enviando = true);

      while (_verificandoEmail || _verificandoCpf || _verificandoData) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() => _enviando = false);
    }

    if (!_termosAceitos) {
      _mostrarSnackBar('Você deve aceitar os termos de uso.', Colors.redAccent);
      return;
    }

    bool formValido = _formKey.currentState!.validate();

    if (formValido &&
        _emailErrorAsync == null &&
        _cpfErrorAsync == null &&
        _dataErrorAsync == null) {
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _mostrarDialogConfirmacao() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirmação de Cadastro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verifique seus dados antes de enviar:'),
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
              _processarCadastro();
            },
            child: const Text('Confirmar e Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> _processarCadastro() async {
    setState(() => _enviando = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _enviando = false);

    _mostrarSnackBar('Conta criada com sucesso!', Colors.green);

    _formKey.currentState!.reset();
    _nomeController.clear();
    _emailController.clear();
    _cpfController.clear();
    _telefoneController.clear();
    _dataNascimentoController.clear();
    _senhaController.clear();
    _confirmaSenhaController.clear();

    setState(() {
      _termosAceitos = false;
      _emailErrorAsync = null;
      _cpfErrorAsync = null;
      _dataErrorAsync = null;
    });
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                              key: _emailFieldKey,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                hintText: 'exemplo@dominio.com',
                                prefixIcon: const Icon(Icons.email_outlined),
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
                              onChanged: (value) {
                                if (_emailErrorAsync != null) {
                                  setState(() => _emailErrorAsync = null);
                                  _emailFieldKey.currentState?.validate();
                                }
                              },
                              validator: (val) {
                                if (_emailErrorAsync != null) {
                                  return _emailErrorAsync;
                                }
                                return FormValidators.validarEmail(val);
                              },
                            ),
                            const SizedBox(height: 20),

                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth > 400) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          key: _cpfFieldKey,
                                          controller: _cpfController,
                                          focusNode: _cpfFocus,
                                          inputFormatters: [_cpfMask],
                                          decoration: InputDecoration(
                                            labelText: 'CPF',
                                            prefixIcon: const Icon(
                                              Icons.badge_outlined,
                                            ),
                                            suffixIcon: _verificandoCpf
                                                ? const Padding(
                                                    padding: EdgeInsets.all(
                                                      12.0,
                                                    ),
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              _telefoneFocus.requestFocus(),
                                          onChanged: (value) {
                                            if (_cpfErrorAsync != null) {
                                              setState(
                                                () => _cpfErrorAsync = null,
                                              );
                                              _cpfFieldKey.currentState
                                                  ?.validate();
                                            }
                                          },
                                          validator: (val) {
                                            if (_cpfErrorAsync != null) {
                                              return _cpfErrorAsync;
                                            }
                                            return FormValidators.validarCpf(
                                              val,
                                            );
                                          },
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
                                        key: _cpfFieldKey,
                                        controller: _cpfController,
                                        focusNode: _cpfFocus,
                                        inputFormatters: [_cpfMask],
                                        decoration: InputDecoration(
                                          labelText: 'CPF',
                                          prefixIcon: const Icon(
                                            Icons.badge_outlined,
                                          ),
                                          suffixIcon: _verificandoCpf
                                              ? const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            _telefoneFocus.requestFocus(),
                                        onChanged: (value) {
                                          if (_cpfErrorAsync != null) {
                                            setState(
                                              () => _cpfErrorAsync = null,
                                            );
                                            _cpfFieldKey.currentState
                                                ?.validate();
                                          }
                                        },
                                        validator: (val) {
                                          if (_cpfErrorAsync != null) {
                                            return _cpfErrorAsync;
                                          }
                                          return FormValidators.validarCpf(val);
                                        },
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
                              key: _dataNascimentoFieldKey,
                              controller: _dataNascimentoController,
                              focusNode: _dataNascimentoFocus,
                              inputFormatters: [_dataNascimentoMask],
                              decoration: InputDecoration(
                                labelText: 'Data de Nascimento',
                                hintText: 'DD/MM/AAAA',
                                prefixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                                suffixIcon: _verificandoData
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
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _senhaFocus.requestFocus(),
                              onChanged: (value) {
                                if (_dataErrorAsync != null) {
                                  setState(() => _dataErrorAsync = null);
                                  _dataNascimentoFieldKey.currentState
                                      ?.validate();
                                }
                              },
                              validator: (val) {
                                if (_dataErrorAsync != null) {
                                  return _dataErrorAsync;
                                }
                                return FormValidators.validarDataNascimento(
                                  val,
                                );
                              },
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

                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isProcessando ? null : _enviarFormulario,
                      icon: _isProcessando
                          ? const SizedBox.shrink()
                          : const Icon(Icons.check_circle_outline),
                      label: _isProcessando
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
