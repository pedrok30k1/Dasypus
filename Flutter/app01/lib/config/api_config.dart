class ApiConfig {
  // ===========================
  // CONFIGURAÇÃO DA API
  // ===========================
  
  // Altere esta URL conforme seu ambiente:
  static const String baseUrl = 'http://10.0.2.2/TCC/api/';
  
  // URLs para diferentes ambientes:
  static const String localhostUrl = 'http://10.0.2.2/TCC/api/';
  static const String androidEmulatorUrl = 'http://10.0.2.2/TCC/api/';
  static const String productionUrl = 'https://seudominio.com/api/';
  
  // ===========================
  // INSTRUÇÕES DE CONFIGURAÇÃO
  // ===========================
  // Para alterar a URL da API, modifique a linha abaixo:
  // - Para web: localhostUrl
  // - Para Android emulador: androidEmulatorUrl  
  // - Para produção: productionUrl
  // - Para IP específico: 'http://192.168.1.100/TCC/api/'
  
  static String get currentUrl => localhostUrl;
  
  // ===========================
  // CONFIGURAÇÕES DE DEBUG
  // ===========================
  static const bool enableDebugLogs = true;
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // ===========================
  // HEADERS PADRÃO
  // ===========================
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
} 