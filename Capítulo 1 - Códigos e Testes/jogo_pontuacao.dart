// Exemplo real: Sistema de pontuação de um jogo
void exemploImperativo() {
  var pontuacao = 0;
  var nivel = 1;
  
  // Simulando rounds de um jogo
  for (int round = 1; round <= 5; round++) {
    var pontosRound = round * 10;
    pontuacao += pontosRound;
    
    // A cada 50 pontos, sobe de nível
    if (pontuacao >= nivel * 50) {
      nivel++;
      print('Parabéns! Você subiu para o nível $nivel');
    }
    
    print('Round $round: +$pontosRound pontos (Total: $pontuacao)');
  }
  
  print('Jogo finalizado! Pontuação final: $pontuacao (Nível $nivel)');
}

void main() {
  print('=== Sistema de Pontuação do Jogo ===');
  exemploImperativo();
}