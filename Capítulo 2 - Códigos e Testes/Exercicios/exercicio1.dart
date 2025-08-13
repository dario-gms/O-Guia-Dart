// Exercício 1: Sistema de Validação
// Implemente um sistema de validação genérico que utiliza null safety e generics para validar diferentes tipos de dados.

// Implemente as classes ValidationResult<T> e Validator<T>
// ValidationResult deve conter: value (T?), errors (List<String>), isValid (bool)
// Validator deve ter um método validate que retorna ValidationResult<T>

class ValidationResult<T> {
  final T? value;
  final List<String> errors;
  
  ValidationResult(this.value, this.errors);
  
  bool get isValid => errors.isEmpty && value != null;
  
  static ValidationResult<T> success<T>(T value) => 
    ValidationResult(value, []);
    
  static ValidationResult<T> failure<T>(List<String> errors) => 
    ValidationResult(null, errors);
}

abstract class Validator<T> {
  ValidationResult<T> validate(dynamic input);
}

class EmailValidator extends Validator<String> {
  @override
  ValidationResult<String> validate(dynamic input) {
    if (input is! String) {
      return ValidationResult.failure(['Input deve ser uma string']);
    }
    
    if (input.isEmpty) {
      return ValidationResult.failure(['Email não pode estar vazio']);
    }
    
    if (!input.contains('@')) {
      return ValidationResult.failure(['Email deve conter @']);
    }
    
    return ValidationResult.success(input);
  }
}

void main() {
  final validator = EmailValidator();

  final result1 = validator.validate('usuario@exemplo.com');
  print('Resultado 1: ${result1.value}, Válido: ${result1.isValid}, Erros: ${result1.errors}');

  final result2 = validator.validate('usuarioexemplo.com');
  print('Resultado 2: ${result2.value}, Válido: ${result2.isValid}, Erros: ${result2.errors}');
}
