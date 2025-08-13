// Repository com Filtros
// Crie um repository genérico que suporte filtros tipados e ordenação.

// Implemente FilterableRepository<T> com métodos:
// - filter(bool Function(T) predicate)
// - orderBy<R>(R Function(T) selector, {bool descending})
// - paginate(int page, int size)

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

void main() {
  final repo = FilterableRepository<String>();

  repo.add('banana');
  repo.add('abacaxi');
  repo.add('laranja');
  repo.add('maçã');
  repo.add('uva');

  print('--- Filtro: contém "a" ---');
  final filtrados = repo.filter((item) => item.contains('a'));
  print(filtrados);

  print('--- Ordenado por ordem alfabética ---');
  final ordenados = repo.orderBy((item) => item);
  print(ordenados);

  print('--- Ordenado decrescente ---');
  final ordenadosDesc = repo.orderBy((item) => item, descending: true);
  print(ordenadosDesc);

  print('--- Paginação: página 1, tamanho 2 ---');
  final pagina = repo.paginate(1, 2);
  print(pagina);
}
