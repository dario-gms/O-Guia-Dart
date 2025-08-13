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