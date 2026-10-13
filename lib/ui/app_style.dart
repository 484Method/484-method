import 'package:flutter/material.dart';

/// Paleta do visual "clean" (inspirado nos apps da Apple, 2026-10-13).
///
/// Regras pras telas:
/// - Neutros fazem quase tudo; o acento (navy no claro, dourado no escuro —
///   `colorScheme.primary`) marca SÓ o que é ação.
/// - Cor com significado: verde = aprovado, vermelho = gravando/erro,
///   dourado = progresso/selo. Nada de cartão colorido "pra enfeitar".
/// - Hierarquia vem do tamanho/peso do texto, não de caixa alta nem de cor.
/// - Cartões brancos sem sombra sobre o fundo cinza; listas no estilo
///   "inset grouped" do iOS ([InsetGroup]).
/// - Uma ação principal por tela, larga, embaixo ([BottomActions]).
/// - Texto da UI sem travessão (—) e sem jargão interno.
class AppColors {
  const AppColors._({
    required this.background,
    required this.card,
    required this.fill,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.separator,
    required this.accentFill,
    required this.green,
    required this.greenFill,
    required this.red,
    required this.redFill,
    required this.goldFill,
  });

  static const navy = Color(0xFF1B2D4F);
  static const gold = Color(0xFFC9A252);

  /// Fundo da página (systemGroupedBackground).
  final Color background;

  /// Cartões e grupos (secondarySystemGroupedBackground).
  final Color card;

  /// Preenchimento neutro: trilha de progresso, chip, botão desabilitado.
  final Color fill;

  final Color label;
  final Color secondaryLabel;
  final Color tertiaryLabel;
  final Color separator;

  /// Acento bem claro: fundo de botão secundário ("tinted") e de ícone.
  final Color accentFill;

  final Color green;
  final Color greenFill;
  final Color red;
  final Color redFill;
  final Color goldFill;

  static const light = AppColors._(
    background: Color(0xFFF2F2F7),
    card: Color(0xFFFFFFFF),
    fill: Color(0xFFE5E5EA),
    label: Color(0xFF1C1C1E),
    secondaryLabel: Color(0xFF6C6C70),
    tertiaryLabel: Color(0xFFAEAEB2),
    separator: Color(0xFFD1D1D6),
    accentFill: Color(0xFFE6E9F0),
    green: Color(0xFF248A3D),
    greenFill: Color(0xFFE3F5E8),
    red: Color(0xFFFF3B30),
    redFill: Color(0xFFFFE5E3),
    goldFill: Color(0xFFF7F0E1),
  );

  static const dark = AppColors._(
    background: Color(0xFF000000),
    card: Color(0xFF1C1C1E),
    fill: Color(0xFF2C2C2E),
    label: Color(0xFFFFFFFF),
    secondaryLabel: Color(0xFF98989F),
    tertiaryLabel: Color(0xFF636366),
    separator: Color(0xFF38383A),
    accentFill: Color(0xFF2C2A24),
    green: Color(0xFF30D158),
    greenFill: Color(0xFF0F2A17),
    red: Color(0xFFFF453A),
    redFill: Color(0xFF3A1513),
    goldFill: Color(0xFF2C2618),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Medidas compartilhadas (pontos lógicos).
class AppStyle {
  static const double pagePadding = 20;
  static const double cardRadius = 20;
  static const double buttonRadius = 14;
  static const double buttonHeight = 52;
  static const double gap = 12;

  /// Largura máxima do conteúdo (tablet/desktop não esticam o layout).
  static const double maxContentWidth = 520;
}

/// Lista no estilo "inset grouped" do iOS: um cartão branco arredondado
/// com as linhas separadas por fio fino (recuado à esquerda).
class InsetGroup extends StatelessWidget {
  const InsetGroup({super.key, required this.children, this.header, this.footer});

  final List<Widget> children;

  /// Rótulo pequeno acima do grupo (ex.: "Trilha 1").
  final String? header;

  /// Nota pequena abaixo do grupo.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Divider(height: 0.5, thickness: 0.5, color: c.separator),
        ));
      }
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(header!, style: text.titleSmall?.copyWith(color: c.secondaryLabel)),
          ),
        Material(
          color: c.card,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyle.cardRadius)),
          child: Column(mainAxisSize: MainAxisSize.min, children: rows),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(footer!, style: text.bodySmall),
          ),
      ],
    );
  }
}

/// Ícone em quadradinho colorido, como nos Ajustes do iOS.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, this.color, this.size = 30});

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(icon, size: size * 0.6, color: Colors.white),
    );
  }
}

/// Área de ações presa embaixo da tela (zona do polegar), respeitando a
/// área segura do iPhone. A 1ª ação é a principal (FilledButton largo).
class BottomActions extends StatelessWidget {
  const BottomActions({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
          AppStyle.pagePadding, 8, AppStyle.pagePadding, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
