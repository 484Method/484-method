import 'package:flutter/material.dart';

import '../ui/app_style.dart';

/// Layout de leitura dos textos legais (privacidade e termos): corpo em 17pt,
/// largura limitada pra linha não ficar comprida demais, títulos de seção
/// pelo peso do texto, sem caixas. O texto é selecionável (dá pra copiar o
/// e-mail de contato, por exemplo).
class LegalPage extends StatelessWidget {
  const LegalPage({
    super.key,
    required this.title,
    required this.heading,
    required this.updated,
    required this.sections,
    this.footer,
  });

  /// Título pequeno da barra superior.
  final String title;

  /// Título grande no topo do texto.
  final String heading;

  /// Ex.: "Última atualização: julho de 2026".
  final String updated;

  /// (título da seção, corpo).
  final List<(String, String)> sections;

  /// Algo depois da última seção (ex.: link pra outra página).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SelectionArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppStyle.pagePadding, 8, AppStyle.pagePadding, 40),
              children: [
                Text(heading, style: text.headlineLarge),
                const SizedBox(height: 6),
                Text(updated, style: text.bodySmall),
                const SizedBox(height: 28),
                for (final (sectionTitle, body) in sections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sectionTitle, style: text.titleMedium),
                        const SizedBox(height: 6),
                        Text(body, style: text.bodyLarge),
                      ],
                    ),
                  ),
                ?footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Política de privacidade (LGPD). Acessível no onboarding (antes do
/// consentimento) e pelo menu do app. Texto curto e direto — a gravação de
/// voz é dado pessoal sensível e o usuário precisa entender o tratamento.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(
      title: 'Política de privacidade',
      heading: 'Privacidade no 484\u00A0Method',
      updated: 'Última atualização: julho de 2026',
      sections: [
        (
          'O que coletamos',
          'Ao entrar, você informa seu nome e e-mail, que usamos para '
              'acompanhar sua evolução e falar com você sobre o beta. '
              'Para avaliar sua pronúncia, o app grava sua voz durante '
              'os exercícios. Guardamos também seu progresso (minutos '
              'de prática aprovada, lições concluídas, streak), eventos '
              'de uso do app e dados técnicos agregados (navegador, '
              'sistema operacional, idioma do dispositivo). Nunca '
              'coletamos localização precisa por GPS.',
        ),
        (
          'Como usamos sua voz',
          'Nas lições, o áudio é enviado ao serviço de análise de '
              'pronúncia da Microsoft Azure apenas para gerar sua nota '
              'e o feedback, e NÃO é guardado. Os scores podem ser '
              'enviados à Anthropic (Claude) para escrever o feedback '
              'em português. O áudio NÃO é usado para treinar modelos '
              'de IA.',
        ),
        (
          'Gravações do Desafio de 21 dias',
          'Se você entrar no Desafio de 21 dias e autorizar, GUARDAMOS '
              'duas gravações suas (no início e no fim) para montar seu '
              'antes/depois e para revisão da equipe do 484. Ficam num '
              'espaço privado, ligado ao seu identificador anônimo, e '
              'você pode apagá-las quando quiser. É opcional: sem '
              'autorizar, o desafio segue só com sua autoavaliação.',
        ),
        (
          'Por quanto tempo guardamos',
          'As gravações do Desafio (início e fim) ficam guardadas por '
              'até 12 meses após a coleta e depois são apagadas. Nas '
              'lições, o áudio não é guardado. Seu cadastro e progresso '
              'ficam enquanto sua conta existir. Você pode apagar tudo '
              'antes desses prazos, quando quiser.',
        ),
        (
          'Onde os dados ficam',
          'Seu progresso fica no aparelho e, quando há conexão, é '
              'espelhado na nossa base (Supabase). Seu nome e e-mail '
              'ficam guardados à parte, numa tabela de cadastro. Não '
              'coletamos telefone nem endereço.',
        ),
        (
          'Consentimento',
          'A gravação só acontece após o seu aceite explícito no '
              'início do app. Sem o aceite, não é possível praticar, '
              'porque o método é baseado na sua voz.',
        ),
        (
          'Exclusão dos seus dados',
          'A qualquer momento, em "Apagar meus dados" no menu, você '
              'remove seu cadastro (nome/e-mail), progresso, streak, '
              'lições, consentimento e as gravações do desafio, tanto '
              'do aparelho quanto da nossa base. A ação é definitiva.',
        ),
        (
          'Contato',
          'Dúvidas sobre seus dados: g.paranayba@gmail.com.',
        ),
      ],
    );
  }
}
