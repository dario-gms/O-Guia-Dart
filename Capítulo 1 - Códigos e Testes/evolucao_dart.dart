// Exemplo histórico: Dart 1.0 vs Dart 2.0+

void exemploEvolucao() {
  print('--- Como era no Dart 1.0 (opcional types) ---');
  print('var name = "João";');
  print('var age; // poderia ser qualquer tipo - perigoso!');
  print('age = "trinta"; // Isso compilava, mas podia quebrar o app!');
  print('');
  
  print('--- Como é no Dart 2.0+ (sound null safety) ---');
  String name = 'João';
  int? age; // explicitamente nullable - mais seguro!
  
  // Versão moderna: erros capturados antes mesmo de executar
  age = 30; // ✅ Correto
  // age = 'trinta'; // ❌ Erro de compilação - muito melhor!
  
  print('String name = "João";');
  print('int? age; // explicitamente nullable');
  print('age = 30; // ✅ Correto');
  print('// age = "trinta"; // ❌ Erro de compilação');
  print('');
  print('Resultado:');
  print('Nome: $name');
  print('Idade: ${age ?? 'Não informado'}');
}

void main() {
  print('=== Demonstrando a Evolução do Dart ===');
  exemploEvolucao();
}