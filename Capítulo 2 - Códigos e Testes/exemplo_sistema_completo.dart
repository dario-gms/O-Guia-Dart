import 'dart:convert';
import 'dart:io';

// Interface base
abstract interface class Serializable {
  Map<String, dynamic> toJson();
}

// Modelo de dados com null safety
class Tarefa implements Serializable {
  final String id;
  final String titulo;
  final String? descricao;
  final DateTime criadaEm;
  DateTime? concluidaEm;
  bool get concluida => concluidaEm != null;
  
  Tarefa({
    required this.id,
    required this.titulo,
    this.descricao,
    DateTime? criadaEm,
    this.concluidaEm,
  }) : criadaEm = criadaEm ?? DateTime.now();
  
  void marcarComoConcluida() {
    concluidaEm ??= DateTime.now();
  }
  
  void marcarComoPendente() {
    concluidaEm = null;
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'criadaEm': criadaEm.toIso8601String(),
      'concluidaEm': concluidaEm?.toIso8601String(),
    };
  }
  
  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      criadaEm: DateTime.parse(json['criadaEm'] as String),
      concluidaEm: json['concluidaEm'] != null 
        ? DateTime.parse(json['concluidaEm'] as String)
        : null,
    );
  }
  
  @override
  String toString() {
    var status = concluida ? '✅' : '⏳';
    return '$status $titulo${descricao != null ? ' - $descricao' : ''}';
  }
}

// Gerenciador genérico com type safety
class GerenciadorTarefas<T extends Serializable> {
  final List<T> _itens = [];
  final String _nomeArquivo;
  
  GerenciadorTarefas(this._nomeArquivo);
  
  void adicionar(T item) {
    _itens.add(item);
    print('Item adicionado: $item');
  }
  
  bool remover(bool Function(T) predicate) {
    final index = _itens.indexWhere(predicate);
    if (index >= 0) {
      final item = _itens.removeAt(index);
      print('Item removido: $item');
      return true;
    }
    return false;
  }
  
  T? buscar(bool Function(T) predicate) {
    try {
      return _itens.firstWhere(predicate);
    } catch (_) {
      return null;
    }
  }
  
  List<T> filtrar(bool Function(T) predicate) {
    return _itens.where(predicate).toList();
  }
  
  Future<void> salvarArquivo() async {
    try {
      final arquivo = File(_nomeArquivo);
      final dados = _itens.map((item) => item.toJson()).toList();
      final json = jsonEncode(dados);
      await arquivo.writeAsString(json);
      print('Dados salvos em $_nomeArquivo');
    } catch (e) {
      print('Erro ao salvar: $e');
    }
  }
  
  Future<void> carregarArquivo(T Function(Map<String, dynamic>) fromJson) async {
    try {
      final arquivo = File(_nomeArquivo);
      if (!arquivo.existsSync()) {
        print('Arquivo $_nomeArquivo não existe');
        return;
      }
      
      final conteudo = await arquivo.readAsString();
      final List<dynamic> dadosJson = jsonDecode(conteudo);
      
      _itens.clear();
      for (var itemJson in dadosJson) {
        _itens.add(fromJson(itemJson as Map<String, dynamic>));
      }
      
      print('${_itens.length} itens carregados de $_nomeArquivo');
    } catch (e) {
      print('Erro ao carregar: $e');
    }
  }
  
  List<T> get todos => List.unmodifiable(_itens);
  int get total => _itens.length;
}

// Sistema de comandos interativo
class SistemaTarefas {
  late final GerenciadorTarefas<Tarefa> _gerenciador;
  
  SistemaTarefas() {
    _gerenciador = GerenciadorTarefas<Tarefa>('tarefas.json');
  }
  
  Future<void> inicializar() async {
    print('🎯 Sistema de Tarefas com Dart');
    print('================================');
    await _gerenciador.carregarArquivo(Tarefa.fromJson);
    _mostrarMenu();
  }
  
