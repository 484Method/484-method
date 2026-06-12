import '../models/lesson.dart';

/// Lição 1 da Fase 1 — "Você já sabe inglês".
/// Conteúdo conforme docs/curriculo-fase1.md. Threshold permissivo (60):
/// o objetivo pedagógico desta lição é confiança, não rigor.
const licao01 = Lesson(
  id: 'fase1-licao01',
  title: 'Você já sabe inglês',
  objective: 'Você vai falar 5 palavras em inglês que já conhece — '
      'e descobrir que seu inglês já começou.',
  approvalThreshold: 60,
  items: [
    LessonItem(
      text: 'banana',
      translation: 'banana',
      example: 'I eat a banana every day.',
      exampleTranslation: 'Eu como uma banana todo dia.',
      audioAsset: 'audio/fase1/licao01/banana.mp3',
    ),
    LessonItem(
      text: 'cinema',
      translation: 'cinema',
      example: "Let's go to the cinema tonight.",
      exampleTranslation: 'Vamos ao cinema hoje à noite.',
      audioAsset: 'audio/fase1/licao01/cinema.mp3',
    ),
    LessonItem(
      text: 'hotel',
      translation: 'hotel',
      example: 'The hotel is near the airport.',
      exampleTranslation: 'O hotel fica perto do aeroporto.',
      audioAsset: 'audio/fase1/licao01/hotel.mp3',
    ),
    LessonItem(
      text: 'internet',
      translation: 'internet',
      example: 'The internet is slow today.',
      exampleTranslation: 'A internet está lenta hoje.',
      audioAsset: 'audio/fase1/licao01/internet.mp3',
    ),
    LessonItem(
      text: 'pizza',
      translation: 'pizza',
      example: 'I want a pizza, please.',
      exampleTranslation: 'Eu quero uma pizza, por favor.',
      audioAsset: 'audio/fase1/licao01/pizza.mp3',
    ),
  ],
);
