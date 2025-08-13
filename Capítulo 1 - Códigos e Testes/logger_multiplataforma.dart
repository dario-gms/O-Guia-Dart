import 'dart:io' if (dart.library.html) 'dart:html';

abstract class Logger {
  void log(String mensagem);
  void error(String erro);
}

class LoggerConsole implements Logger {
  @override
  void log(String mensagem) {
    var timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] INFO: $mensagem');
  }
  
  @override 
  void error(String erro) {
    var timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] ERROR: $erro');
  }
}

class LoggerWeb implements Logger {
  @override
  void log(String mensagem) {
    var timestamp = DateTime.now().toIso8601String();
    // Na web, também usa print, mas poderia enviar para um serviço
    print('[$timestamp] WEB-INFO: $mensagem');
  }
  
  @override
  void error(String erro) {
    var timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] WEB-ERROR: $erro');
  }
}

class LoggerFactory {
  static Logger create() {
    try {
      // Tenta detectar se está em ambiente nativo
      Platform.operatingSystem;
      return LoggerConsole();
    } catch (e) {
      // Se falhar, está na web
      return LoggerWeb();
    }
  }
}

void exemploLoggerMultiplataforma() {
  var logger = LoggerFactory.create();
  
  logger.log('Aplicação iniciada');
  logger.log('Processando dados do usuário...');
  
  try {
    // Simula uma operação que pode dar erro
    var resultado = 10 ~/ 2; // Divisão inteira
    logger.log('Operação concluída: resultado = $resultado');
  } catch (e) {
    logger.error('Erro na operação: $e');
  }
  
  logger.log('Sistema de log funcionando perfeitamente!');
}

void main() {
  exemploLoggerMultiplataforma();
}