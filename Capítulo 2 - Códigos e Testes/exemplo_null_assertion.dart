class ConfiguradorApp {
  late String _apiUrl;
  String? _token;
  
  void inicializar({required String apiUrl, String? token}) {
    _apiUrl = apiUrl;
    _token = token;
  }
  
  String get apiUrl => _apiUrl;
  
  String get tokenGarantido {
    // Usando assertion operator - cuidado com RuntimeError!
    return _token!;
  }
  
  String get tokenSeguro {
    return _token ?? 'token_padrao';
  }
}

void main() {
  var config = ConfiguradorApp();
  
  config.inicializar(
    apiUrl: 'https://api.exemplo.com',
    token: 'abc123xyz',
  );
  
  print('API URL: ${config.apiUrl}');
  print('Token garantido: ${config.tokenGarantido}');
  print('Token seguro: ${config.tokenSeguro}');
  
  // Exemplo perigoso - descomente para ver o erro
  var configSemToken = ConfiguradorApp();
  configSemToken.inicializar(apiUrl: 'https://api.teste.com');
  
  print('Token seguro (sem token): ${configSemToken.tokenSeguro}');
  
  // Esta linha causaria RuntimeError:
  // print('Token garantido (sem token): ${configSemToken.tokenGarantido}');
}