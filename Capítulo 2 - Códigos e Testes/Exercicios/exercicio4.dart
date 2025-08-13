// Exercício 4: Parser JSON Tipado
// Crie um parser JSON que utiliza type inference para automaticamente deserializar objetos.

// Implemente JsonParser com método:
// - parse<T>(String json, T Function(Map<String, dynamic>) fromJson)

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

void main() {
  // Exemplo 1: Parse de um objeto simples
  final jsonPessoa = '''
    {
      "nome": "João Silva",
      "idade": 30,
      "email": "joao@example.com"
    }
  ''';

  final pessoa = JsonParser.parse<Pessoa>(
    jsonPessoa,
    (json) => Pessoa.fromJson(json),
  );

  print('Pessoa: ${pessoa.nome}, ${pessoa.idade} anos');
  print('Email: ${pessoa.email}');
  print('---');

  // Exemplo 2: Parse de uma lista de objetos
  final jsonListaProdutos = '''
    [
      {"id": 1, "nome": "Notebook", "preco": 3500.0},
      {"id": 2, "nome": "Smartphone", "preco": 2000.0},
      {"id": 3, "nome": "Tablet", "preco": 1500.0}
    ]
  ''';

  final produtos = JsonParser.parseList<Produto>(
    jsonListaProdutos,
    (json) => Produto.fromJson(json),
  );

  print('Lista de Produtos:');
  for (var produto in produtos) {
    print('${produto.id} - ${produto.nome}: R\$ ${produto.preco}');
  }
}

// Modelo de exemplo para Pessoa
class Pessoa {
  final String nome;
  final int idade;
  final String email;

  Pessoa({required this.nome, required this.idade, required this.email});

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      nome: json['nome'] as String,
      idade: json['idade'] as int,
      email: json['email'] as String,
    );
  }
}

// Modelo de exemplo para Produto
class Produto {
  final int id;
  final String nome;
  final double preco;

  Produto({required this.id, required this.nome, required this.preco});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as int,
      nome: json['nome'] as String,
      preco: json['preco'] as double,
    );
  }
}