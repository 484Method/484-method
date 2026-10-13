import 'package:flutter_test/flutter_test.dart';
import 'package:method484/services/audio_recorder_service.dart';

/// Alimenta uma sequência de volumes (RMS por chunk de ~100 ms) e devolve,
/// pra cada chunk, se o timer de silêncio seria (re)armado.
List<bool> _run(List<double> levels) {
  final d = SpeechActivityDetector();
  return [for (final l in levels) d.feed(l)];
}

void main() {
  group('detecção de fala (auto-stop da gravação)', () {
    test('iPhone baixinho: palavra curta abaixo de 600 é fala', () {
      // "pizza" no iPhone (relato de 2026-10-12): ruído ~25, fala ~300-450.
      // Com o limiar fixo antigo (600) nada armava e a gravação não parava.
      final armed = _run([20, 25, 300, 450, 280, 30, 25, 22]);
      expect(armed.sublist(2, 5), everyElement(isTrue));
      expect(armed.sublist(5), everyElement(isFalse)); // silêncio → para
    });

    test('frase: o fim mais baixo continua contando como fala', () {
      // Começo forte, fim bem mais baixo (sílabas átonas do fim da frase).
      final armed = _run([100, 3000, 2500, 500, 400, 450, 100, 90]);
      expect(armed[1], isTrue);
      expect(armed.sublist(3, 6), everyElement(isTrue)); // antes: cortava aqui
      expect(armed.sublist(6), everyElement(isFalse));
    });

    test('sala barulhenta: ruído contínuo não segura a gravação', () {
      final armed = _run([300, 310, 290, 3000, 2800, 320, 300, 310]);
      expect(armed.sublist(0, 3), everyElement(isFalse));
      expect(armed.sublist(3, 5), everyElement(isTrue));
      expect(armed.sublist(5), everyElement(isFalse));
    });

    test('fala logo no 1º chunk é reconhecida quando o silêncio chega', () {
      // Sem silêncio antes, ainda não dá pra medir o ruído: a fala é
      // reconhecida (e o timer armado) no primeiro chunk de silêncio.
      final armed = _run([400, 350, 30, 30]);
      expect(armed[0], isFalse);
      expect(armed[2], isTrue);
      expect(armed[3], isFalse);
    });

    test('microfone alto em sala silenciosa: igual ao comportamento antigo',
        () {
      final armed = _run([2000, 1800, 50, 40]);
      expect(armed[0], isTrue); // passou de 600 → fala na hora
      expect(armed.sublist(2), everyElement(isFalse));
    });

    test('aquecimento do microfone (bytes zerados) não conta', () {
      expect(_run([0, 0, 0]), everyElement(isFalse));
    });
  });
}
