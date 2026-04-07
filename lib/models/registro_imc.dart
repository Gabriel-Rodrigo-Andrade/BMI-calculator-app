import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FaixaImc {
  final double limiteMaximo;
  final String faixa;
  final String classificacao;

  const FaixaImc({
    required this.limiteMaximo,
    required this.faixa,
    required this.classificacao,
  });
}

class RegistroImc {
  final int id;
  final String nomePaciente;
  final double peso;
  final double altura;
  final String observacao;

  const RegistroImc({
    required this.id,
    required this.nomePaciente,
    required this.peso,
    required this.altura,
    required this.observacao,
  });

  static const List<FaixaImc> faixasClassificacao = [
    FaixaImc(
      limiteMaximo: 18.5,
      faixa: 'Menor que 18,5',
      classificacao: 'Abaixo do peso',
    ),
    FaixaImc(
      limiteMaximo: 25,
      faixa: 'De 18,5 ate 24,9',
      classificacao: 'Peso normal',
    ),
    FaixaImc(
      limiteMaximo: 30,
      faixa: 'De 25,0 ate 29,9',
      classificacao: 'Sobrepeso',
    ),
    FaixaImc(
      limiteMaximo: 35,
      faixa: 'De 30,0 ate 34,9',
      classificacao: 'Obesidade grau I',
    ),
    FaixaImc(
      limiteMaximo: 40,
      faixa: 'De 35,0 ate 39,9',
      classificacao: 'Obesidade grau II',
    ),
    FaixaImc(
      limiteMaximo: double.infinity,
      faixa: 'Maior ou igual a 40,0',
      classificacao: 'Obesidade grau III',
    ),
  ];

  double get imc {
    // Calculei o IMC sob demanda a partir de peso e altura, sem armazenar um
    // campo extra.
    // (Doc: getters dart)
    return peso / (altura * altura);
  }

  String get classificacao {
    for (final FaixaImc faixa in faixasClassificacao) {
      if (imc < faixa.limiteMaximo) {
        return faixa.classificacao;
      }
    }

    return faixasClassificacao.last.classificacao;
  }

  String get statusVisual {
    if (classificacao == 'Peso normal') {
      return 'Saudavel';
    }
    return classificacao;
  }

  Color get corStatus {
    if (imc < 18.5) {
      return AppColors.neonBlue;
    }
    if (imc < 25) {
      return AppColors.neonGreen;
    }
    if (imc < 30) {
      return AppColors.neonOrange;
    }
    return AppColors.neonRed;
  }

  int get healthScore {
    final int score = 100 - ((imc - 22).abs() * 8).round();
    // Limitei o score calculado para manter a metrica dentro de uma faixa
    // visual previsivel.
    // (Doc: num.clamp dart)
    return score.clamp(38, 96);
  }

  String get caloriasSugeridas {
    final int valor = 1700 + (healthScore * 4);
    return '$valor kcal';
  }

  double get progressoAltura {
    return (altura / 2.10).clamp(0.15, 1.0);
  }

  double get progressoPeso {
    return (peso / 120).clamp(0.15, 1.0);
  }
}
