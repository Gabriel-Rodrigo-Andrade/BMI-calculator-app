import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FundoNeon extends StatelessWidget {
  final Widget child;

  const FundoNeon({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundTop,
            AppColors.backgroundBottom,
            AppColors.backgroundDeep,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Coloquei a pintura da malha neon atras do conteudo principal para
          // nao depender de imagem de fundo.
          // (Doc: Stack, CustomPaint e CustomPainter flutter)
          CustomPaint(
            painter: RedeNeonPainter(),
            size: Size.infinite,
          ),
          Positioned(
            top: -70,
            right: -30,
            child: GlowOrb(
              tamanho: 220,
              cor: AppColors.neonBlue.withAlpha(45),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: GlowOrb(
              tamanho: 180,
              cor: AppColors.neonGreen.withAlpha(30),
            ),
          ),
          Positioned(
            top: 200,
            left: 40,
            child: GlowOrb(
              tamanho: 90,
              cor: AppColors.neonGreen.withAlpha(26),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class RedeNeonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linha = Paint()
      ..color = AppColors.neonBlue.withAlpha(45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final Paint brilho = Paint()
      ..color = AppColors.neonGreen.withAlpha(65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Usei coordenadas proporcionais ao tamanho disponivel para o desenho se
    // adaptar a telas diferentes.
    // (Doc: Canvas, Paint, Offset e Size flutter)
    final List<Offset> pontos = [
      Offset(size.width * 0.18, size.height * 0.08),
      Offset(size.width * 0.36, size.height * 0.03),
      Offset(size.width * 0.58, size.height * 0.08),
      Offset(size.width * 0.74, size.height * 0.02),
      Offset(size.width * 0.84, size.height * 0.14),
      Offset(size.width * 0.12, size.height * 0.33),
      Offset(size.width * 0.34, size.height * 0.25),
      Offset(size.width * 0.52, size.height * 0.30),
      Offset(size.width * 0.78, size.height * 0.27),
      Offset(size.width * 0.20, size.height * 0.62),
      Offset(size.width * 0.44, size.height * 0.56),
      Offset(size.width * 0.70, size.height * 0.65),
    ];

    for (int i = 0; i < pontos.length - 1; i++) {
      canvas.drawLine(pontos[i], pontos[i + 1], linha);
    }

    for (final Offset ponto in pontos) {
      canvas.drawCircle(ponto, 4, brilho);
      canvas.drawCircle(
        ponto,
        2.6,
        Paint()..color = AppColors.neonGreen.withAlpha(190),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Evitei repinturas desnecessarias porque esse fundo e estatico.
    // (Doc: shouldRepaint CustomPainter flutter)
    return false;
  }
}

class GlowOrb extends StatelessWidget {
  final double tamanho;
  final Color cor;

  const GlowOrb({
    super.key,
    required this.tamanho,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tamanho,
      width: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Usei um gradiente radial para criar um halo difuso e simular uma
        // fonte de luz.
        // (Doc: BoxDecoration e RadialGradient flutter)
        gradient: RadialGradient(
          colors: [cor, Colors.transparent],
        ),
      ),
    );
  }
}

class PainelNeon extends StatelessWidget {
  final Widget child;

  const PainelNeon({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.stroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class BarraSuperiorTela extends StatelessWidget {
  final String titulo;

  const BarraSuperiorTela({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleButtonNeon(
          icone: Icons.arrow_back_ios_new_rounded,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            titulo,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class CircleButtonNeon extends StatelessWidget {
  final IconData icone;
  final VoidCallback onPressed;

  const CircleButtonNeon({
    super.key,
    required this.icone,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panelSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icone, color: AppColors.neonBlue),
      ),
    );
  }
}

class LinhaClassificacao extends StatelessWidget {
  final String faixa;
  final String classificacao;

  const LinhaClassificacao({
    super.key,
    required this.faixa,
    required this.classificacao,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: AppColors.neonGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$faixa: $classificacao',
              style: const TextStyle(
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndicadorMetrica extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;
  final double progresso;
  final Color cor;

  const IndicadorMetrica({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
    required this.progresso,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cor),
            boxShadow: [
              BoxShadow(
                color: cor.withAlpha(50),
                blurRadius: 16,
              ),
            ],
          ),
          child: Icon(icone, color: cor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$titulo: $valor',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progresso,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(cor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
