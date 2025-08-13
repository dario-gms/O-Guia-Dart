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