import 'package:flutter/material.dart';

import 'privacy_policy_screen.dart';

/// Termos de Uso. Acessível no onboarding e pelo menu. RASCUNHO — texto de
/// base para um beta com voz + pagamento; revisar com apoio jurídico antes de
/// cobrar em escala. Curto e direto, no mesmo espírito da política.
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget section(String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Termos de Uso')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('484 Method — Termos de Uso',
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text('Última atualização: julho de 2026',
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 24),
                section(
                  'Aceitação',
                  'Ao usar o 484 Method, você concorda com estes Termos e com '
                      'a nossa Política de Privacidade. Se não concordar, não '
                      'use o app.',
                ),
                section(
                  'O que é o 484',
                  'O 484 Method é um treino de fala de inglês: você escuta, '
                      'repete, grava sua voz e recebe feedback de pronúncia. É '
                      'uma ferramenta de prática — não garante fluência, '
                      'aprovação em provas ou qualquer resultado específico.',
                ),
                section(
                  'Fase beta',
                  'O app está em desenvolvimento (beta). Pode conter erros, '
                      'mudar, ficar indisponível ou ser descontinuado sem aviso. '
                      'É oferecido "como está", sem garantias.',
                ),
                section(
                  'Sua conta',
                  'Para usar, você informa nome e e-mail. Você é responsável '
                      'por manter esses dados corretos e pelo uso do app na sua '
                      'conta. O uso é pessoal e não comercial.',
                ),
                section(
                  'Sua voz e seus dados',
                  'O app grava e processa sua voz para gerar feedback e medir '
                      'sua evolução, conforme a Política de Privacidade. Você '
                      'consente com isso ao aceitar e pode apagar seus dados a '
                      'qualquer momento.',
                ),
                section(
                  'Apoio "Beta Fundador" e pagamento',
                  'O apoio Beta Fundador é um pagamento único via Pix que '
                      'sustenta o projeto e concede o status de Fundador. Como '
                      'compra online, você tem direito de arrependimento em até '
                      '7 dias (CDC). Não há renovação automática nem assinatura.',
                ),
                section(
                  'Conduta',
                  'Não tente burlar, sobrecarregar ou acessar indevidamente o '
                      'app, nem enviar conteúdo de terceiros como se fosse seu. '
                      'Podemos suspender contas que abusem do serviço.',
                ),
                section(
                  'Conteúdo',
                  'As lições, áudios, textos e a marca 484 Method são nossos ou '
                      'licenciados. Você pode usá-los para praticar no app, mas '
                      'não redistribuir ou revender.',
                ),
                section(
                  'Limitação de responsabilidade',
                  'Por ser um beta gratuito/de apoio, não nos responsabilizamos '
                      'por perdas decorrentes de indisponibilidade, erros ou do '
                      'resultado do seu aprendizado. Nada aqui afasta direitos '
                      'que a lei brasileira garante ao consumidor.',
                ),
                section(
                  'Alterações',
                  'Podemos atualizar estes Termos. Mudanças relevantes serão '
                      'avisadas no app. O uso após a atualização vale como '
                      'aceite da nova versão.',
                ),
                section(
                  'Lei aplicável',
                  'Estes Termos seguem a lei brasileira. Eventuais questões '
                      'serão tratadas no foro do domicílio do consumidor.',
                ),
                section(
                  'Contato',
                  'Dúvidas sobre estes Termos: g.paranayba@gmail.com.',
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen()),
                  ),
                  child: const Text('Ler a Política de Privacidade'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
