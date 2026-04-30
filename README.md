# 📝 Form App - Flutter

## ✨ Funcionalidades Implementadas

O aplicativo conta com um formulário de cadastro robusto, responsivo e adaptável aos temas claro e escuro, contendo:

* **Gerenciamento de Estado de Formulário:** Uso de `Form` e `GlobalKey<FormState>` para controle unificado.
* **8+ Campos Obrigatórios:** Nome completo, E-mail, CPF, Telefone, Data de Nascimento, Senha, Confirmação de Senha e Termos de Uso.
* **Navegação Inteligente (FocusNode):** O foco muda automaticamente para o próximo campo ao submeter o teclado (`textInputAction: TextInputAction.next` e `requestFocus()`).
* **Máscaras de Entrada:** Utilização do package `mask_text_input_formatter` para formatar CPF, Telefone e Data de Nascimento em tempo real.
* **Validações Síncronas (Reais):** 
  * Verificação matemática dos dígitos do CPF.
  * Verificação real de Data de Nascimento (controle de anos bissextos, limite de idade e bloqueio de datas futuras).
  * Formato de e-mail, senhas coincidentes e limites de caracteres.
* **Validações Assíncronas (Bônus):** Simulação de requisição à API com `Future.delayed` para os campos de E-mail, CPF e Data de Nascimento, exibindo um `CircularProgressIndicator` dentro do campo (`suffixIcon`) enquanto valida.
* **UX Avançada e Anti-Bugs:** 
  * O erro de um campo some automaticamente assim que o usuário começa a corrigir o dado (`onChanged`).
  * O botão "Criar Conta" é desativado (`disabled`) se alguma validação assíncrona estiver em andamento na tela.
* **Feedback Visual (SnackBar e Dialog):** 
  * `SnackBar` flutuante para mensagens de sucesso (verde) e erro (vermelho).
  * `AlertDialog` apresentando um resumo dos dados para o usuário revisar antes de confirmar o envio final para o "backend".
* **Design Responsivo e Temas:** Layout adaptável para telas maiores (com `ConstrainedBox` e `LayoutBuilder`) e suporte nativo a `ThemeMode` (Claro e Escuro).

## 🛠️ Tecnologias e Pacotes Utilizados

- **Flutter / Dart**
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) (Para formatação de inputs)

## 🚀 Como Executar o Projeto

1. Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
2. Clone este repositório:
```bash
   git clone git@github.com:drypzz/formapp-flutter.git
```
3. Navegue até a pasta do projeto:
```bash
   cd formapp-flutter
```
4. Baixe as dependencias:
```bash
   flutter pub get
```
5. Execute o projeto:
```bash
   flutter run
```

---

> drypzz © 2026