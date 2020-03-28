import 'package:ExtratorDeDadosFinanceiros/ExtratorDeDadosFinanceiros.dart';

void main(List<String> arguments) {
  print('################################ Inicio ################################');
  print('Selecione uma das opções abaxo');
  print('1 - ver a cotação de hoje;');
  print('2 - registrar cotação de hoje;');
  print('3 - Ver cotações registradas;');

  switch(3){
    case 1: today(); break;
    case 2: registerData(); break;
    case 3: listData(); break;
    default: print('\n\n opção invalida');break;
  }
}