# Capítulo 1: Introdução ao Dart e Ecossistema

## Bem-vindo ao mundo do Dart!

Dart é uma linguagem de programação moderna e versátil que tem ganhado cada vez mais espaço no mercado de desenvolvimento. Se você já se perguntou como criar aplicativos móveis, web ou desktop com uma única linguagem, o Dart é a resposta que você estava procurando. Neste capítulo, vamos entender a trajetória desta linguagem, seus paradigmas e como ela funciona nos bastidores.

## 1.1 História e Contexto Tecnológico

### O Nascimento do Dart

Em 2011, o Google estava enfrentando um problema comum na época: as limitações do JavaScript. Embora o JavaScript fosse (e ainda seja) amplamente usado, ele apresentava desafios para desenvolver aplicações grandes e complexas. Foi então que nasceu o Dart, inicialmente projetado para ser um substituto do JavaScript nos navegadores.

Imagine o JavaScript como uma ferramenta que funcionava bem para pequenos projetos, mas quando você precisava construir algo maior - como um prédio de vários andares - começavam a aparecer rachaduras na estrutura. O Dart surgiu como uma solução mais robusta para esses desafios arquiteturais.

### A Evolução: De Navegador para Multiplataforma

O que começou como um projeto para navegadores se transformou em algo muito maior. Hoje, o Dart é a linguagem oficial do Flutter, permitindo criar aplicativos para:
- **Mobile**: iOS e Android
- **Web**: Navegadores modernos
- **Desktop**: Windows, macOS e Linux
- **Backend**: Servidores e APIs

### Exemplo Prático: A Evolução do Sistema de Tipos

Vamos ver na prática como o Dart evoluiu ao longo do tempo:

```dart
// Dart 1.0 (opcional types) - Versão antiga
var name = 'João';
var age; // poderia ser qualquer tipo - perigoso!

// Dart 2.0+ (sound null safety) - Versão moderna
String name = 'João';
int? age; // explicitamente nullable - mais seguro!

void exemploEvolucao() {
  // Versão antiga: podia gerar erros em tempo de execução
  // age = 'trinta'; // Isso compilava, mas quebrava o app!
  
  // Versão moderna: erros capturados antes mesmo de executar
  age = 30; // ✅ Correto
  // age = 'trinta'; // ❌ Erro de compilação - muito melhor!
  
  print('Nome: $name');
  print('Idade: ${age ?? 'Não informado'}');
}
```

**Como testar este código:**
1. Abra seu editor de código favorito (VS Code, IntelliJ, etc.)
2. Crie um arquivo `evolucao_dart.dart`
3. Cole o código acima
4. No terminal, execute: `dart run evolucao_dart.dart`
5. **Importante**: Teste descomentar a linha `age = 'trinta';` para ver o erro de compilação

## 1.2 Paradigmas Suportados

O Dart é como um canivete suíço da programação - ele suporta diferentes formas de resolver problemas. Vamos explorar os três principais paradigmas que você usará no dia a dia.

### Programação Imperativa: "Faça isso, depois aquilo"

É o estilo mais direto de programar, onde você dá comandos sequenciais ao computador:

```dart
// Exemplo real: Sistema de pontuação de um jogo
void exemploImperativo() {
  var pontuacao = 0;
  var nivel = 1;
  
  // Simulando rounds de um jogo
  for (int round = 1; round <= 5; round++) {
    var pontosRound = round * 10;
    pontuacao += pontosRound;
    
    // A cada 50 pontos, sobe de nível
    if (pontuacao >= nivel * 50) {
      nivel++;
      print('Parabéns! Você subiu para o nível $nivel');
    }
    
    print('Round $round: +$pontosRound pontos (Total: $pontuacao)');
  }
  
  print('Jogo finalizado! Pontuação final: $pontuacao (Nível $nivel)');
}
```

**Como testar:**
1. Salve como `jogo_pontuacao.dart`
2. Execute: `dart run jogo_pontuacao.dart`
3. Observe a sequência lógica dos comandos

### Programação Orientada a Objetos: "Criando objetos do mundo real"

