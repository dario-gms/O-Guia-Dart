// Este exemplo funciona tanto no mobile quanto na web
import 'dart:io' if (dart.library.html) 'dart:html';

class DetectorPlataforma {
  static String identificarPlataforma() {
    // O Dart automaticamente escolhe a implementação correta
    try {
      // Tenta usar dart:io (mobile/desktop)
      return 'Plataforma Nativa: ${Platform.operatingSystem}';
    } catch (e) {
      // Se falhar, está na web
      return 'Plataforma Web: Navegador';
    }
  }
  
  static void mostrarInformacoes() {
    print('=== Informações da Plataforma ===');
    print(identificarPlataforma());
    
    // Informações específicas por plataforma
    try {
      print('Número de processadores: ${Platform.numberOfProcessors}');
      print('Versão do sistema: ${Platform.operatingSystemVersion}');
    } catch (e) {
      print('Executando no navegador - informações limitadas por segurança');
    }
  }
}

void exemploMultiplataforma() {
  DetectorPlataforma.mostrarInformacoes();
  
  // Este código funciona em qualquer lugar
  var dados = ['mobile', 'web', 'desktop'];
  var plataformasSuportadas = dados
      .map((plat) => plat.toUpperCase())
      .join(', ');
  
  print('Dart suporta: $plataformasSuportadas');
}

void main() {
  exemploMultiplataforma();
}