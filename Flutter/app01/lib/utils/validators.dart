class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu email';
    }
    
    // Regex para validar email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, digite um email válido';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, digite $fieldName';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, digite seu nome';
    }
    
    if (value.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu telefone';
    }
    
    // Remove caracteres não numéricos
    final phoneDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (phoneDigits.length < 10) {
      return 'Por favor, digite um telefone válido';
    }
    
    return null;
  }

  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu CPF';
    }
    
    // Remove caracteres não numéricos
    final cpfDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cpfDigits.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    // Validação básica de CPF (verificação de dígitos repetidos)
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfDigits)) {
      return 'CPF inválido';
    }
    
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua data de nascimento';
    }
    
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - date.year;
      
      if (age < 0 || age > 120) {
        return 'Data de nascimento inválida';
      }
      
      return null;
    } catch (e) {
      return 'Formato de data inválido (YYYY-MM-DD)';
    }
  }
} 