Aqui criamos "moldes" (classes) que representam coisas do mundo real:

```dart
// Exemplo real: Sistema de funcionários de uma empresa
class Funcionario {
  String nome;
  String cargo;
  double salario;
  DateTime dataContratacao;
  
  // Construtor - como criar um novo funcionário
  Funcionario(this.nome, this.cargo, this.salario) 
    : dataContratacao = DateTime.now();
  
  // Método para calcular tempo de empresa
  int tempoEmpresaEmMeses() {
    return DateTime.now().difference(dataContratacao).inDays ~/ 30;
  }
  
  // Método para dar aumento
  void darAumento(double percentual) {
    double aumentoValor = salario * (percentual / 100);
    salario += aumentoValor;
    print('$nome recebeu aumento de ${percentual.toStringAsFixed(1)}%');
    print('Novo salário: R\$ ${salario.toStringAsFixed(2)}');
  }
  
  void apresentar() {
    print('Nome: $nome');
    print('Cargo: $cargo'); 
    print('Salário: R\$ ${salario.toStringAsFixed(2)}');
    print('Tempo na empresa: ${tempoEmpresaEmMeses()} meses');
  }
}

void exemploOrientadoObjetos() {
  // Criando funcionários
  var maria = Funcionario('Maria Silva', 'Desenvolvedora', 5000.0);
  var joão = Funcionario('João Santos', 'Designer', 4500.0);
  
  print('=== Funcionários Contratados ===');
  maria.apresentar();
  print('---');
  joão.apresentar();
  
  print('\n=== Aplicando Aumentos ===');
  maria.darAumento(10.0);
  joão.darAumento(8.5);
}
```

**Como testar:**
1. Salve como `sistema_funcionarios.dart`
2. Execute: `dart run sistema_funcionarios.dart`
3. Experimente criar mais funcionários e dar diferentes aumentos

### Programação Funcional: "Transformando dados como numa linha de produção"

Aqui trabalhamos com transformações de dados de forma elegante:

```dart
// Exemplo real: Análise de vendas de uma loja
void exemploFuncional() {
  // Dados de vendas (simulando um sistema real)
  var vendas = [
    {'produto': 'Notebook', 'valor': 2500.0, 'categoria': 'Eletrônicos'},
    {'produto': 'Mouse', 'valor': 50.0, 'categoria': 'Eletrônicos'},
    {'produto': 'Livro Dart', 'valor': 80.0, 'categoria': 'Livros'},
    {'produto': 'Smartphone', 'valor': 1200.0, 'categoria': 'Eletrônicos'},
    {'produto': 'Curso Flutter', 'valor': 300.0, 'categoria': 'Educação'},
    {'produto': 'Headphone', 'valor': 150.0, 'categoria': 'Eletrônicos'},
  ];
  
  print('=== Análise de Vendas ===');
  
  // 1. Eletrônicos com valor acima de R$ 100
  var eletronicosCaros = vendas
      .where((venda) => venda['categoria'] == 'Eletrônicos')
      .where((venda) => (venda['valor'] as double) > 100.0)
      .map((venda) => venda['produto'])
      .toList();
  
  print('Eletrônicos caros: $eletronicosCaros');
  
  // 2. Total de vendas por categoria
  var categorias = vendas.map((v) => v['categoria'] as String).toSet();
  
  for (var categoria in categorias) {
    var totalCategoria = vendas
        .where((v) => v['categoria'] == categoria)
        .map((v) => v['valor'] as double)
        .reduce((a, b) => a + b);
    
    print('Total $categoria: R\$ ${totalCategoria.toStringAsFixed(2)}');
  }
  
  // 3. Produto mais caro
  var produtoMaisCaro = vendas
      .reduce((atual, proximo) => 
          (atual['valor'] as double) > (proximo['valor'] as double) 
              ? atual : proximo);
  
  print('Produto mais caro: ${produtoMaisCaro['produto']} - R\$ ${produtoMaisCaro['valor']}');
  
  // 4. Aplicando desconto de 10% em todos os produtos
  var vendasComDesconto = vendas
      .map((venda) => {
          'produto': venda['produto'],
          'valor_original': venda['valor'],
          'valor_com_desconto': (venda['valor'] as double) * 0.9,
          'categoria': venda['categoria'],
        })
      .toList();
  
  print('\n=== Preços com 10% de desconto ===');
  vendasComDesconto.forEach((venda) {
    print('${venda['produto']}: R\$ ${(venda['valor_com_desconto'] as double).toStringAsFixed(2)}');
  });
}
```

