import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

int recebeOpcao() {
  int i;
  try {
    i = int.parse(stdin.readLineSync());
  } catch (e) {
    print('Informe um Valor Numérico');
    i = recebeOpcao();
  }

  return i;
}

void today() async {
  var data = await getData();
  print(
      '################################ HG Brasil - Cotação ################################');
  print(
      'Dia: ${data['date']} apresenta as seguintes Cotações: \n ${data['data']}');
}

Future getData() async {
  String url = 'https://api.hgbrasil.com/finance?key=7ccb5244';
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body)['results']['currencies'];
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];
    Map formatedMap = Map();
    formatedMap['date'] = now();
    formatedMap['data'] = '${usd['name']} : ${usd['buy']}, '
        '${eur['name']} : ${eur['buy']}, '
        '${gbp['name']} : ${gbp['buy']}, '
        '${ars['name']} : ${ars['buy']}, '
        '${btc['name']} : ${btc['buy']}';
    return formatedMap;
  } else{
    throw ('Falhou');
  }
}

String now() {
  var now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/ ${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(2, '0')} ';
}

void registerData() async {
  var hgData = await getData();
  dynamic fileData = readFile();
  bool exists = false;

  fileData = (fileData != null && fileData.length > 0
      ? json.decode(fileData)
      : List());

  fileData.forEach((data) {
    if (data['date'] == now()) {
      exists = true;
    }
  });

  if (!exists) {
    fileData.add({'date': now(), 'data': '${hgData['data']}'});
    Directory dir = Directory.current;
    File file = new File(dir.path + '/resultado.txt');
    RandomAccessFile raf = file.openSync(mode: FileMode.write);

    raf.writeStringSync(json.encode(fileData).toString());
    raf.flushSync();
    raf.closeSync();
    print('\nDados Salvos Com Sucesso!!!');
  } else {
    print('\nRegistro não Adicionado, Ja existe log financeiro de hoje cadastradr!');
  }
}

String readFile() {
  Directory dir = Directory.current;
  File file = new File(dir.path + '/resultado.txt');

  if (!file.existsSync()) {
    print('Arquivo não encontrado!');
    return null;
  }
  return file.readAsStringSync();
}

void listData() {
   dynamic fileData = readFile();
   fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : List());

   print('\n\n################# Listagem dos dados #################');

   fileData.forEach((data) {
     print('${data['date']} -> ${data['data']}');
   });

 }