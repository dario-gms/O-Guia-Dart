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

void main() {
  exemploFuncional();
}