**Como testar:**
1. Salve como `analise_vendas.dart`
2. Execute: `dart run analise_vendas.dart`
3. Tente modificar os filtros e criar novas análises

## 1.3 Compilação e Targets: Uma linguagem, múltiplas plataformas

Uma das grandes vantagens do Dart é sua capacidade de rodar em diferentes ambientes. É como ter um tradutor universal que adapta seu código para diferentes "idiomas" que cada plataforma entende.

### Como o Dart se adapta a diferentes plataformas

```dart
// Este exemplo funciona tanto no mobile quanto na web
import 'dart:io' if (dart.library.html) 'dart:html';

class DetectorPlataforma {
  static String identificarPlataforma() {
    // O Dart automaticamente escolhe a implementação correta
    try {
      // Tenta usar dart:io (mobile/desktop)
      return 'Plataforma Nativa: ${Platform.operatingSystem}';
    } catch (e) {
      // Se falhar, está na web
      return 'Plataforma Web: Navegador';
    }
  }
  
  static void mostrarInformacoes() {
    print('=== Informações da Plataforma ===');
    print(identificarPlataforma());
    
    // Informações específicas por plataforma
    try {
      print('Número de processadores: ${Platform.numberOfProcessors}');
      print('Versão do sistema: ${Platform.operatingSystemVersion}');
    } catch (e) {
      print('Executando no navegador - informações limitadas por segurança');
    }
  }
}

void exemploMultiplataforma() {
  DetectorPlataforma.mostrarInformacoes();
  
  // Este código funciona em qualquer lugar
  var dados = ['mobile', 'web', 'desktop'];
  var plataformasSuportadas = dados
      .map((plat) => plat.toUpperCase())
      .join(', ');
  
  print('Dart suporta: $plataformasSuportadas');
}
```

**Como testar em diferentes ambientes:**

**Para Desktop/Mobile:**
1. Salve como `detector_plataforma.dart`
2. Execute: `dart run detector_plataforma.dart`

**Para Web:**
1. Crie um projeto web: `dart create -t web meu_projeto_web`
2. Substitua o conteúdo de `web/main.dart` pelo código acima
3. Execute: `dart run -d web`
4. Abra o navegador no endereço mostrado

### Exemplo Real: Sistema de Log Multiplataforma

Vamos criar algo que você usaria no mundo real - um sistema de log que funciona em qualquer plataforma:

```dart
import 'dart:io' if (dart.library.html) 'dart:html' as html;

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
```

**Como testar:**
1. Salve como `logger_multiplataforma.dart`
2. Teste no desktop: `dart run logger_multiplataforma.dart`
3. Para testar na web, siga os passos do exemplo anterior

## Resumo do Capítulo

Neste primeiro capítulo, você aprendeu:

1. **A história do Dart**: Como nasceu para resolver problemas do JavaScript e evoluiu para ser uma linguagem multiplataforma
2. **Os paradigmas**: Como usar programação imperativa, orientada a objetos e funcional no Dart
3. **Compilação multiplataforma**: Como o mesmo código pode rodar em mobile, web e desktop

## Próximos Passos

Antes de prosseguir para o próximo capítulo:

1. **Teste todos os códigos**: Execute cada exemplo e observe os resultados
2. **Experimente modificações**: Mude valores, adicione novas funcionalidades
3. **Crie suas próprias variações**: Use os conceitos aprendidos para criar exemplos pessoais

**Lembre-se**: A programação é como aprender a andar de bicicleta - você precisa praticar! Não tenha medo de cometer erros, eles fazem parte do aprendizado.

**[Capítulo 2: Sistema de Tipos Avançado](cap-2-tipos-avancados.md)**
