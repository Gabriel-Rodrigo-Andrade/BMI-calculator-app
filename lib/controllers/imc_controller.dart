import 'package:flutter/foundation.dart';

import '../models/registro_imc.dart';

class ImcController extends ChangeNotifier {
  // Centralizei os registros aqui e avisei a interface sempre que algo muda,
  // para evitar logica duplicada nas telas.
  // (Doc: ChangeNotifier e notifyListeners flutter)
  final List<RegistroImc> _registros = [
    const RegistroImc(
      id: 1,
      nomePaciente: 'Ana Silva',
      peso: 62,
      altura: 1.68,
      observacao: 'Acompanha rotina de caminhada e alimentacao equilibrada.',
    ),
    const RegistroImc(
      id: 2,
      nomePaciente: 'Carlos Mendes',
      peso: 87,
      altura: 1.75,
      observacao: 'Precisa ajustar refeicoes e aumentar atividades fisicas.',
    ),
    const RegistroImc(
      id: 3,
      nomePaciente: 'Aina Silva',
      peso: 74,
      altura: 1.61,
      observacao: 'Consulta com foco em reducao de gordura corporal.',
    ),
    const RegistroImc(
      id: 4,
      nomePaciente: 'Anna Silva',
      peso: 58,
      altura: 1.66,
      observacao: 'Paciente com boa adesao ao planejamento alimentar.',
    ),
  ];

  int _proximoId = 5;

  List<RegistroImc> get registros {
    // Expus os dados para a UI sem permitir alteracoes diretas fora do
    // controller.
    // (Doc: List.unmodifiable dart)
    return List.unmodifiable(_registros);
  }

  int get proximoId {
    return _proximoId;
  }

  void adicionarRegistro(RegistroImc registro) {
    _registros.add(registro);
    _proximoId++;
    notifyListeners();
  }

  void editarRegistro(RegistroImc registro) {
    final int indice = _registros.indexWhere((item) => item.id == registro.id);

    if (indice != -1) {
      _registros[indice] = registro;
      notifyListeners();
    }
  }

  void excluirRegistro(int id) {
    _registros.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
