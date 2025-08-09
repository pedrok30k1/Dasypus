import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // ===========================
  // SALVAR VALORES
  // ===========================

  /// Salvar um valor int
  static Future<bool> saveInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(key, value);
    } catch (e) {
      print('❌ Erro ao salvar int: $e');
      return false;
    }
  }

  /// Salvar um valor String
  static Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print('❌ Erro ao salvar string: $e');
      return false;
    }
  }

  /// Salvar um valor bool
  static Future<bool> saveBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      print('❌ Erro ao salvar bool: $e');
      return false;
    }
  }

  // ===========================
  // RECUPERAR VALORES
  // ===========================

  /// Recuperar um valor int
  static Future<int?> getInt(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    } catch (e) {
      print('❌ Erro ao recuperar int: $e');
      return null;
    }
  }

  /// Recuperar um valor String
  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print('❌ Erro ao recuperar string: $e');
      return null;
    }
  }

  /// Recuperar um valor bool
  static Future<bool?> getBool(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key);
    } catch (e) {
      print('❌ Erro ao recuperar bool: $e');
      return null;
    }
  }

  // ===========================
  // MÉTODOS ESPECÍFICOS
  // ===========================

  /// Salvar ID do usuário
  static Future<bool> saveUserId(int userId) async {
    return await saveInt('user_id', userId);
  }
  /// Salvar ID do usuário
  static Future<bool> saveUserFilhoId(int userId) async {
    return await saveInt('userFilho_id', userId);
  }
  /// Recuperar ID do usuário
  static Future<int?> getUserId() async {
    return await getInt('user_id');
  }
 /// Recuperar ID do usuário
  static Future<int?> getUserFilhoId() async {
    return await getInt('userFilho_id');
  }
  /// Salvar contador (exemplo)
  static Future<bool> saveCounter(int counter) async {
    return await saveInt('counter', counter);
  }

  /// Recuperar contador (exemplo)
  static Future<int?> getCounter() async {
    return await getInt('counter');
  }

  /// Salvar token de autenticação
  static Future<bool> saveAuthToken(String token) async {
    return await saveString('auth_token', token);
  }

  /// Recuperar token de autenticação
  static Future<String?> getAuthToken() async {
    return await getString('auth_token');
  }

  /// Salvar dados do usuário
  static Future<bool> saveUserData(String userData) async {
    return await saveString('user_data', userData);
  }

  /// Recuperar dados do usuário
  static Future<String?> getUserData() async {
    return await getString('user_data');
  }

  // ===========================
  // LIMPEZA
  // ===========================

  /// Remover uma chave específica
  static Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      print('❌ Erro ao remover chave: $e');
      return false;
    }
  }

  /// Limpar todos os dados
  static Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('❌ Erro ao limpar dados: $e');
      return false;
    }
  }

  /// Verificar se uma chave existe
  static Future<bool> containsKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      print('❌ Erro ao verificar chave: $e');
      return false;
    }
  }
}