  void _mostrarMenu() {
    print('\nComandos disponíveis:');
    print('1 - Listar tarefas');
    print('2 - Adicionar tarefa');
    print('3 - Concluir tarefa');
    print('4 - Remover tarefa');
    print('5 - Filtrar concluídas');
    print('6 - Filtrar pendentes');
    print('7 - Salvar e sair');
    print('Digite o número da opção:');
  }
  
  Future<void> executarComando(String comando) async {
    switch (comando.trim()) {
      case '1':
        _listarTarefas();
        break;
      case '2':
        await _adicionarTarefa();
        break;
      case '3':
        await _concluirTarefa();
        break;
      case '4':
        await _removerTarefa();
        break;
      case '5':
        _filtrarConcluidas();
        break;
      case '6':
        _filtrarPendentes();
        break;
      case '7':
        await _salvarESair();
        return;
      default:
        print('Comando inválido!');
    }
    _mostrarMenu();
  }
  
  void _listarTarefas() {
    print('\n📋 Todas as tarefas (${_gerenciador.total}):');
    if (_gerenciador.todos.isEmpty) {
      print('Nenhuma tarefa encontrada.');
      return;
    }
    
    for (var i = 0; i < _gerenciador.todos.length; i++) {
      print('${i + 1}. ${_gerenciador.todos[i]}');
    }
  }
  
  Future<void> _adicionarTarefa() async {
    stdout.write('Título da tarefa: ');
    final titulo = stdin.readLineSync() ?? '';
    
    if (titulo.isEmpty) {
      print('Título não pode estar vazio!');
      return;
    }
    
    stdout.write('Descrição (opcional): ');
    final descricao = stdin.readLineSync();
    
    final tarefa = Tarefa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: descricao?.isEmpty ?? true ? null : descricao,
    );
    
    _gerenciador.adicionar(tarefa);
  }
  
  Future<void> _concluirTarefa() async {
    _listarTarefas();
    stdout.write('Número da tarefa para concluir: ');
    final input = stdin.readLineSync() ?? '';
    
    final indice = int.tryParse(input);
    if (indice == null || indice < 1 || indice > _gerenciador.total) {
      print('Número inválido!');
      return;
    }
    
    final tarefa = _gerenciador.todos[indice - 1];
    tarefa.marcarComoConcluida();
    print('Tarefa concluída: $tarefa');
  }
  
  Future<void> _removerTarefa() async {
    _listarTarefas();
    stdout.write('Número da tarefa para remover: ');
    final input = stdin.readLineSync() ?? '';
    
    final indice = int.tryParse(input);
    if (indice == null || indice < 1 || indice > _gerenciador.total) {
      print('Número inválido!');
      return;
    }
    
    final tarefa = _gerenciador.todos[indice - 1];
    _gerenciador.remover((t) => t.id == tarefa.id);
  }
  
  void _filtrarConcluidas() {
    final concluidas = _gerenciador.filtrar((t) => t.concluida);
    print('\n✅ Tarefas concluídas (${concluidas.length}):');
    
    if (concluidas.isEmpty) {
      print('Nenhuma tarefa concluída.');
      return;
    }
    
    for (var i = 0; i < concluidas.length; i++) {
      print('${i + 1}. ${concluidas[i]}');
    }
  }
  
  void _filtrarPendentes() {
    final pendentes = _gerenciador.filtrar((t) => !t.concluida);
    print('\n⏳ Tarefas pendentes (${pendentes.length}):');
    
    if (pendentes.isEmpty) {
      print('Nenhuma tarefa pendente.');
      return;
    }
    
    for (var i = 0; i < pendentes.length; i++) {
      print('${i + 1}. ${pendentes[i]}');
    }
  }
  
  Future<void> _salvarESair() async {
    await _gerenciador.salvarArquivo();
    print('👋 Sistema encerrado. Até logo!');
    exit(0);
  }
}

void main() async {
  final sistema = SistemaTarefas();
  await sistema.inicializar();
  
  // Loop interativo
  while (true) {
    final comando = stdin.readLineSync() ?? '';
    await sistema.executarComando(comando);
  }
}