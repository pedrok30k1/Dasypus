# 🧪 Teste das Rotas - API Desativada

Este documento explica como testar o sistema de rotas com a validação da API desativada.

## ✅ Configurações Aplicadas

### 1. **API Service Desativado**
- O método `login()` no `ApiService` foi modificado para retornar dados simulados
- Qualquer email e senha serão aceitos
- Simula um delay de 1 segundo para parecer real

### 2. **Validação do Formulário Desativada**
- A tela de login aceita qualquer email e senha (não vazios)
- Não precisa de formato específico de email
- Não precisa de senha com caracteres especiais

## 🚀 Como Testar

### 1. **Login Simples**
```
Email: teste@teste.com
Senha: 123
```
ou qualquer combinação de email e senha não vazios.

### 2. **Fluxo de Teste**

1. **Abra o aplicativo** - Vai para a tela de login
2. **Digite qualquer email e senha** - Ex: `teste@teste.com` e `123`
3. **Clique em "Entrar"** - Vai simular o login e navegar para o dashboard
4. **Teste as rotas no dashboard** - Use os cards para navegar entre telas

### 3. **Rotas para Testar**

| Botão/Ação | Rota | Descrição |
|-------------|------|-----------|
| **Entrar** (Login) | `/dashboard` | Navega para o dashboard |
| **Cadastre-se** | `/register` | Vai para tela de cadastro |
| **Esqueci a senha?** | `/settings` | Vai para configurações |
| **Perfil** (Dashboard) | `/profile` | Vai para perfil do usuário |
| **Configurações** (Dashboard) | `/settings` | Vai para configurações |
| **Cadastro** (Dashboard) | `/register` | Vai para tela de cadastro |
| **Voltar ao Login** (Dashboard) | `/login` | Volta para login |

## 📱 Dados Simulados

O login retorna dados de um usuário fictício:
```json
{
  "id": 1,
  "nome": "Usuário Teste",
  "email": "email_digitado",
  "cpf": "123.456.789-00",
  "data_criacao": "2024-01-01T00:00:00.000Z",
  "sobre": "Usuário de teste para desenvolvimento",
  "foto_url": "https://via.placeholder.com/150",
  "tipo_usuario": "usuario"
}
```

## 🔄 Como Reativar a API

Para reativar a validação real da API:

### 1. **No ApiService** (`lib/services/api_service.dart`):
```dart
Future<Map<String, dynamic>> login(String email, String senha) async {
  // Remover o código simulado e descomentar o código original
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: ApiConstants.defaultHeaders,
      body: json.encode({
        'email': email,
        'senha': senha,
      }),
    ).timeout(ApiConstants.requestTimeout);

    return _handleResponse(response);
  } catch (e) {
    return {'status': 'error', 'message': 'Erro na conexão: $e'};
  }
}
```

### 2. **No LoginScreen** (`lib/screens/login_screen.dart`):
```dart
void _handleLogin() async {
  if (_formKey.currentState!.validate()) { // Reativar validação
    // ... resto do código
  }
}
```

## 🎯 Exemplos de Teste

### Teste 1: Login → Dashboard
1. Digite: `usuario@teste.com` / `senha123`
2. Clique "Entrar"
3. Deve ir para o dashboard

### Teste 2: Navegação entre Telas
1. No dashboard, clique em "Perfil"
2. Volte ao dashboard
3. Clique em "Configurações"
4. Teste "Voltar ao Login"

### Teste 3: Navegação Direta
1. Na tela de login, clique "Cadastre-se"
2. Volte e clique "Esqueci a senha?"

## ⚠️ Observações

- **Dados são simulados** - Não há persistência real
- **Sem validação** - Aceita qualquer entrada válida
- **Para desenvolvimento** - Use apenas para testar a navegação
- **Reative a API** - Antes de fazer deploy em produção

## 🎉 Pronto para Testar!

Agora você pode testar todas as rotas sem precisar de uma API real. Basta executar o aplicativo e começar a navegar! 🚀 