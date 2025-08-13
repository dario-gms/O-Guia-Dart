# Sistema de Tipos Avançado

## Objetivos do Capítulo

Após concluir este capítulo, você será capaz de:

- Aplicar Null Safety de forma eficiente em projetos Dart, utilizando operadores null-aware
- Implementar sistemas de tipos genéricos com restrições (bounded type parameters)
- Compreender e aplicar covariance e contravariance em hierarquias de tipos
- Utilizar type inference avançada para criar código mais limpo e expressivo
- Construir arquiteturas robustas usando o sistema de tipos do Dart
- Identificar e corrigir erros comuns relacionados ao sistema de tipos

## Pré-requisitos

- Dart 3.0+ instalado no sistema
- Conhecimento básico de programação orientada a objetos
- Familiaridade com conceitos fundamentais do Dart (classes, funções, variáveis)
- Editor de código configurado para Dart (VS Code, IntelliJ ou similar)

## Sumário

- [Null Safety em Profundidade](#null-safety-em-profundidade)
- [Generics Avançados](#generics-avançados)
- [Type Inference Sofisticada](#type-inference-sofisticada)
- [Exemplos de Código](#exemplos-de-código)
- [Boas Práticas e Advertências](#boas-práticas-e-advertências)
- [Casos de Uso Reais](#casos-de-uso-reais)
- [Exercícios Práticos](#exercícios-práticos)
- [Resumo](#resumo)
- [Glossário](#glossário)
- [Referências](#referências)

## Null Safety em Profundidade

O Null Safety é um dos recursos mais importantes do Dart moderno, introduzido como padrão desde o Dart 2.12. Este sistema garante que valores null sejam tratados explicitamente, eliminando uma das principais fontes de erro em aplicações: o temido NullPointerException.

### Tipos Não-Anuláveis vs Anuláveis

Por padrão, todos os tipos em Dart são **não-anuláveis**, ou seja, não podem receber o valor `null`. Para permitir valores null, devemos usar o operador `?` após o tipo.

```dart
// Tipo não-anulável - nunca pode ser null
String nome = 'João';

// Tipo anulável - pode ser null
String? sobrenome;
int? idade;
```

### Operadores Null-Aware

O Dart oferece diversos operadores especializados para trabalhar com valores potencialmente null:

- **`??`** (null-coalescing): retorna o valor à direita se o da esquerda for null
- **`?.`** (null-aware access): acessa propriedades/métodos apenas se o objeto não for null
- **`!`** (null assertion): força o compilador a tratar um valor como não-null
- **`??=`** (null-aware assignment): atribui valor apenas se a variável for null

## Generics Avançados

Os generics em Dart permitem criar código reutilizável mantendo a segurança de tipos. O sistema avançado inclui restrições de tipos (bounded type parameters) e comportamentos de variance.

### Bounded Type Parameters

Você pode restringir os tipos genéricos usando a palavra-chave `extends`, garantindo que o tipo tenha determinadas características.

```dart
abstract class Identifiable {
  String get id;
}

class Repository<T extends Identifiable> {
  List<T> _items = [];
  
  T? findById(String id) {
    return _items.cast<T?>().firstWhere(
      (item) => item?.id == id,
      orElse: () => null,
    );
  }
}
```

### Covariance e Contravariance

- **Covariance**: permite usar um tipo mais específico onde um tipo mais geral é esperado
- **Contravariance**: permite usar um tipo mais geral onde um tipo mais específico é esperado

## Type Inference Sofisticada

O Dart possui um sistema de inferência de tipos inteligente que pode determinar tipos automaticamente com base no contexto, reduzindo a necessidade de anotações explícitas.

## Exemplos de Código

### Exemplo 1 - Null Safety Básico (exemplo_null_safety_basico.dart)

```dart
void main() {
  // Tipos não-anuláveis
  String nome = 'Maria';
  
  // Tipos anuláveis
  String? sobrenome;
  String? apelido;
  
  // Operador null-coalescing (??)
  String nomeCompleto = nome + ' ' + (sobrenome ?? 'Silva');
  print('Nome completo: $nomeCompleto');
  
  // Null-aware access (?.)
  int? tamanhoApelido = apelido?.length;
  print('Tamanho do apelido: $tamanhoApelido');
  
  // Null-aware assignment (??=)
  apelido ??= 'Sem apelido';
  print('Apelido: $apelido');
  
  // Demonstrando que não podemos atribuir null a tipo não-anulável
  // nome = null; // ERRO: não compila
}
```

**Como testar:**
```bash
dart run exemplo_null_safety_basico.dart
```

**Saída esperada:**
```
Nome completo: Maria Silva
Tamanho do apelido: null
Apelido: Sem apelido
```

Este exemplo demonstra os operadores básicos de null safety. O operador `??` fornece um valor padrão quando a expressão à esquerda é null. O operador `?.` evita erros ao acessar propriedades de objetos potencialmente null.

### Exemplo 2 - Null Assertion e Late Variables (exemplo_null_assertion.dart)

```dart
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
```

**Como testar:**
```bash
dart run exemplo_null_assertion.dart
```

O `late` keyword permite declarar variáveis não-anuláveis que serão inicializadas posteriormente. O assertion operator `!` deve ser usado com extrema cautela, pois pode causar runtime errors.

### Exemplo 3 - Repository Genérico com Bounded Types (exemplo_repository_generico.dart)

```dart
// Interface base para objetos identificáveis
abstract class Identifiable {
  String get id;
  String get nome;
}

// Implementações concretas
class Usuario implements Identifiable {
  @override
  final String id;
  
  @override
  final String nome;
  
  final String email;
  
  Usuario(this.id, this.nome, this.email);
  
  @override
  String toString() => 'Usuario(id: $id, nome: $nome, email: $email)';
}

class Produto implements Identifiable {
  @override
  final String id;
  
  @override
  final String nome;
  
  final double preco;
  
  Produto(this.id, this.nome, this.preco);
  
  @override
  String toString() => 'Produto(id: $id, nome: $nome, preco: $preco)';
}

// Repository genérico com bounded type parameter
class Repository<T extends Identifiable> {
  final List<T> _items = [];
  
  void adicionar(T item) {
    _items.add(item);
  }
  
  T? buscarPorId(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<T> buscarPorNome(String nome) {
    return _items.where((item) => 
      item.nome.toLowerCase().contains(nome.toLowerCase())
    ).toList();
  }
  
  bool remover(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items.removeAt(index);
      return true;
    }
    return false;
  }
  
  List<T> obterTodos() => List.unmodifiable(_items);
  
  int get total => _items.length;
}

void main() {
  // Repository de usuários
  var repoUsuarios = Repository<Usuario>();
  repoUsuarios.adicionar(Usuario('1', 'João Silva', 'joao@email.com'));
  repoUsuarios.adicionar(Usuario('2', 'Maria Santos', 'maria@email.com'));
  
  // Repository de produtos
  var repoProdutos = Repository<Produto>();
  repoProdutos.adicionar(Produto('p1', 'Notebook Dell', 2500.00));
  repoProdutos.adicionar(Produto('p2', 'Mouse Logitech', 150.00));
  
  // Buscas
  var usuario = repoUsuarios.buscarPorId('1');
  print('Usuário encontrado: $usuario');
  
  var produtos = repoProdutos.buscarPorNome('Dell');
  print('Produtos encontrados: $produtos');
  
  print('Total de usuários: ${repoUsuarios.total}');
  print('Total de produtos: ${repoProdutos.total}');
  
  // Demonstrando type safety
  // repoUsuarios.adicionar(Produto('p3', 'Teste', 100)); // ERRO: não compila!
}
```

**Como testar:**
```bash
dart run exemplo_repository_generico.dart
```

Este exemplo mostra como usar bounded type parameters para criar um repository genérico que funciona apenas com objetos que implementam `Identifiable`.

### Exemplo 4 - Covariance e Contravariance (exemplo_variance.dart)

```dart
// Hierarquia de classes
abstract class Animal {
  String get nome;
  void emitirSom();
}

class Gato extends Animal {
  @override
  final String nome;
  
  Gato(this.nome);
  
  @override
  void emitirSom() => print('$nome faz: Miau!');
  
  void arranhar() => print('$nome está arranhando');
}

class Cachorro extends Animal {
  @override
  final String nome;
  
  Cachorro(this.nome);
  
  @override
  void emitirSom() => print('$nome faz: Au au!');
  
  void abanarRabo() => print('$nome está abanando o rabo');
}

// Demonstrando covariance em listas
void exemploCovariance() {
  print('=== Exemplo Covariance ===');
  
  // Lista específica de gatos
  List<Gato> gatos = [Gato('Mimi'), Gato('Garfield')];
  
  // Covariance: podemos tratar lista de Gato como lista de Animal
  List<Animal> animais = gatos;
  
  print('Animais na lista:');
  for (var animal in animais) {
    print('- ${animal.nome}');
    animal.emitirSom();
  }
}

// Demonstrando contravariance em functions
typedef ProcessadorAnimal<T> = void Function(T animal);
typedef CriadorAnimal<T> = T Function(String nome);

void exemploContravariance() {
  print('\n=== Exemplo Contravariance ===');
  
  // Função que processa qualquer animal
  ProcessadorAnimal<Animal> processarAnimal = (animal) {
    print('Processando: ${animal.nome}');
    animal.emitirSom();
  };
  
  // Contravariance: função que aceita Animal pode processar Gato
  ProcessadorAnimal<Gato> processarGato = processarAnimal;
  
  var meuGato = Gato('Whiskers');
  processarGato(meuGato);
}

// Exemplo com generics e variance em uma classe prática
class AnimalShelter<T extends Animal> {
  final List<T> _animais = [];
  
  void adicionar(T animal) {
    _animais.add(animal);
    print('${animal.nome} foi adicionado ao abrigo');
  }
  
  void alimentarTodos() {
    print('Alimentando todos os animais:');
    for (var animal in _animais) {
      print('Alimentando ${animal.nome}');
      animal.emitirSom(); // Animal feliz faz som
    }
  }
  
  List<T> get animais => List.unmodifiable(_animais);
}

void exemploGenericShelter() {
  print('\n=== Exemplo Generic Shelter ===');
  
  var abrigoGatos = AnimalShelter<Gato>();
  abrigoGatos.adicionar(Gato('Luna'));
  abrigoGatos.adicionar(Gato('Oliver'));
  
  var abrigoCachorros = AnimalShelter<Cachorro>();
  abrigoCachorros.adicionar(Cachorro('Buddy'));
  abrigoCachorros.adicionar(Cachorro('Max'));
  
  abrigoGatos.alimentarTodos();
  abrigoCachorros.alimentarTodos();
  
  // Type safety em ação
  print('\nGatos no abrigo: ${abrigoGatos.animais.length}');
  print('Cachorros no abrigo: ${abrigoCachorros.animais.length}');
}

void main() {
  exemploCovariance();
  exemploContravariance();
  exemploGenericShelter();
}
```

**Como testar:**
```bash
dart run exemplo_variance.dart
```

Este exemplo demonstra como covariance permite usar tipos mais específicos em contextos que esperam tipos mais gerais, e como contravariance funciona em funções.

### Exemplo 5 - Type Inference Avançada (exemplo_type_inference.dart)

```dart
// Classe para demonstrar inference
class DataProcessor<T> {
  final List<T> _data = [];
  
  void add(T item) => _data.add(item);
  
  R process<R>(R Function(List<T>) processor) {
    return processor(_data);
  }
  
  List<T> get data => List.unmodifiable(_data);
}

// Function que demonstra inference complexa
Map<K, List<V>> groupBy<T, K, V>(
  Iterable<T> items,
  K Function(T) keyExtractor,
  V Function(T) valueExtractor,
) {
  var result = <K, List<V>>{};
  
  for (var item in items) {
    var key = keyExtractor(item);
    var value = valueExtractor(item);
    
    result.putIfAbsent(key, () => <V>[]).add(value);
  }
  
  return result;
}

// Exemplo com inference em closures e collections
void exemploInferenceBasica() {
  print('=== Type Inference Básica ===');
  
  // Dart infere Map<String, List<int>>
  var numeros = <String, List<int>>{
    'pares': [2, 4, 6, 8],
    'ímpares': [1, 3, 5, 7],
    'primos': [2, 3, 5, 7],
  };
  
  print('Tipo inferido para numeros: Map<String, List<int>>');
  
  // Dart infere os tipos em closures
  var resultado = numeros.map((categoria, lista) {
    var soma = lista.reduce((a, b) => a + b);
    return MapEntry(categoria, soma);
  });
  
  print('Somas por categoria: $resultado');
  
  // Inference em list comprehension-like operations
  var todosNumeros = numeros.values
      .expand((lista) => lista)  // Dart infere Iterable<int>
      .where((n) => n > 3)       // Dart infere Iterable<int>
      .toSet();                  // Dart infere Set<int>
  
  print('Números > 3: $todosNumeros');
}

void exemploInferenceGenerics() {
  print('\n=== Type Inference com Generics ===');
  
  // Dart infere DataProcessor<String>
  var processadorTexto = DataProcessor<String>();
  processadorTexto.add('Dart');
  processadorTexto.add('Flutter');
  processadorTexto.add('Firebase');
  
  // Dart infere o tipo de retorno da closure
  var textoCompleto = processadorTexto.process((dados) {
    return dados.join(' + '); // Dart sabe que retorna String
  });
  
  print('Texto processado: $textoCompleto');
  
  // Dart infere DataProcessor<int>
  var processadorNumeros = DataProcessor<int>()
    ..add(10)
    ..add(20)
    ..add(30);
  
  // Inference em função genérica complexa
  var media = processadorNumeros.process<double>((numeros) {
    return numeros.reduce((a, b) => a + b) / numeros.length;
  });
  
  print('Média calculada: $media');
}

void exemploInferenceCompleta() {
  print('\n=== Type Inference Complexa ===');
  
  // Dados de exemplo
  var vendas = [
    {'produto': 'Notebook', 'categoria': 'Eletrônicos', 'valor': 2500.0},
    {'produto': 'Mouse', 'categoria': 'Eletrônicos', 'valor': 150.0},
    {'produto': 'Livro Dart', 'categoria': 'Livros', 'valor': 80.0},
    {'produto': 'Cabo USB', 'categoria': 'Eletrônicos', 'valor': 25.0},
    {'produto': 'Livro Flutter', 'categoria': 'Livros', 'valor': 95.0},
  ];
  
  // Inference complexa com groupBy customizado
  var vendasPorCategoria = groupBy(
    vendas,
    (venda) => venda['categoria'] as String,  // Key extractor
    (venda) => venda['valor'] as double,      // Value extractor
  );
  
  print('Vendas agrupadas por categoria:');
  vendasPorCategoria.forEach((categoria, valores) {
    var total = valores.reduce((a, b) => a + b);
    print('$categoria: ${valores.length} itens, total: R\$ $total');
  });
  
  // Inference em transformações em cadeia
  var resumo = vendas
      .where((v) => (v['valor'] as double) > 100)
      .map((v) => '${v['produto']}: R\$ ${v['valor']}')
      .join('\n');
  
  print('\nProdutos acima de R\$ 100:\n$resumo');
}

void main() {
  exemploInferenceBasica();
  exemploInferenceGenerics();
  exemploInferenceCompleta();
}
```

**Como testar:**
```bash
dart run exemplo_type_inference.dart
```

### Exemplo 6 - Sistema Completo com Null Safety e Generics (exemplo_sistema_completo.dart)

```dart
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
```

**Como testar:**
```bash
dart run exemplo_sistema_completo.dart
```

**Arquivo pubspec.yaml necessário:**
```yaml
name: exemplo_sistema_completo
description: Sistema de tarefas demonstrando tipos avançados

environment:
  sdk: '>=3.0.0 <4.0.0'
```

Este exemplo demonstra um sistema completo de gerenciamento de tarefas que utiliza todos os conceitos abordados: null safety, generics com bounded types, type inference e serialização JSON.

## Boas Práticas e Advertências

### Null Safety
- **✅ Use tipos não-anuláveis sempre que possível** - isso torna seu código mais seguro e expressa melhor a intenção
- **✅ Prefira operadores null-aware (`??`, `?.`) ao invés de verificações explícitas de null**
- **⚠️ Evite o assertion operator (`!`)** - use apenas quando tiver certeza absoluta de que o valor não é null
- **⚠️ Cuidado com `late` variables** - garanta que sejam inicializadas antes do uso

### Generics
- **✅ Use bounded type parameters para garantir type safety** - `<T extends BaseClass>`
- **✅ Forneça nomes descritivos para type parameters** - `<TEntity extends Identifiable>` é melhor que `<T extends Identifiable>`
- **⚠️ Não abuse de generics** - use apenas quando realmente necessário para reutilização de código
- **✅ Documente restrições de tipos complexos** para facilitar manutenção

### Type Inference
- **✅ Confie na inferência quando ela torna o código mais limpo**
- **✅ Use anotações explícitas em APIs públicas** para melhor documentação
- **⚠️ Evite inferência em casos ambíguos** - seja explícito quando necessário

### Performance
- **⚠️ Null checks têm custo computacional mínimo** - o compilador otimiza na maioria dos casos
- **⚠️ Operadores null-aware são eficientes** - não evite usá-los por questões de performance
- **✅ Use `late` para inicialização lazy quando apropriado**

### Erros Comuns
1. **Usar `!` sem verificação prévia** - pode causar runtime errors
2. **Não inicializar `late` variables** - resulta em LateInitializationError
3. **Misturar tipos anuláveis e não-anuláveis sem cuidado**
4. **Não aproveitar type inference** - código verboso desnecessariamente

## Casos de Uso Reais

### 1. APIs REST com Null Safety

No desenvolvimento de aplicações que consomem APIs REST, null safety é fundamental para tratar dados que podem estar ausentes:

```dart
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;
  
  ApiResponse._({this.data, this.error, required this.success});
  
  factory ApiResponse.success(T data) => 
    ApiResponse._(data: data, success: true);
    
  factory ApiResponse.failure(String error) => 
    ApiResponse._(error: error, success: false);
}
```

**Mercado:** Empresas como iFood, Nubank e Mercado Livre utilizam padrões similares em seus SDKs para Flutter.

### 2. Sistemas de Cache Genéricos

Aplicações modernas frequentemente implementam sistemas de cache tipados:

```dart
abstract class CacheRepository<K, V> {
  Future<V?> get(K key);
  Future<void> put(K key, V value, {Duration? ttl});
  Future<bool> remove(K key);
  Future<void> clear();
}
```

**Mercado:** Frameworks como Firebase Firestore e packages como `hive` utilizam generics extensivamente para type safety.

### 3. State Management com Type Safety

Em aplicações Flutter, gerenciamento de estado tipado é essencial:

```dart
abstract class AppState<T> {
  final T? data;
  final String? error;
  final bool isLoading;
  
  const AppState({this.data, this.error, this.isLoading = false});
}

class DataState<T> extends AppState<T> {
  const DataState(T data) : super(data: data);
}

class LoadingState<T> extends AppState<T> {
  const LoadingState() : super(isLoading: true);
}

class ErrorState<T> extends AppState<T> {
  const ErrorState(String error) : super(error: error);
}
```

**Mercado:** Packages populares como `bloc`, `provider` e `riverpod` implementam padrões similares.

## Exercícios Práticos

### Exercício 1: Sistema de Validação
Implemente um sistema de validação genérico que utiliza null safety e generics para validar diferentes tipos de dados.

```dart
// Implemente as classes ValidationResult<T> e Validator<T>
// ValidationResult deve conter: value (T?), errors (List<String>), isValid (bool)
// Validator deve ter um método validate que retorna ValidationResult<T>
```

### Exercício 2: Repository com Filtros
Crie um repository genérico que suporte filtros tipados e ordenação.

```dart
// Implemente FilterableRepository<T> com métodos:
// - filter(bool Function(T) predicate)
// - orderBy<R>(R Function(T) selector, {bool descending})
// - paginate(int page, int size)
```

### Exercício 3: Sistema de Notificações
Desenvolva um sistema de notificações que utiliza generics para diferentes tipos de payloads.

```dart
// Implemente NotificationSystem<T> com:
// - subscribe(String topic, void Function(T payload) callback)
// - unsubscribe(String topic)
// - notify(String topic, T payload)
```

### Exercício 4: Parser JSON Tipado
Crie um parser JSON que utiliza type inference para automaticamente deserializar objetos.

```dart
// Implemente JsonParser com método:
// - parse<T>(String json, T Function(Map<String, dynamic>) fromJson)
```

### Exercício 5: Sistema de Logging
Desenvolva um sistema de logging que utiliza null safety para metadados opcionais.

```dart
// Implemente Logger com diferentes níveis e metadados opcionais
// Deve suportar: debug, info, warning, error
// Metadados: timestamp, userId?, sessionId?, extra?
```

## Gabarito dos Exercícios

### Solução Exercício 1:
```dart
class ValidationResult<T> {
  final T? value;
  final List<String> errors;
  
  ValidationResult(this.value, this.errors);
  
  bool get isValid => errors.isEmpty && value != null;
  
  static ValidationResult<T> success<T>(T value) => 
    ValidationResult(value, []);
    
  static ValidationResult<T> failure<T>(List<String> errors) => 
    ValidationResult(null, errors);
}

abstract class Validator<T> {
  ValidationResult<T> validate(dynamic input);
}

class EmailValidator extends Validator<String> {
  @override
  ValidationResult<String> validate(dynamic input) {
    if (input is! String) {
      return ValidationResult.failure(['Input deve ser uma string']);
    }
    
    if (input.isEmpty) {
      return ValidationResult.failure(['Email não pode estar vazio']);
    }
    
    if (!input.contains('@')) {
      return ValidationResult.failure(['Email deve conter @']);
    }
    
    return ValidationResult.success(input);
  }
}
```

### Solução Exercício 2:
```dart
class FilterableRepository<T> {
  List<T> _items = [];
  
  void add(T item) => _items.add(item);
  
  List<T> filter(bool Function(T) predicate) {
    return _items.where(predicate).toList();
  }
  
  List<T> orderBy<R extends Comparable>(
    R Function(T) selector, {
    bool descending = false,
  }) {
    var sorted = _items.toList()
      ..sort((a, b) {
        var aValue = selector(a);
        var bValue = selector(b);
        return descending ? bValue.compareTo(aValue) : aValue.compareTo(bValue);
      });
    return sorted;
  }
  
  List<T> paginate(int page, int size) {
    var start = page * size;
    var end = start + size;
    
    if (start >= _items.length) return [];
    if (end > _items.length) end = _items.length;
    
    return _items.sublist(start, end);
  }
}
```

### Solução Exercício 3:
```dart
class NotificationSystem<T> {
  final Map<String, List<void Function(T)>> _subscribers = {};
  
  void subscribe(String topic, void Function(T) callback) {
    _subscribers.putIfAbsent(topic, () => []).add(callback);
  }
  
  bool unsubscribe(String topic, void Function(T) callback) {
    var callbacks = _subscribers[topic];
    if (callbacks != null) {
      return callbacks.remove(callback);
    }
    return false;
  }
  
  void notify(String topic, T payload) {
    var callbacks = _subscribers[topic];
    if (callbacks != null) {
      for (var callback in callbacks) {
        try {
          callback(payload);
        } catch (e) {
          print('Erro ao notificar subscriber: $e');
        }
      }
    }
  }
  
  void clearTopic(String topic) {
    _subscribers.remove(topic);
  }
  
  int getSubscriberCount(String topic) {
    return _subscribers[topic]?.length ?? 0;
  }
}
```

### Solução Exercício 4:
```dart
import 'dart:convert';

class JsonParser {
  static T parse<T>(
    String json, 
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      var decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        throw FormatException('JSON deve ser um objeto');
      }
      return fromJson(decoded);
    } catch (e) {
      throw FormatException('Erro ao fazer parse do JSON: $e');
    }
  }
  
  static List<T> parseList<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      var decoded = jsonDecode(json);
      if (decoded is! List) {
        throw FormatException('JSON deve ser uma lista');
      }
      
      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Item da lista deve ser um objeto');
        }
        return fromJson(item);
      }).toList();
    } catch (e) {
      throw FormatException('Erro ao fazer parse da lista JSON: $e');
    }
  }
}
```

### Solução Exercício 5:
```dart
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
```

## Resumo

Neste capítulo, exploramos os aspectos avançados do sistema de tipos do Dart:

1. **Null Safety** fornece segurança em tempo de compilação contra erros de null pointer
2. **Operadores null-aware** (`??`, `?.`, `!`, `??=`) simplificam o trabalho com valores opcionais
3. **Generics com bounded type parameters** garantem type safety em código reutilizável
4. **Covariance e contravariance** permitem flexibilidade na hierarquia de tipos
5. **Type inference avançada** reduz verbosidade mantendo type safety
6. **`late` keyword** permite inicialização diferida de variáveis não-anuláveis
7. **Assertion operator (`!`)** deve ser usado com cautela extrema
8. **Sistemas genéricos** são fundamentais para arquiteturas escaláveis
9. **Validação de tipos** em runtime complementa a segurança em compile-time
10. **Padrões de null safety** são essenciais em APIs modernas

## Glossário

- **Null Safety**: Sistema que previne erros de null pointer em tempo de compilação
- **Bounded Type Parameters**: Restrições em tipos genéricos usando `extends`
- **Covariance**: Capacidade de usar tipos mais específicos onde tipos gerais são esperados
- **Contravariance**: Capacidade de usar tipos mais gerais onde tipos específicos são esperados
- **Type Inference**: Capacidade do compilador determinar tipos automaticamente
- **Assertion Operator (`!`)**: Operador que força tratamento de valor como não-null
- **Late Variable**: Variável não-anulável com inicialização diferida
- **Null-aware Operators**: Operadores que lidam graciosamente com valores null
- **Generic Type**: Tipo parametrizado que permite reutilização de código
- **Runtime Type Check**: Verificação de tipo durante execução do programa

## Referências

1. **Dart Language Tour - Type System**: https://dart.dev/language/type-system
2. **Dart Null Safety Guide**: https://dart.dev/null-safety
3. **Dart Generics Documentation**: https://dart.dev/language/generics
4. **Effective Dart: Design**: https://dart.dev/guides/language/effective-dart/design
5. **Dart SDK GitHub Repository**: https://github.com/dart-lang/sdk
6. **RFC: Null Safety**: https://github.com/dart-lang/language/blob/master/accepted/2.12/nnbd/feature-specification.md


**Dica**: Para consolidar o aprendizado, pratique implementando um sistema de cache genérico que utilize todos os conceitos apresentados neste capítulo. Experimente criar diferentes implementações (in-memory, file-based, network-based) usando os mesmos tipos genéricos.

**[Capítulo 3: Metaprogramação e Reflection](cap-3-metaprogramacao.md)**