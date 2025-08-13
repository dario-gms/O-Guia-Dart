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
  var joao = Funcionario('João Santos', 'Designer', 4500.0);
  
  print('=== Funcionários Contratados ===');
  maria.apresentar();
  print('---');
  joao.apresentar();
  
  print('\n=== Aplicando Aumentos ===');
  maria.darAumento(10.0);
  joao.darAumento(8.5);
}

void main() {
  exemploOrientadoObjetos();
}