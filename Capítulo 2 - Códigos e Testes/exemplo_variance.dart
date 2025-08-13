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