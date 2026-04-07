import 'registro_imc.dart';

enum TipoAcao {
  editar,
  excluir,
}

class ResultadoDetalhes {
  final TipoAcao tipo;
  final RegistroImc? registro;

  const ResultadoDetalhes({
    required this.tipo,
    this.registro,
  });
}
