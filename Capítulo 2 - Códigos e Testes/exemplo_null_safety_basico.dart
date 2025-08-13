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