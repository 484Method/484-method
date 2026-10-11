import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:method484/data/curriculum.dart';
import 'package:method484/data/fase1.dart';
import 'package:method484/data/fase2.dart';

/// Integridade do currículo (Trilhas 1 e 2). Roda no `flutter test` do CI de
/// deploy, então currículo quebrado — áudio faltando, id repetido — não vai
/// pro ar.
void main() {
  test('Trilha 1 da Home = fase1Lessons, na mesma ordem', () {
    expect(trilha1.lessons.map((l) => l.id).toList(),
        fase1Lessons.map((l) => l.id).toList());
  });

  test('ids únicos no currículo inteiro', () {
    final ids = curriculum.map((l) => l.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('a fila sempre termina numa lição obrigatória de cada trilha', () {
    // A 1ª lição de uma trilha exige a última NÃO bônus da anterior — se uma
    // trilha só tivesse bônus no fim, tudo bem; mas ela precisa ter alguma
    // obrigatória, senão a próxima trilha herdaria um pré-requisito vazio.
    for (final t in trails) {
      expect(t.lessons.any((l) => !l.bonus), isTrue, reason: t.title);
    }
  });

  test('todo áudio referenciado existe e a pasta está no pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final missingFiles = <String>{};
    final undeclaredDirs = <String>{};
    for (final lesson in curriculum) {
      for (final item in lesson.items) {
        final path = 'assets/${item.audioAsset}';
        if (!File(path).existsSync()) missingFiles.add(path);
        final dir = path.substring(0, path.lastIndexOf('/') + 1);
        if (!pubspec.contains('- $dir\n')) undeclaredDirs.add(dir);
      }
    }
    expect(undeclaredDirs, isEmpty,
        reason: 'pasta de áudio fora do pubspec.yaml (o asset não entra no '
            'build)');
    expect(missingFiles, isEmpty,
        reason: '${missingFiles.length} áudio(s) faltando — rode '
            './tool/gen_lesson_audio.sh (gera só o que falta) e commite os '
            'MP3. Primeiro: ${missingFiles.take(3).join(', ')}');
  });

  group('Trilha 2', () {
    test('4 zonas de 7 lições: 5 obrigatórias, revisão, bônus', () {
      expect(fase2Zones.length, 4);
      for (final z in fase2Zones) {
        expect(z.lessons.length, 7, reason: z.title);
        expect(z.lessons.where((l) => l.bonus).length, 1, reason: z.title);
        expect(z.lessons.last.bonus, isTrue, reason: z.title);
        expect(z.lessons[5].title, startsWith('Revisão'), reason: z.title);
      }
    });

    test('ids sequenciais fase2-licao01..28', () {
      final ids = trilha2.lessons.map((l) => l.id).toList();
      expect(ids, [
        for (var n = 1; n <= 28; n++)
          'fase2-licao${n.toString().padLeft(2, '0')}',
      ]);
    });

    test('todo item tem IPA, fonética e dica de som (curta, sem IPA)', () {
      for (final lesson in trilha2.lessons) {
        expect(lesson.items.length, 5, reason: lesson.id);
        final texts = lesson.items.map((i) => i.text).toSet();
        expect(texts.length, 5, reason: '${lesson.id}: item repetido');
        for (final item in lesson.items) {
          final where = '${lesson.id} / ${item.text}';
          expect(item.ipa, isNotNull, reason: where);
          expect(item.phonetic, isNotNull, reason: where);
          expect(item.soundTip, isNotNull, reason: where);
          expect(item.soundTip!.length, lessThanOrEqualTo(160), reason: where);
          // Dica é instrução física em português — símbolo IPA não ajuda o
          // falso iniciante (o IPA já aparece separado no Livro Aberto).
          expect(item.soundTip, isNot(matches(RegExp('[ˈˌːəɪʊæʌɜɔθðŋʃʒ]'))),
              reason: where);
        }
      }
    });

    test('revisão reaproveita áudio das lições da própria zona', () {
      for (final z in fase2Zones) {
        final review = z.lessons[5];
        final zoneAudio = {
          for (final l in z.lessons)
            if (l != review) ...l.items.map((i) => i.audioAsset),
        };
        for (final item in review.items) {
          expect(zoneAudio, contains(item.audioAsset),
              reason: '${review.id} / ${item.text}');
        }
      }
    });

    test('não repete item da Trilha 1 (a revisão espaçada indexa por texto)',
        () {
      final t1 = {for (final l in fase1Lessons) ...l.items.map((i) => i.text)};
      for (final l in trilha2.lessons) {
        for (final item in l.items) {
          expect(t1, isNot(contains(item.text)), reason: '${l.id}: ${item.text}');
        }
      }
    });
  });
}
