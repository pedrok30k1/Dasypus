import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import '../routes/app_routes.dart';
import '../utils/shared_prefs_helper.dart';

class RegisterScreenFilho extends StatefulWidget {
  const RegisterScreenFilho({super.key});

  @override
  State<RegisterScreenFilho> createState() => _RegisterScreenFilhoState();
}

class _RegisterScreenFilhoState extends State<RegisterScreenFilho> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _aboutController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  DateTime? _selectedDate;
  final ApiService _apiService = ApiService();

  final _dateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cpfController.dispose();
    _birthDateController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  // Formatar CPF
  void _formatCPF(String value) {
    if (value.isEmpty) return;
    
    // Remove caracteres não numéricos
    String numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limita a 11 dígitos
    if (numbers.length > 11) {
      numbers = numbers.substring(0, 11);
    }
    
    // Aplica a máscara
    String formatted = '';
    for (int i = 0; i < numbers.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '.';
      }
      if (i == 9) {
        formatted += '-';
      }
      formatted += numbers[i];
    }
    
    _cpfController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  // Selecionar data de nascimento
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 anos atrás
      firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 anos atrás
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 anos atrás
      locale: const Locale('pt', 'BR'),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        
      });
    }
  }

  // Validar confirmação de senha
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }

  void _handleRegister() async {
    final userId = await SharedPrefsHelper.getUserId();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Criar objeto Usuario
        final usuario = Usuario(
          nome: _nameController.text.trim(),
          email: _emailController.text.trim(),
          senha: _passwordController.text,
          cpf: _cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
          dataNasc: _selectedDate ?? DateTime.now(),
          sobre: _aboutController.text.trim().isEmpty ? null : _aboutController.text.trim(),
        );

        // Chamada da API
        final resultado = await _apiService.registerFilho(usuario, userId!);

        if (resultado['status'] == 'success') {
          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            // Mostrar SnackBar de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Conta criada com sucesso!\nVerifique seu email para ativar sua conta.',
                ),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );

            // Navegar para a tela de login
            AppRoutes.navigateToReplacement(context, AppRoutes.dashboard);
          }
        } else {
          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro no cadastro: ${resultado['message']}'),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro na conexão: $e'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo/Ícone
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_add_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        Text(
                          'Criar Conta',
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preencha os dados para se cadastrar do seu filho',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Campo de nome
                        CustomTextField(
                          controller: _nameController,
                          labelText: 'Nome Completo',
                          hintText: 'Digite seu nome completo',
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person_outlined,
                          validator: Validators.validateName,
                        ),
                        const SizedBox(height: 16),

                        // Campo de email
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Digite seu email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // Campo de CPF
                        CustomTextField(
                          controller: _cpfController,
                          labelText: 'CPF',
                          hintText: '000.000.000-00',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.badge_outlined,
                          validator: Validators.validateCPF,
                          onChanged: _formatCPF,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Campo de data de nascimento (agora editável)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _birthDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Data de Nascimento',
                                    hintText: 'DD/MM/AAAA',
                                    prefixIcon: Icon(Icons.cake_outlined, color: AppColors.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    _dateMaskFormatter,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: (value) => Validators.validateRequired(value, 'sua data de nascimento'),
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(FocusNode()); // Evita abrir teclado
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
                                      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
                                      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
                                      locale: const Locale('pt', 'BR'),
                                    );
                                    if (picked != null) {
                                      final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                      setState(() {
                                        _selectedDate = picked;
                                        _birthDateController.text = formatted;
                                      });
                                    }
                                  },
                                  readOnly: false, // Permite digitação manual
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_month, color: AppColors.primary),
                                tooltip: 'Selecionar data',
                                onPressed: _selectDate,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Campo de senha
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Senha',
                          hintText: 'Digite sua senha',
                          obscureText: !_isPasswordVisible,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 16),

                        // Campo de confirmar senha
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirmar Senha',
                          hintText: 'Confirme sua senha',
                          obscureText: !_isConfirmPasswordVisible,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 16),

                        // Campo de sobre (opcional)
                        CustomTextField(
                          controller: _aboutController,
                          labelText: 'Sobre (opcional)',
                          hintText: 'Conte um pouco sobre você',
                          maxLines: 3,
                          prefixIcon: Icons.info_outlined,
                        ),
                        const SizedBox(height: 24),

                        // Botão de cadastro
                        CustomButton(
                          text: 'Criar Conta',
                          onPressed: _handleRegister,
                          isLoading: _isLoading,
                          backgroundColor: AppColors.primary,
                          icon: Icons.person_add,
                        ),
                        const SizedBox(height: 24),

                        // Botão de voltar para login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Voltar para o Home',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                AppRoutes.navigateToReplacement(
                                  context,
                                  AppRoutes.dashboard,
                                );
                              },
                              child: Text(
                                'Voltar para o Home',
                                style: AppTextStyles.link.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}