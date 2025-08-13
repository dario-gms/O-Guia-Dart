//Exercício 5: Sistema de Logging
//Desenvolva um sistema de logging que utiliza null safety para metadados opcionais.

// Implemente Logger com diferentes níveis e metadados opcionais
// Deve suportar: debug, info, warning, error
// Metadados: timestamp, userId?, sessionId?, extra?

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;
  final Map<String, dynamic>? extra;
  
  LogEntry({
    required this.level,
    required this.message,
    DateTime? timestamp,
    this.userId,
    this.sessionId,
    this.extra,
  }) : timestamp = timestamp ?? DateTime.now();
  
  @override
  String toString() {
    var buffer = StringBuffer();
    buffer.write('[${level.name.toUpperCase()}] ');
    buffer.write('${timestamp.toIso8601String()} ');
    
    if (userId != null) {
      buffer.write('User:$userId ');
    }
    
    if (sessionId != null) {
      buffer.write('Session:$sessionId ');
    }
    
    buffer.write('- $message');
    
    if (extra != null && extra!.isNotEmpty) {
      buffer.write(' | Extra: $extra');
    }
    
    return buffer.toString();
  }
}

class Logger {
  final List<LogEntry> _entries = [];
  LogLevel _minLevel = LogLevel.debug;
  
  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }
  
  void debug(
    String message, {
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  }) {
    _log(LogLevel.debug, message, userId, sessionId, extra);
  }
  
  void info(
    String message, {
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  }) {
    _log(LogLevel.info, message, userId, sessionId, extra);
  }
  
  void warning(
    String message, {
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  }) {
    _log(LogLevel.warning, message, userId, sessionId, extra);
  }
  
  void error(
    String message, {
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  }) {
    _log(LogLevel.error, message, userId, sessionId, extra);
  }
  
  void _log(
    LogLevel level,
    String message,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  ) {
    if (level.index >= _minLevel.index) {
      var entry = LogEntry(
        level: level,
        message: message,
        userId: userId,
        sessionId: sessionId,
        extra: extra,
      );
      
      _entries.add(entry);
      print(entry);
    }
  }
  
  List<LogEntry> getEntries({LogLevel? level}) {
    if (level == null) return List.unmodifiable(_entries);
    return _entries.where((e) => e.level == level).toList();
  }
  
  void clear() => _entries.clear();
}

void main() {
  // Cria uma instância do logger
  final logger = Logger();

  // Configura o nível mínimo de log (opcional)
  logger.setMinLevel(LogLevel.info);

  // Exemplo 1: Logs com diferentes níveis e metadados
  logger.debug('Este debug não será exibido (nível mínimo é info)');
  
  logger.info('Aplicação iniciada', 
    userId: 'user123',
    sessionId: 'session456'
  );
  
  logger.warning('Conexão instável detectada',
    userId: 'user123',
    extra: {'tentativas': 3, 'timeout': 5000}
  );
  
  logger.error('Falha ao salvar dados',
    userId: 'user123',
    sessionId: 'session456',
    extra: {
      'arquivo': 'relatorio.pdf',
      'erro': 'Permissão negada',
      'stackTrace': '...'
    }
  );

  // Exemplo 2: Log sem metadados opcionais
  logger.info('Processamento concluído');

  // Exemplo 3: Recuperando e exibindo logs específicos
  print('\nTodos os logs registrados:');
  logger.getEntries().forEach(print);

  print('\nApenas logs de erro:');
  logger.getEntries(level: LogLevel.error).forEach(print);

  // Exemplo 4: Limpando os logs
  logger.clear();
  print('\nLogs após limpeza: ${logger.getEntries().length} entradas');
}